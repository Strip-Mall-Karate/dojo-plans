# Building plans with swamp

This directory is a [swamp](https://swamp-club.com) repository that builds this checkout's plans
in dependency order, with the `@strip-mall-karate/dojo` behavior in
[extensions/behaviors](extensions/behaviors/README.md). Its definition, `dojo`, builds the parent
directory's plans for `x86_64-linux`. Run swamp from here on a machine that builds that target, with
`doj-plan-build` on PATH: the [builder](../tools/builder/README.md) container is one
(`tools/builder/builder run swamp ...`).

```sh
cd swamp
swamp workflow run build-plans --input '{"plans": ["helm"]}'   # helm and all it depends on
swamp workflow run build-plans                                 # every plan
```

`build-plans` orders the plans, then builds them a wave at a time through `build-wave`, one plan at
a time: a build holds the `dojo` definition's lock until it ends, so while a workflow runs, other
`dojo` methods wait for it, and a build run beside it fails after a minute. The base toolchain in `../base-plans.txt` goes first, in its listed order. A failed plan
blocks only the plans that depend on it, and a plan already built from the same plan contents is
skipped, so running the workflow again after a fix builds only what is left. Each plan's last build
is the `build-<plan>` record, and its output is the `log-<plan>` file:

```sh
swamp data query 'modelName == "dojo" && specName == "build" && attributes.status != "built"' \
  --select 'name + " " + attributes.status'
swamp data query 'modelName == "dojo" && name == "log-zlib"' --select content
```

## Bootstrapping the base set

`bootstrap` is one pass of the base set's bootstrap. It rebuilds the `backline` plan, the base tools
every build may run without declaring them, from the packages installed now. Then it rebuilds every
base plan with `isolate`, `refuseHostPaths` and that backline: each build sees only its own
dependencies and the backline, and a package that names the build machine's files fails. The
backline pins the releases it was built against, so a pass builds with the previous pass's tools,
and running `bootstrap` again is the next pass.

```sh
plans=$(sed -n 's|^dojo-plans/\([^ ]*\).*|\1|p' ../base-plans.txt | grep -vx backline \
  | awk '!seen[$0]++ { printf "%s\"%s\"", (n++ ? "," : ""), $0 }')
swamp workflow run bootstrap --input "{\"plans\": [${plans}]}"
```

The extension's tests run with swamp's Deno: `~/.swamp/deno/deno test --allow-all extensions/behaviors`.
