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
SHELL_RUN = re.compile(r'\(b:(run|capture)\s+\[\s*"(bash|sh|zsh|eval|/bin/sh|/bin/bash)"')


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
