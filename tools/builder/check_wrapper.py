"""Checks gcc's compiler wrapper (gcc/cc-wrapper.sh) by linking with it in the builder container.

    python3 -I check_wrapper.py <cc-wrapper.sh>

`builder check-wrapper` sends this file and the checkout's wrapper into the container. It fills
in the wrapper as the gcc plan does, with the newest installed karate gcc and the glibc and
binutils that gcc depends on, and links three programs with it:

- C against glibc, and Rust against glibc: each runs, its interpreter is that glibc's dynamic
  linker, and its RUNPATH is exactly LD_RUN_PATH's entries, once. rustc links with its bundled
  lld, which ignores LD_RUN_PATH, so this holds only when the wrapper passes the entries itself.
- Rust static against musl: it runs and has no interpreter. A static link given glibc's dynamic
  linker starts that linker and crashes. Its RUNPATH is printed, not checked: the wrapper leaves
  LD_RUN_PATH set for a static link, and binutils' ld, which rustc's musl target links with,
  writes it into the program, where nothing reads it.

Prints one line per program and exits nonzero when any check fails.
"""

import os
import re
import subprocess
import sys
import tempfile
from dataclasses import dataclass
from pathlib import Path

GREETING = "hello from the wrapper"
C_SOURCE = f'#include <stdio.h>\nint main(void) {{ puts("{GREETING}"); return 0; }}\n'
RUST_SOURCE = f'fn main() {{ println!("{GREETING}"); }}\n'
MUSL_TARGET = "x86_64-unknown-linux-musl"
DYNAMIC_LINKER = "ld-linux-x86-64.so.2"


@dataclass(frozen=True)
class Toolchain:
    gcc: Path
    glibc: Path
    binutils: Path
    rust: Path


def installed(ident: str) -> Path:
    """The newest installed package matching ident, as the builder's `doj` resolves it."""
    result = subprocess.run(
        ["doj", "pkg", "path", ident], capture_output=True, text=True, check=False
    )
    if result.returncode != 0:
        sys.exit(f"no installed package matches {ident}: is it built?")
    return Path(result.stdout.strip())


def toolchain() -> Toolchain:
    gcc = installed("karate/gcc")
    deps = (gcc / "DEPS").read_text(encoding="utf-8").split()

    def dep(name: str) -> Path:
        found = [d for d in deps if d.split("/")[1] == name]
        if len(found) != 1:
            sys.exit(f"{gcc}/DEPS names {len(found)} {name} packages, not one")
        return installed(found[0])

    return Toolchain(gcc, dep("glibc"), dep("binutils"), installed("karate/rust"))


def fill(template: str, tools: Toolchain, program: str) -> str:
    """The wrapper for one of gcc's programs, filled in as the gcc plan's wrap-binary does."""
    values = {
        "@shell@": "/bin/sh",
        "@glibc@": str(tools.glibc),
        "@binutils@": str(tools.binutils),
        "@gcc@": str(tools.gcc),
        "@dynamic_linker@": str(tools.glibc / "lib" / DYNAMIC_LINKER),
        "@program@": str(tools.gcc / "bin" / f"{program}.real"),
    }
    for key, value in values.items():
        template = template.replace(key, value)
    return template


def libgcc_dir(gcc: Path) -> Path:
    """Where gcc keeps libgcc_s, which Rust's standard library links against."""
    for lib in ("lib64", "lib"):
        if (gcc / lib / "libgcc_s.so.1").exists():
            return gcc / lib
    sys.exit(f"{gcc} has no libgcc_s.so.1")


def readelf(flag: str, program: Path) -> str:
    return subprocess.run(
        ["readelf", flag, "-W", str(program)],
        capture_output=True,
        text=True,
        check=True,
    ).stdout


def interpreter(program: Path) -> str | None:
    found = re.search(
        r"\[Requesting program interpreter: (.*)\]", readelf("-l", program)
    )
    return found.group(1) if found else None


