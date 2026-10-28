"""What the plan builder is doing and what its builds left, read from swamp in the container.

    python3 -I - running | status | failures < state.py

`builder` pipes this file into the container and runs it from /work/plans/swamp. It reads swamp's
records and the container's processes and changes nothing.

- running: whatever builds from /work/plans now, one line each; exits 3 when anything does, and 4
  when only runs swamp never finished are left, with no process behind them
- status: the plans' last builds counted by status, and the failures blocking the most plans
- failures: one line per failed plan, with the last error in its log
"""

import json
import os
import re
import subprocess
import sys
from collections import Counter
from collections.abc import Iterable, Iterator, Mapping
from dataclasses import dataclass
from typing import Any

# `running`'s exit status when something builds, and when only interrupted runs are left. 1 and 2
# stay Python's own: an uncaught error and a usage error.
EXIT_RUNNING = 3
EXIT_INTERRUPTED = 4
# A run in any other state may still read the plans: running, suspended at an approval, or
# interrupted with its state left behind.
TERMINAL_RUN_STATES = frozenset({"succeeded", "failed", "cancelled"})
# Commands that read /work/plans while they run: a workflow re-reads the plans at every wave.
BUILDING_COMMANDS = (
    ("swamp", "workflow", "run"),
    ("swamp", "workflow", "resume"),
    ("swamp", "behavior", "run"),
    ("swamp", "model", "run"),
    ("doj-plan-build", "build"),
)
TOP_BLOCKERS = 10
BUILD_RECORDS = 'modelName == "dojo" && specName == "build"'
# One query names at most this many logs, so a long list of failures is read in a few queries.
LOGS_PER_QUERY = 40

# What a failed log ends with besides its error: make's and ninja's reports of the failed
# command, the compiler's source excerpts and context headers around a diagnostic, and lines that
# point elsewhere.
NOISE = re.compile(
    r"""^(
        g?make(\[\d+\])?:\ |ninja:\ |FAILED:\ |
        \s*\d*\s*\|.*|                              # a compiler's excerpt: `  77 |  #error ...`
        In\ file\ included\ from\ |\s+from\ |
        .*:\ (In\ (static\ )?(member\ )?function|In\ constructor|In\ destructor|In\ instantiation|At\ top\ level)|
        compilation\ terminated\.|
        cc1(plus)?:\ (all|some)\ warnings\ being\ treated\ as\ errors|
        (See|Consult)\ '.*'\ for\ more\ details
    )""",
    re.VERBOSE,
)
# doj-plan-build's own lines. Its summary says which command failed, not why; its other failures
# (a phase's own error, a missing dependency, a package naming the build machine's files) are the
# error themselves.
OWN = "doj-plan-build: "
PHASE_SUMMARY = re.compile(
    r"^doj-plan-build: the `[^`]*` phase failed: `.*` exited with code \d+$"
)
PHASE_FAILED = re.compile(r"^doj-plan-build: the `[^`]*` phase failed: (.*)$")
HOST_PATHS = re.compile(
    r"^doj-plan-build: \d+ files? (does )?names? paths outside /doj:$"
)
# A host-path failure lists every file; the line names this many.
HOST_PATHS_NAMED = 3
ERROR = re.compile(r"error|Error|ERROR|fatal|cannot|not found|No such file")


@dataclass(frozen=True)
class Build:
    plan: str
    status: str
    blocked_by: str | None


@dataclass(frozen=True)
class Unreadable:
    """A build record whose content is not the object the dojo behavior writes."""

    name: str
    content: str


def builds(rows: Iterable[Any]) -> tuple[list[Build], list[Unreadable]]:
    """The build records in rows of `swamp data query --json`, whose `content` is the record as
    an object, as a string holding JSON, or as a string that is not JSON at all."""
    found: list[Build] = []
    unreadable: list[Unreadable] = []
    for row in rows:
        name = str(row.get("name", "?"))
        content = row.get("content")
        if isinstance(content, str):
            try:
                content = json.loads(content)
            except json.JSONDecodeError:
                unreadable.append(Unreadable(name, content))
                continue
        if not isinstance(content, dict) or not isinstance(content.get("plan"), str):
            unreadable.append(Unreadable(name, json.dumps(content)))
            continue
        blocked_by = content.get("blockedBy")
        found.append(
            Build(
                plan=content["plan"],
                status=str(content.get("status")),
                blocked_by=blocked_by if isinstance(blocked_by, str) else None,
            )
        )
    return found, unreadable


