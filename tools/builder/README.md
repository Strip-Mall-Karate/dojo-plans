# The plan builder

Plans build in a container on smk-1, Jamie's x86_64 Ubuntu box, so `x86_64-linux` packages build
natively on real hardware. The container is Ubuntu 26.04 with the tools a first build of the base
plans takes from its host (gcc, bison, gawk, m4, texinfo, Python), Rust to build `doj-plan-build`,
and swamp. Nothing is installed on smk-1 itself. smk-1 also runs the game fleet, the forge and
buildq, so the container is capped at 16 CPUs and 32 GB and every build runs under `nice -n 15`.

Run `tools/builder/builder` from a dojo-plans checkout on the Mac. `DOJO_BUILD_HOST` names another
box.

| Command | What it does |
| --- | --- |
| `image` | Builds the `dojo-builder` image on the host from `Containerfile` and `doj` |
| `start` | Starts the container, with `/doj` in the `dojo-root` volume and `~/dojo-builder` at `/work` |
| `sync` | Unpacks this checkout's committed `HEAD` into `/work/plans`, keeping swamp's data and results |
| `tools <dojo-checkout>` | Builds `doj-plan-build` from that checkout's committed `components/plan` |
| `standins` | Gives every base plan an empty `0.0.0` package, so a first build resolves its dependencies |
| `run <command>...` | Runs a command in the container, from `/work/plans/swamp`, under `nice` |
| `shell` | A shell in the container |
| `stop`, `remove` | Stops the container; removes it and the `/doj` volume |

From nothing: `image`, `start`, `sync`, `tools <dojo-checkout>`, `standins`. After a commit: `sync`.
The plans need `components/plan` with scaffolding metadata (StripMallKarateCompany/dojo#10), so
until that is on Dojo's main, `tools` takes a checkout of its branch.

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