def runpath(program: Path) -> list[str]:
    """Every RUNPATH and RPATH entry, in order, from every such tag."""
    entries = []
    for tag in re.findall(
        r"\((?:RUNPATH|RPATH)\)\s+Library (?:runpath|rpath): \[(.*)\]",
        readelf("-d", program),
    ):
        entries += tag.split(":")
    return entries


def check(
    name: str,
    program: Path,
    want_interpreter: str | None,
    want_runpath: list[str] | None,
) -> list[str]:
    """What is wrong with a linked program, or nothing. A want_runpath of None checks no RUNPATH."""
    problems = []
    notes = []
    run = subprocess.run([str(program)], capture_output=True, text=True, check=False)
    if run.returncode != 0 or run.stdout.strip() != GREETING:
        problems.append(
            f"running it exited {run.returncode}: {(run.stdout + run.stderr).strip()[:200]}"
        )
    if (got := interpreter(program)) != want_interpreter:
        problems.append(f"interpreter {got}, wanted {want_interpreter}")
    got_runpath = runpath(program)
    if want_runpath is None:
        if got_runpath:
            notes.append(f"RUNPATH {got_runpath}, not checked")
    elif got_runpath != want_runpath:
        problems.append(f"RUNPATH {got_runpath}, wanted {want_runpath}")
    print(
        f"{'ok' if not problems else 'FAIL'} {name}"
        + "".join(f"\n  {p}" for p in problems + notes)
    )
    return problems


def link(command: list[str], env: dict[str, str]) -> bool:
    result = subprocess.run(
        command, capture_output=True, text=True, check=False, env=env
    )
    if result.returncode != 0:
        print(
            f"FAIL linking: {' '.join(command)}\n{result.stdout}{result.stderr}".rstrip()
        )
    return result.returncode == 0


def main(argv: list[str]) -> int:
    if len(argv) != 1:
        print("usage: check_wrapper.py <cc-wrapper.sh>", file=sys.stderr)
        return 2
    template = Path(argv[0]).read_text(encoding="utf-8")
    tools = toolchain()
    print(
        f"gcc {tools.gcc}\nglibc {tools.glibc}\nbinutils {tools.binutils}\nrust {tools.rust}"
    )
    run_path = [str(tools.glibc / "lib"), str(libgcc_dir(tools.gcc))]
    linker = str(tools.glibc / "lib" / DYNAMIC_LINKER)
    rustc = str(tools.rust / "bin" / "rustc")
    failed = False
    with tempfile.TemporaryDirectory() as work_dir:
        work = Path(work_dir)
        cc = work / "cc"
        cc.write_text(fill(template, tools, "gcc"), encoding="utf-8")
        cc.chmod(0o755)
        (work / "hello.c").write_text(C_SOURCE, encoding="utf-8")
        (work / "hello.rs").write_text(RUST_SOURCE, encoding="utf-8")
        env = {**os.environ, "LD_RUN_PATH": ":".join(run_path)}
        programs = [
            (
                "C, glibc",
                [str(cc), "-o", str(work / "c-glibc"), str(work / "hello.c")],
                linker,
                run_path,
            ),
            (
                "Rust, glibc",
                [
                    rustc,
                    "-C",
                    f"linker={cc}",
                    "-o",
                    str(work / "rust-glibc"),
                    str(work / "hello.rs"),
                ],
                linker,
                run_path,
            ),
            (
                "Rust, static musl",
                [
                    rustc,
                    "--target",
                    MUSL_TARGET,
                    "-C",
                    f"linker={cc}",
                    "-o",
                    str(work / "rust-musl"),
                    str(work / "hello.rs"),
                ],
                None,
                None,
            ),
        ]
        for name, command, want_interpreter, want_runpath in programs:
            output = Path(command[command.index("-o") + 1])
            if not link(command, env):
                failed = True
                continue
            failed |= bool(check(name, output, want_interpreter, want_runpath))
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