def tally(found: Iterable[Build]) -> Counter[str]:
    return Counter(b.status for b in found)


def blockers(found: Iterable[Build]) -> Counter[str]:
    """Each plan at the root of a blocked chain, with the number of plans it blocks. A blocked
    record names the dependency that stopped it, which may itself be blocked; the root is the
    first one in the chain that is not."""
    by_plan = {b.plan: b for b in found}
    roots: Counter[str] = Counter()
    for build in by_plan.values():
        if build.status != "blocked" or build.blocked_by is None:
            continue
        seen = {build.plan}
        root = build.blocked_by
        while (
            (next_build := by_plan.get(root)) is not None
            and next_build.status == "blocked"
            and next_build.blocked_by is not None
            and next_build.blocked_by not in seen
        ):
            seen.add(root)
            root = next_build.blocked_by
        roots[root] += 1
    return roots


def own_failure(marked: list[str]) -> str | None:
    """The last failure doj-plan-build reports itself, other than its summary of a failed
    command."""
    found = None
    for i, line in enumerate(marked):
        if not line.startswith(OWN) or PHASE_SUMMARY.match(line):
            continue
        if HOST_PATHS.match(line):
            named = []
            for following in marked[i + 1 :]:
                if not following.startswith("  "):
                    break
                named.append(following.strip())
            shown = "; ".join(named[:HOST_PATHS_NAMED])
            more = (
                f" and {len(named) - HOST_PATHS_NAMED} more"
                if len(named) > HOST_PATHS_NAMED
                else ""
            )
            found = f"names paths outside /doj: {shown}{more}"
            continue
        phase = PHASE_FAILED.match(line)
        found = phase.group(1) if phase else line.removeprefix(OWN)
    return found


def last_error(log: str) -> str:
    """The line of a failed build's log that says what went wrong. doj-plan-build marks the
    build's standard error with `! `. A failure doj-plan-build found itself is its own message;
    otherwise the error is the last marked line that reads as one, after make's and ninja's
    reports, the compiler's context and doj-plan-build's summary are left out. A build that
    writes its errors to standard output, as b2 does, is read the same way unmarked."""
    lines = log.splitlines()
    marked = [line[2:] for line in lines if line.startswith("! ")]
    own = own_failure(marked)
    if own is not None:
        return own
    unmarked = [line.removeprefix("! ") for line in lines]
    for candidates in (marked, unmarked):
        kept = [
            line.strip()
            for line in candidates
            if line.strip() and not NOISE.match(line) and not line.startswith(OWN)
        ]
        for line in reversed(kept):
            if ERROR.search(line):
                return line
        if kept:
            return kept[-1]
    return lines[-1].strip() if lines else "(empty log)"


@dataclass(frozen=True)
class Process:
    pid: int
    argv: tuple[str, ...]


def building(processes: Iterable[Process]) -> list[Process]:
    """The processes running one of BUILDING_COMMANDS, matched on the program's base name and
    the words after it, wherever the program falls in the command line: first, or after the
    interpreter of a script."""
    found = []
    for process in processes:
        words = [os.path.basename(word) for word in process.argv]
        for command in BUILDING_COMMANDS:
            n = len(command)
            if any(
                tuple(words[i : i + n]) == command for i in range(len(words) - n + 1)
            ):
                found.append(process)
                break
    return found


def unfinished(runs: Iterable[Mapping[str, Any]]) -> list[Mapping[str, Any]]:
    """The workflow runs in `swamp workflow history search --json` that have not ended."""
    return [r for r in runs if r.get("status") not in TERMINAL_RUN_STATES]


