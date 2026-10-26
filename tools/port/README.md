# The plan.sh to plan.fnl port

The source project's plans (as of 10 April 2019) are bash; Dojo's are Fennel. These tools port them and
check the result. They go when the last `plan.sh` does.

## Running it

From the repository root, with `DPB` the `doj-plan-build` built from Dojo's `components/plan` (the
runtime the plans need is Strip-Mall-Karate/dojo#6; until it merges, build that branch):

```sh
python3 -I tools/port/port.py <pkg>...            # writes <pkg>/plan.fnl; prints `ok` or what is left
python3 -I tools/port/check.py "$DPB" <pkg>...     # refuses a plan that is not ported, safe or loading
python3 -I tools/port/difftest/run.py <dojo-checkout> <builder-state> <builder-port>
```

`difftest` needs the builder VM running (`support/vm/builder start` in a dojo checkout, with its own
`DOJO_BUILDER_STATE` and `DOJO_BUILDER_PORT`) and `doj-plan-build` built in it at
`~/plan-file-ops/components/plan/target/debug/` (sync the runtime branch there and `cargo build`). It
runs each case in `difftest/cases.txt` as bash in one tree and as its Fennel translation in another;
the trees must match. Add a case for every new translation, and break the translation once to see
its case fail.

## What each file does

- `bashplan.py` reads a plan without running it: assignments, arrays, functions, `source` of another
  plan, and the parameter expansions plans use. A downloaded plan's bash never runs.
- `translate.py` turns each callback statement into b's operations. What it cannot say faithfully it
  keeps as bash in an `;; UNPORTED (...)` block.
- `port.py` writes the metadata and phases, renames to Dojo's names, and marks every problem in the
  plan's header so `check.py` holds it back.
- `check.py` refuses: an UNPORTED block, a shell given code (`sh -c`), the source project's name, a b
  operation on a path outside `/doj`, a builder function or shell builtin run as a program, and a plan
  `doj-plan-build show` does not load.
- `handported.txt`: statements a person ported, keyed by their bash. The translator uses an entry
  before its own reading, wherever the statement appears, so one entry serves a plan and every plan
  that sources it.
- `handwritten.txt`: plans written by hand whole, which `port.py` leaves alone.

## Workflow

1. Port the package. If it prints `ok` and `check.py` passes, `git add <pkg>/plan.fnl` and
   `git rm <pkg>/plan.sh` (and any `x86_64-linux-kernel2/plan.sh` and sourced data `.sh`), unless
   another plan still sources this one (the base stays until its variants are ported).
2. Otherwise read each UNPORTED block. A mechanical form goes into `translate.py` with a difftest
   case; a one-off goes into `handported.txt`.
3. After any translator change, regenerate every committed plan from its original bash in a scratch
   worktree (`git show e831d067:<pkg>/plan.sh`) and compare with what is committed. Each difference
   is a fix to adopt or a regression to fix. This found bugs reading never did.

## Decisions (Jamie, 2026-10-26)

- Fork at 10 April 2019 (`e831d067`), history kept; pure Fennel (no shell in plan code); Windows
  plans dropped.
- The old studio linked a dependency's tool into `/usr/bin` for builds: ported as
  `use-dependency-path`, which points the build's scripts at the dependency instead.
- `do_clean` overrides are dropped: a build always starts from a fresh source directory.
- Unverified sources are pinned to a checksummed archive current at the fork date.
- Scaffoldings are their own stage: their `plan.fnl` packages the bash library faithfully, but Dojo's
  scaffoldings are Fennel modules, still to write.

## Semantics the translation rests on

- The source project's builder ran callbacks under `set -e` (from memory of plan-build, about 80%
  sure): a failing command stopped the build, so `$?` after a command is 0 and `|| return` is the
  command alone. `|| true` is `b:run` with `{:check false}`.
- Each callback ran in the source directory; `pushd`/`cd` there are `:cwd`. b resolves a relative
  path for writes inside the prefix, so every path the translator passes to b is made absolute, and
  variables that may hold relative paths (a relative glob's names, a `find`'s lines) are anchored.
- Approximations: `-d`, `-x` and `-s` tests are "exists"; `printf`/`cat` into a file may gain a
  trailing newline.

## What is left (78 packages, 2026-10-26)

- Scaffoldings and the Go plans that use them: scaffolding-ruby, scaffolding-go/go17 (the old name in
  their upstream link), certstrap, dep, foulkon, grpcurl, helm, mage, opa, traefik.
- Unverified sources to pin: aws-cli (version from PyPI search), boringssl (googlesource archives are
  not stable), cargo-nightly, rust-nightly (pick the nightly of 2019-04-10, sha from Rust's .sha256),
  leiningen (lein-pkg at its tag), netcat-openbsd (Debian patches), prometheus-cpp (git clone of
  v0.6.0), img (unpinned git clone), jdk8/jdk9/jre8/jre9 (Oracle download with a cookie).
- geoip: its GeoLite download no longer exists; Jamie to decide.
- concourse-fly sources the source tree's `.envrc`; bash-static sets `PLAN_CONTEXT=$(abspath ../bash)`.
- Toolchain and families with bespoke bash: glibc, gcc, gcc-libs, binutils, linux, linux-headers, perl,
  openssl, openssl-musl, busybox, busybox-static, the node, python, llvm/clang, cuda, go and ghc
  bootstrap families, and the rest of the list `git ls-files '*/plan.sh'` prints.
