# Building plans with swamp

This directory is a [swamp](https://swamp-club.com) repository that builds this checkout's plans
in dependency order, with the `@strip-mall-karate-company/dojo` behavior in
[extensions/behaviors](extensions/behaviors/README.md). Its definition, `dojo`, builds the parent
directory's plans for `x86_64-linux`. Run swamp from here on a machine that builds that target, with
`doj-plan-build` on PATH:

```sh
cd swamp
swamp workflow run build-plans --input '{"plans": ["helm"]}'   # helm and all it depends on
swamp workflow run build-plans                                 # every plan
```

`build-plans` orders the plans, then builds them a wave at a time through `build-wave`, two plans at
once. The base toolchain in `../base-plans.txt` goes first, in its listed order. A failed plan
blocks only the plans that depend on it, and a plan already built from the same plan contents is
skipped, so running the workflow again after a fix builds only what is left. Each plan's last build
is the `build-<plan>` record, and its output is the `log-<plan>` file:

```sh
swamp data query 'modelName == "dojo" && specName == "build" && attributes.status != "built"' \
  --select 'name + " " + attributes.status'
swamp data query 'modelName == "dojo" && name == "log-zlib"' --select content
```

The extension's tests run with swamp's Deno: `~/.swamp/deno/deno test --allow-all extensions/behaviors`.
