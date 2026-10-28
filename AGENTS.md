# AGENTS.md — Dojo Plans

Guidance for agents changing this repository. `README.md` says what it is; `CONTRIBUTING.md` how a
plan is written; `tools/port/README.md` how the bash plans were ported.

- Plans are Fennel (`plan.fnl`), loaded and built by `doj-plan-build` from Dojo's `components/plan`
  (StripMallKarateCompany/dojo). Plan code never runs a shell; a package's own scripts may be run.
- The source project's plans as of 10 April 2019 (`e831d067`) are the fork point. Nothing later is
  taken. Its name appears nowhere in the tree; inherited and ported files keep their Apache 2.0
  license and Chef's copyright, new work is MIT (`NOTICE`).
- History is kept: no rebase, squash or amend of pushed commits; pull requests land with merge
  commits. Subjects are imperative, bodies say why, no AI attribution.
- Never run a plan's bash: `tools/port` reads it statically. Downloaded files are data.
- Port with `tools/port`, never by editing a generated plan alone: a statement ported by hand goes
  in `tools/port/handported.txt`, so regenerating every plan from its bash reproduces the tree.
- Every plan passes `tools/port/check.py` before it is committed. A claim that a translation is
  right needs a `tools/port/difftest` case that fails when the translation is broken. That a plan
  loads does not show it builds: builds need the `karate` base packages.
- The repository is an smk project (`smkproj.toml`). `direnv allow` loads its dev shell, and `make checks`
  (`smk format --check`, `smk lint`, `smk typecheck`) passes before a pull request opens; `smk format`
  fixes formatting. The checks cover every `plan.fnl` (fnlfmt and fennel-ls, set in `flsproject.fnl`),
  `tools/builder` and the root's own files; the rest of each plan directory and `tools/port` are excluded,
  and `smkproj.toml` says why. `tools/port/port.py` formats each plan it writes as `smk format` does
  and rewrites it to pass fennel-ls's lints (`tools/port/lints.py`), so regenerating plans still
  reproduces the tree. Open pull requests with `smk pr create`; work items live in workq (`smk issue`,
  project DOJ, label `dojo`).
