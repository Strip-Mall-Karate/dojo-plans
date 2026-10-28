# The plan builder

Plans build in a container on smk-1, Jamie's x86_64 Ubuntu box, so `x86_64-linux` packages build
natively on real hardware. The container is Ubuntu 26.04 with the tools a first build of the base
plans takes from its host (gcc, bison, gawk, m4, texinfo, Python), Rust to build `doj-plan-build`,
and swamp. Nothing is installed on smk-1 itself. smk-1 also runs the game fleet, the forge and
buildq, so the container is capped at 16 CPUs and 32 GB and every build runs under `nice -n 15`.

Run `tools/builder/builder` from a dojo-plans checkout on the Mac. `DOJO_BUILD_HOST` names another
box.

| Command                 | What it does                                                                                        |
| ----------------------- | --------------------------------------------------------------------------------------------------- |
| `image`                 | Builds the `dojo-builder` image on the host from `Containerfile` and `doj`                          |
| `start`                 | Starts the container, with `/doj` in the `dojo-root` volume and `~/dojo-builder` at `/work`         |
| `sync [--force]`        | Unpacks this checkout's committed `HEAD` into `/work/plans`, keeping swamp's data and results       |
| `tools <dojo-checkout>` | Builds `doj-plan-build` from that checkout's committed `components/plan`                            |
| `dojo <dojo-checkout>`  | Unpacks that checkout's committed `HEAD` into `/work/dojo`, for building Dojo's own component plans |
| `standins`              | Gives every base plan an empty `0.0.0` package, so a first build resolves its dependencies          |
| `status`                | The plans' last builds counted by status, and the failures blocking the most plans                  |
| `wait`                  | Returns once nothing builds from `/work/plans`, riding out ssh failures for ten minutes             |
| `failures`              | One line per failed plan: its name, a tab, and the last error in its log                            |
| `check-wrapper`         | Links C and Rust programs with this checkout's `gcc/cc-wrapper.sh` and checks what it gives them    |
| `run <command>...`      | Runs a command in the container, from `/work/plans/swamp`, under `nice`                             |
| `shell`                 | A shell in the container                                                                            |
| `stop`, `remove`        | Stops the container; removes it and the `/doj` volume                                               |

From nothing: `image`, `start`, `sync`, `tools <dojo-checkout>`, `standins`. After a commit: `sync`.

`status`, `wait` and `failures` pipe `state.py` into the container, which reads swamp's records and
processes there and changes nothing. Its parsing is tested from recorded swamp output (`bin/test`).

## Syncing beside a run

A running workflow reads `/work/plans` again at every wave, so syncing under it changes what the rest
of the run builds. `sync` therefore refuses while anything builds from `/work/plans`, naming it: a
`swamp workflow run` or `resume`, a `swamp behavior run`, a `doj-plan-build build`, or a workflow run
swamp never finished. `wait` for it, or `sync --force` to replace the tree anyway. A run swamp never
finished, with no process left behind it, makes `sync` refuse and `wait` exit 4: end it with
`swamp workflow cancel`, or continue it with `swamp workflow recover` and then `resume`.

`sync` sends one commit, so several branches that are waiting to merge build together only from a
commit that merges them. Keep a local `builder-head` branch that merges `origin/main` with every
pending branch, re-merge it when one changes, and sync only `builder-head`. Syncing a single branch
drops the others' changes from the tree.

## Checking gcc's wrapper

`check-wrapper` fills in `gcc/cc-wrapper.sh` as the gcc plan does, from the newest installed karate
gcc and that gcc's glibc and binutils, and links three programs with it in the container. C and Rust
against glibc must run, name that glibc's dynamic linker, and carry exactly `LD_RUN_PATH`'s entries
as their RUNPATH: rustc links with its bundled lld, which ignores `LD_RUN_PATH`. A static Rust program
against musl must run with no dynamic linker. It sends the working tree's wrapper, so a change is
checked before it is committed.

## What a build there is, and is not

- **The stand-ins are the first pass's host.** A stand-in is an empty package. The build uses the
  container's own tools, which are on PATH, and a real build of the package sorts after `0.0.0`
  and replaces it. Builds are not isolated from the container: the second, isolated pass waits on
  `doj-plan-build` gaining that mode.
- **The container's compiler links against karate's glibc.** A program linked against a karate
  glibc runs only with that glibc's dynamic linker, and the container's gcc names its own, so
  `gcc`, `cc`, `g++` and `c++` are wrappers (`cc-wrapper`) that add the karate glibc's dynamic
  linker to a link when the build has one. Once karate's gcc is built it comes first on PATH.
- **Artifacts are not signed.** `doj` here is a stand-in that resolves installed packages and
  writes the file it is asked to sign with a header line, not a signature, until Dojo's own `doj`
  builds with the current toolchain. The origin key in `/doj/cache/keys` is an empty placeholder.
- **swamp needs a swamp-club.com account.** Sign in once with `builder shell` and `swamp auth
login`. The credential is kept in `~/dojo-builder/home` on the host.
