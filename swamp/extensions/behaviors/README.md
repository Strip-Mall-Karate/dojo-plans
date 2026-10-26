# @strip-mall-karate/dojo

Builds [Dojo](https://github.com/StripMallKarateCompany/dojo) packages from a checkout of
[Dojo Plans](https://github.com/StripMallKarateCompany/dojo-plans) with `doj-plan-build`, the program in
Dojo's `components/plan` that reads a plan's `plan.fnl` and builds it. One definition stands for one
checkout and one target. Its methods read a plan, build a plan, and order a set of plans into waves,
where each wave depends only on the waves before it.

Builds run on the machine swamp runs on, which must be able to build the target. `doj-plan-build`
refuses a target its host cannot build.

## Definition

```yaml
type: "@strip-mall-karate/dojo"
name: dojo
globalArguments:
  checkout: ..                      # the plans checkout, relative to the swamp repository
  target: x86_64-linux
  planBuild: doj-plan-build         # a path, or a name on PATH
  root: /doj                        # DOJ_ROOT_PATH: installed packages and the build cache
  keyPath: /doj/cache/keys          # DOJ_CACHE_KEY_PATH: origin signing keys
  outputPath: results               # DOJ_OUTPUT_PATH: where artifacts are copied
  doj: doj                          # DOJ_BIN: resolves installed packages, signs artifacts
  baseOrder: base-plans.txt         # the base toolchain's build order, in the checkout
```

Only `checkout` is required. `root`, `keyPath` and `doj` fall back to `doj-plan-build`'s own
defaults, and `outputPath` to `results` in the swamp repository.

## Methods

```sh
swamp behavior run dojo show --input plan=zlib
swamp behavior run dojo order --input 'plans=["helm"]'
swamp behavior run dojo build --input plan=zlib
```

- `show {plan}` runs `doj-plan-build show` for the target and writes the plan's metadata as
  `plan-<plan>`: its name, origin, version, run and build dependencies, scaffolding, and everything
  else `show` prints, under `metadata`.
- `order {plans, withDependencies}` reads every plan in the checkout and writes `order`: the
  requested plans and all they depend on (run, build, and through their scaffolding), in waves.
  An empty `plans` orders the whole checkout.
  - The plans in the base order build first, one per wave, in that order, because the base
    toolchain depends on itself. A base plan that needs one listed after it is reported under
    `bootstrap`, and the build environment provides that one.
  - `external` names dependencies no plan in the checkout provides. `skipped` names plans that
    could not be read for the target, with the reason.
  - Any other cycle fails the method and names its plans.
- `build {plan, force, check, runId}` runs `doj-plan-build build` and writes `build-<plan>`. The
  build's output streams to the file `log-<plan>`.
  - The record holds `status` (`built`, `failed` or `blocked`), the package's `ident`, `prefix` and
    `artifact`, a hash of the plan's directory, and the build's timing.
  - A plan is skipped when its last build succeeded from the same plan directory contents and the
    package is still installed.
  - A plan is blocked, not built, when a plan it depends on failed or was blocked. With a `runId`
    only failures from the same run block it, so one run's failure does not hold back the next.
  - `force` builds regardless. `check` runs the plan's check phase.

A failed build writes its log and its record and then fails the method, with the end of the log in
the error.

## Workflows

A repository using this behavior can order and build in two workflows:

- `build-plans` runs `order`, then each wave in turn as a nested `build-wave`, passing its run id.
- `build-wave` builds a wave's plans side by side. One failure in a wave does not stop the rest of
  that wave, and the plans that depend on it are blocked in the later waves.

```sh
swamp workflow run build-plans --input '{"plans": ["helm"]}'
swamp data query 'modelName == "dojo" && specName == "build" && attributes.status != "built"' \
  --select 'name + " " + attributes.status'
```
