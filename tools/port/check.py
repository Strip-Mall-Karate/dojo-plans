"""Checks that every package's plan is ported and loads.

    python3 tools/port/check.py <doj-plan-build> [<package-dir>...]

With no packages, checks every directory holding a plan.sh or a plan.fnl.
A package passes when its plan.fnl exists, holds no UNPORTED block, runs no
shell through b:run, does not name the source project, and `doj-plan-build
show` loads it for each target it lists. Prints one line per failure and a total, and exits nonzero on any.
"""

import json
import os
import re
import subprocess
import sys

# The source project's name and command, which appear nowhere in Dojo's tree.
OLD_NAME = re.compile(r"habitat|\bhab\b|\bHAB_", re.I)
# A b operation on a literal absolute path outside /doj: the runtime reads and
# writes only inside the build, so the build would fail there. A link's
# target may be anywhere.
OUTSIDE = re.compile(r'\(b:(?:write|remove|mkdir|chmod|copy|move) (?:"[^"]*" )?"/(?!doj/)[^"]*"'
                     r'|\(b:symlink "[^"]*" "/(?!doj/)[^"]*"')
# A shell given code to run (`-c`): plan code is Fennel. A shell running the
# package's own script, as ./configure is, is the package's code.
# The source project's builder functions and the shell's own commands, which are not programs.
HELPER_RUN = re.compile(r'\(b:(?:run|capture) \["(join_by|update_pkg_version|pkg_interpreter_for|abspath|trim|record|'
                        r'exists_in_path|add_path_env|pkg_path_for|fix_interpreter|download_file|attach|exit_with|'
                        r'build_line|warn|info|debug|set_runtime_env|push_runtime_env|set_buildtime_env|'
                        r'push_buildtime_env|verify_file|unpack_file|exists|add_env|_[a-z_]+|'
                        r'do_default_\w+|set|unset|shopt|trap|read|type|command|hash|wait|'
                        r'ulimit|umask|alias|exec|export|local|declare|return|exit|source|\.|\[|\[\[|test|cd|'
                        r'pushd|popd|let|eval|builtin|readonly|shift|getopts)"')
SHELL_RUN = re.compile(r'\(b:(run|capture)\s+\[\s*"(bash|sh|zsh|/bin/sh|/bin/bash)"\s+"-c"|\(b:(run|capture)\s+\[\s*"eval"')


def packages(root):
    found = []
    for entry in sorted(os.listdir(root)):
        path = os.path.join(root, entry)
        if os.path.isdir(path) and (os.path.isfile(os.path.join(path, "plan.sh"))
                                    or os.path.isfile(os.path.join(path, "plan.fnl"))):
            found.append(path)
    return found


def check(tool, package):
    plan = os.path.join(package, "plan.fnl")
    if not os.path.isfile(plan):
        return ["no plan.fnl"]
    with open(plan, encoding="utf-8") as f:
        text = f.read()
    problems = []
    if "UNPORTED" in text:
        problems.append(f"{text.count(';; UNPORTED')} unported block(s)")
    if SHELL_RUN.search(text):
        problems.append("runs a shell")
    outside = OUTSIDE.search(text)
    if outside:
        problems.append(f"writes outside the build: {outside.group(0)[:60]}")
    if re.search(r'\(b:run \["doj" "pkg" "binlink"', text):
        problems.append("binlinks a package during the build, outside it")
    helper = HELPER_RUN.search(text)
    if helper:
        problems.append(f"runs the source project's builder function {helper.group(1)}")
    if "@{" in text:
        problems.append("holds a build path marker the port did not turn into Fennel")
    old = OLD_NAME.search(text)
    if old:
        problems.append(f"names the source project: {old.group(0)!r}")
    shown = subprocess.run([tool, "show", package], capture_output=True, text=True, check=False)
    if shown.returncode != 0:
        problems.append("does not load: " + (shown.stderr.strip().splitlines() or ["?"])[-1][:160])
        return problems
    targets = json.loads(shown.stdout).get("targets", [])
    for target in targets[1:]:
        per = subprocess.run([tool, "show", package, "--target", target], capture_output=True, text=True,
                             check=False)
        if per.returncode != 0:
            problems.append(f"does not load for {target}")
    return problems


def main(argv):
    if not argv:
        print(__doc__.strip().splitlines()[2].strip(), file=sys.stderr)
        return 2
    tool = argv[0]
    targets = argv[1:] or packages(".")
    failed = 0
    for package in targets:
        problems = check(tool, package)
        if problems:
            failed += 1
            print(f"{os.path.basename(os.path.normpath(package))}: {'; '.join(problems)}")
    print(f"{len(targets) - failed} of {len(targets)} packages ported and loading", file=sys.stderr)
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