def proc_processes(proc: str = "/proc") -> Iterator[Process]:
    for entry in os.listdir(proc):
        if not entry.isdigit():
            continue
        try:
            with open(os.path.join(proc, entry, "cmdline"), "rb") as f:
                raw = f.read()
        except OSError:
            continue  # it ended while we looked
        argv = tuple(a.decode(errors="replace") for a in raw.split(b"\0") if a)
        if argv:  # a zombie has an empty command line
            yield Process(int(entry), argv)


def swamp_json(*args: str) -> Any:
    result = subprocess.run(
        ["swamp", *args, "--json"], capture_output=True, text=True, check=False
    )
    if result.returncode != 0:
        sys.exit(
            f"swamp {' '.join(args)} failed (exit {result.returncode}): {result.stderr.strip()}"
        )
    return json.loads(result.stdout)


def running(
    runs: list[Mapping[str, Any]], processes: list[Process]
) -> tuple[list[str], int]:
    """One line per unfinished run and building process, and `running`'s exit status. A run swamp
    never finished, with no process left to finish it, was interrupted: it builds nothing, but
    swamp may resume it with whatever /work/plans holds then."""
    lines = [
        f"run {r.get('workflowName')} {r.get('runId')} {r.get('status')} since {r.get('startedAt')}"
        for r in runs
    ]
    lines += [f"process {p.pid} {' '.join(p.argv)}" for p in processes]
    if processes:
        return lines, EXIT_RUNNING
    if runs:
        return lines, EXIT_INTERRUPTED
    return lines, 0


def run_running() -> int:
    runs = unfinished(swamp_json("workflow", "history", "search")["results"])
    processes = building(p for p in proc_processes() if p.pid != os.getpid())
    lines, status = running(runs, processes)
    for line in lines:
        print(line)
    if status == EXIT_INTERRUPTED:
        print(
            "No swamp or doj-plan-build process runs, so these runs were interrupted:"
            " end each with `swamp workflow cancel`, or continue it with `swamp workflow recover`"
            " and then `resume`.",
            file=sys.stderr,
        )
    return status


def build_records() -> tuple[list[Build], list[Unreadable]]:
    return builds(swamp_json("data", "query", BUILD_RECORDS)["results"])


def report_unreadable(unreadable: list[Unreadable]) -> None:
    for record in unreadable:
        print(
            f"{record.name}: not a build record: {record.content[:120]}",
            file=sys.stderr,
        )


def run_status() -> int:
    found, unreadable = build_records()
    counts = tally(found)
    print(
        ", ".join(f"{n} {status}" for status, n in sorted(counts.items()))
        or "no builds"
    )
    top = blockers(found).most_common(TOP_BLOCKERS)
    if top:
        # A blocker rebuilt since the plans behind it were refused shows as built: they wait
        # for the next run.
        statuses = {b.plan: b.status for b in found}
        print("top blockers:")
        for plan, n in top:
            print(f"  {plan} ({statuses.get(plan, 'no record')}) blocks {n}")
    report_unreadable(unreadable)
    return 1 if unreadable else 0


def logs(plans: list[str]) -> dict[str, str]:
    found = {}
    for i in range(0, len(plans), LOGS_PER_QUERY):
        names = json.dumps([f"log-{p}" for p in plans[i : i + LOGS_PER_QUERY]])
        rows = swamp_json(
            "data",
            "query",
            f'modelName == "dojo" && name in {names}',
            "--select",
            '{"name": name, "content": content}',
        )["results"]
        for row in rows:
            content = row.get("content")
            found[row["name"].removeprefix("log-")] = (
                content if isinstance(content, str) else ""
            )
    return found


def run_failures() -> int:
    found, unreadable = build_records()
    failed = sorted(b.plan for b in found if b.status == "failed")
    texts = logs(failed)
    for plan in failed:
        text = texts.get(plan)
        print(f"{plan}\t{last_error(text) if text is not None else '(no log)'}")
    report_unreadable(unreadable)
    return 1 if unreadable else 0


COMMANDS = {"running": run_running, "status": run_status, "failures": run_failures}


def main(argv: list[str]) -> int:
    if len(argv) != 1 or argv[0] not in COMMANDS:
        print(f"usage: state.py {' | '.join(COMMANDS)}", file=sys.stderr)
        return 2
    return COMMANDS[argv[0]]()


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
