"""Tests for state.py, from swamp's output as the builder records it.

    python3 -m unittest discover -s tools/builder

testdata/build-logs holds the ends of real failed logs from the builder, except ninja.log and b2.log,
written to the shape of those builds' output. builds.json and history.json are the shape of
`swamp data query --json` and `swamp workflow history search --json`.
"""

import json
import os
import tempfile
import unittest
from pathlib import Path
from typing import Any

import state

TESTDATA = Path(__file__).resolve().parent / "testdata"


def load(name: str) -> Any:
    return json.loads((TESTDATA / name).read_text(encoding="utf-8"))


def log(name: str) -> str:
    return (TESTDATA / "build-logs" / f"{name}.log").read_text(encoding="utf-8")


class BuildRecords(unittest.TestCase):
    def setUp(self) -> None:
        self.found, self.unreadable = state.builds(load("builds.json")["results"])

    def test_reads_content_as_an_object_or_as_a_json_string(self) -> None:
        plans = {b.plan: b.status for b in self.found}
        self.assertEqual(plans["zlib"], "built")
        self.assertEqual(plans["m4"], "built")

    def test_keeps_content_that_is_not_json_aside_by_record_name(self) -> None:
        self.assertEqual([u.name for u in self.unreadable], ["build-broken"])
        self.assertEqual(self.unreadable[0].content, "doj-plan-build: not a record")

    def test_counts_builds_by_status(self) -> None:
        self.assertEqual(
            state.tally(self.found), {"built": 2, "failed": 2, "blocked": 4}
        )

    def test_blames_each_blocked_plan_on_the_failure_at_the_root_of_its_chain(
        self,
    ) -> None:
        self.assertEqual(
            state.blockers(self.found).most_common(), [("make", 3), ("python2", 1)]
        )

    def test_a_cycle_of_blocked_records_ends(self) -> None:
        cycle = [state.Build("a", "blocked", "b"), state.Build("b", "blocked", "a")]
        self.assertEqual(sum(state.blockers(cycle).values()), 2)


class LastError(unittest.TestCase):
    def assertError(self, name: str, expected: str) -> None:
        self.assertEqual(state.last_error(log(name)), expected)

    def test_a_compiler_error_under_make(self) -> None:
        self.assertError(
            "busybox",
            "libbb/pw_encrypt.c:9:10: fatal error: crypt.h: No such file or directory",
        )

    def test_skips_excerpts_notes_and_the_warnings_as_errors_line(self) -> None:
        self.assertError(
            "stringencoders",
            "test/modp_b85_test.c:69:30: error: 'buf' may be used uninitialized"
            " [-Werror=maybe-uninitialized]",
        )
        self.assertError(
            "erlang18",
            "sys/unix/sys.c:2873:5: warning: old-style function definition [-Wold-style-definition]",
        )

    def test_a_function_named_error_is_context_not_an_error(self) -> None:
        self.assertError(
            "zip",
            "zip.c:2119:5: warning: old-style function definition [-Wold-style-definition]",
        )

    def test_configure_and_python_errors(self) -> None:
        self.assertError("dpkg", "configure: error: md5 digest functions not found")
        self.assertError(
            "azure-cli", "ModuleNotFoundError: No module named 'setuptools'"
        )
        self.assertError(
            "libjpeg-turbo",
            "/doj/cache/src/libjpeg-turbo-1.5.0/missing: 81: automake-1.15: not found",
        )

    def test_ninja_reports_are_noise(self) -> None:
        self.assertError(
            "ninja", "../src/foo.c:3:10: fatal error: bar.h: No such file or directory"
        )

    def test_errors_written_to_standard_output(self) -> None:
        self.assertError(
            "b2",
            "./boost/thread/detail/thread.hpp:181:9: error: no matching function for call to 'move'",
        )

    def test_doj_plan_builds_own_failures_are_the_error(self) -> None:
        self.assertError(
            "7zip",
            "b:copy: cannot create /doj/cache/src/p7zip_16.02/makefile.machine: File exists (os error 17)",
        )
        self.assertError(
            "ruby22",
            "no installed package matches `karate/gcc/5.2.0`; should it be built first?",
        )
        self.assertError(
            "cargo-nightly",
            "names paths outside /doj: lib/rustlib/uninstall.sh: interpreter /bin/bash",
        )

    def test_names_the_first_host_paths_and_counts_the_rest(self) -> None:
        text = "! doj-plan-build: 5 files name paths outside /doj:\n" + "".join(
            f"!   bin/p{n}: interpreter /bin/sh\n" for n in range(5)
        )
        self.assertEqual(
            state.last_error(text),
            "names paths outside /doj: bin/p0: interpreter /bin/sh; bin/p1: interpreter /bin/sh;"
            " bin/p2: interpreter /bin/sh and 2 more",
        )

    def test_an_empty_log(self) -> None:
        self.assertEqual(state.last_error(""), "(empty log)")


class Running(unittest.TestCase):
    def test_runs_that_have_not_ended(self) -> None:
        runs = state.unfinished(load("history.json")["results"])
        self.assertEqual(
            [r["workflowName"] for r in runs], ["bootstrap", "build-plans"]
        )

    def test_a_process_means_building_and_runs_alone_were_interrupted(self) -> None:
        runs = state.unfinished(load("history.json")["results"])
        swamp = state.Process(10, ("swamp", "workflow", "run", "bootstrap"))
        lines, status = state.running(runs, [swamp])
        self.assertEqual(status, state.EXIT_RUNNING)
        self.assertEqual(len(lines), 3)
        self.assertEqual(state.running(runs, [])[1], state.EXIT_INTERRUPTED)
        self.assertEqual(state.running([], []), ([], 0))

    def test_finds_building_processes_in_proc(self) -> None:
        with tempfile.TemporaryDirectory() as proc:
            for pid, argv in {
                "10": [
                    "/usr/local/bin/swamp",
                    "workflow",
                    "run",
                    "bootstrap",
                    "--input",
                    "{}",
                ],
                "11": ["swamp", "data", "query", "x"],
                "12": ["/work/bin/doj-plan-build", "build", "/work/plans/zlib"],
                "13": ["nice", "-n", "15", "swamp", "behavior", "run", "dojo", "build"],
                "14": [],  # a zombie
                "15": ["bash", "-c", "echo swamp workflow run"],
                "16": [
                    "/bin/sh",
                    "/usr/local/bin/swamp",
                    "workflow",
                    "resume",
                    "build-plans",
                ],
            }.items():
                os.mkdir(os.path.join(proc, pid))
                with open(os.path.join(proc, pid, "cmdline"), "wb") as f:
                    f.write(b"".join(a.encode() + b"\0" for a in argv))
            os.mkdir(os.path.join(proc, "self"))
            found = state.building(state.proc_processes(proc))
        self.assertEqual(sorted(p.pid for p in found), [10, 12, 13, 16])


if __name__ == "__main__":
    unittest.main()
