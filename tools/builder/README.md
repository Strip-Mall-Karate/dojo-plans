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
| `image`                 | Builds the `dojo-builder` image on the host from `Containerfile` and `cc-wrapper`                   |
| `start`                 | Starts the container, with `/doj` in the `dojo-root` volume and `~/dojo-builder` at `/work`         |
| `sync`                  | Unpacks this checkout's committed `HEAD` into `/work/plans`, keeping swamp's data and results       |
| `tools <dojo-checkout>` | Builds `doj-plan-build` and `doj` from that checkout's committed tree                               |
| `key`                   | Imports the karate origin's signing key pair from 1Password into `/doj/cache/keys`                  |
| `dojo <dojo-checkout>`  | Unpacks that checkout's committed `HEAD` into `/work/dojo`, for building Dojo's own component plans |
| `standins`              | Gives every base plan an empty `0.0.0` package, so a first build resolves its dependencies          |
| `run <command>...`      | Runs a command in the container, from `/work/plans/swamp`, under `nice`                             |
| `shell`                 | A shell in the container                                                                            |
| `stop`, `remove`        | Stops the container; removes it and the `/doj` volume                                               |

From nothing: `image`, `start`, `sync`, `tools <dojo-checkout>`, `key`, `standins`. After a commit:
`sync`.

## What a build there is, and is not

- **The stand-ins are the first pass's host.** A stand-in is an empty package. The build uses the
  container's own tools, which are on PATH, and a real build of the package sorts after `0.0.0`
  and replaces it. Builds are not isolated from the container: the second, isolated pass waits on
  `doj-plan-build` gaining that mode.
- **The container's compiler links against karate's glibc.** A program linked against a karate
  glibc runs only with that glibc's dynamic linker, and the container's gcc names its own, so
  `gcc`, `cc`, `g++` and `c++` are wrappers (`cc-wrapper`) that add the karate glibc's dynamic
  linker to a link when the build has one. Once karate's gcc is built it comes first on PATH.
- **Artifacts are signed with the karate origin key.** `doj` is Dojo's own, built by `tools` with
  the image's Rust, so a builder with no karate packages has it. The key pair lives only in
  1Password, in "karate origin signing key" in the OMG SecOps vault, each key file base64-encoded
  in its own field (`public key`, `secret key`). `key` reads it with `op read`, so the 1Password
  app asks to approve, and imports it into the `/doj` volume; `remove` deletes it with the volume.
  It is in neither the image nor `~/dojo-builder` on the host.
- **swamp needs a swamp-club.com account.** Sign in once with `builder shell` and `swamp auth
login`. The credential is kept in `~/dojo-builder/home` on the host.
