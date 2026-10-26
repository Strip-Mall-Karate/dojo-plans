import { assert, assertEquals, assertRejects } from "jsr:@std/assert@1.0.19";
import { createModelTestContext } from "jsr:@swamp-club/swamp-testing@0.20261024.62";
import { behavior, orderWaves } from "./dojo.ts";

/**
 * A stand-in doj-plan-build: `show` prints a plan's metadata from its
 * `meta.json`, `build` prints what the real one prints, or fails for a plan
 * with a `broken` file.
 */
const FAKE_BUILDER = `#!/bin/sh
set -eu
command=$1 dir=$2
name=$(basename "$dir")
case $command in
show) cat "$dir/meta.json" ;;
build)
  if [ -e "$dir/broken" ]; then
    echo "   $name: Building" >&2
    echo "doj-plan-build: $name failed in build" >&2
    exit 1
  fi
  # What doj-plan-build printed building scaffolding-base in the builder VM.
  ident="karate/$name/1.0/20261026000000"
  hart="$DOJ_OUTPUT_PATH/karate-$name-1.0-20261026000000-x86_64-linux.hart"
  mkdir -p "$DOJ_ROOT_PATH/pkgs/$ident"
  echo "   $name: Building $ident for x86_64-linux"
  echo "   $name: Installed $ident in $DOJ_ROOT_PATH/pkgs/$ident"
  echo "   $name: Building package metadata"
  echo "   $name: Generating package artifact"
  echo "   $name: Artifact: $hart"
  echo "   $name: SHA256 Checksum: c54f0dce7111133524a09cce104eabe5fd7b748b94f67e6fb4a3204f650f9e4c"
  echo "$ident"
  ;;
esac
`;

type Fixture = { checkout: string; root: string; planBuild: string };

/** A checkout of plans with the given dependencies, and the stand-in builder. */
async function fixture(
  plans: Record<
    string,
    { deps?: string[]; buildDeps?: string[]; broken?: boolean }
  >,
): Promise<Fixture> {
  const dir = await Deno.makeTempDir({ prefix: "dojo-behavior-" });
  const checkout = `${dir}/plans`;
  for (const [name, plan] of Object.entries(plans)) {
    await Deno.mkdir(`${checkout}/${name}`, { recursive: true });
    await Deno.writeTextFile(
      `${checkout}/${name}/plan.fnl`,
      `{:name "${name}"}\n`,
    );
    await Deno.writeTextFile(
      `${checkout}/${name}/meta.json`,
      JSON.stringify({
        name,
        origin: "karate",
        version: "1.0",
        targets: ["x86_64-linux"],
        deps: (plan.deps ?? []).map((dep) => `karate/${dep}`),
        build_deps: (plan.buildDeps ?? []).map((dep) => `karate/${dep}`),
      }),
    );
    if (plan.broken) await Deno.writeTextFile(`${checkout}/${name}/broken`, "");
  }
  const planBuild = `${dir}/doj-plan-build`;
  await Deno.writeTextFile(planBuild, FAKE_BUILDER);
  await Deno.chmod(planBuild, 0o755);
  return { checkout, root: `${dir}/root`, planBuild };
}

function globalArgs(f: Fixture) {
  return {
    checkout: f.checkout,
    planBuild: f.planBuild,
    target: "x86_64-linux",
    root: f.root,
    outputPath: `${f.root}/results`,
    baseOrder: "base-plans.txt",
  };
}

/** A test context whose readResource sees what the test wrote before. */
function contextFor(
  f: Fixture,
  stored: Record<string, Record<string, unknown>> = {},
) {
  const test = createModelTestContext({
    globalArgs: globalArgs(f),
    storedResources: stored,
  });
  return test;
}

function plan(name: string, deps: string[] = [], buildDeps: string[] = []) {
  return {
    plan: name,
    target: "x86_64-linux",
    name,
    origin: "karate",
    version: "1.0",
    deps: deps.map((d) => `karate/${d}`),
    buildDeps: buildDeps.map((d) => `karate/${d}`),
    scaffolding: null,
    metadata: {},
  };
}

Deno.test("orderWaves puts each plan after everything it depends on", () => {
  const order = orderWaves([
    plan("app", ["lib"], ["tool"]),
    plan("lib", ["libc"]),
    plan("tool", ["libc"]),
    plan("libc"),
  ]);
  assertEquals(order.waves, [["libc"], ["lib", "tool"], ["app"]]);
  assertEquals(order.cycle, []);
});

Deno.test("orderWaves reports a dependency no plan provides as external", () => {
  const order = orderWaves([plan("app", ["lib"])]);
  assertEquals(order.waves, [["app"]]);
  assertEquals(order.external, ["karate/lib"]);
});

Deno.test("orderWaves builds the base order first and reports its forward needs", () => {
  const order = orderWaves(
    [plan("cc", ["libc"]), plan("libc", [], ["cc"]), plan("app", ["libc"])],
    ["libc", "cc"],
  );
  assertEquals(order.waves, [["libc"], ["cc"], ["app"]]);
  assertEquals(order.bootstrap, [{ plan: "libc", needs: ["cc"] }]);
  assertEquals(order.cycle, []);
});

Deno.test("orderWaves names the plans of a cycle outside the base order", () => {
  const order = orderWaves([plan("a", ["b"]), plan("b", ["a"]), plan("c")]);
  assertEquals(order.waves, [["c"]]);
  assertEquals(order.cycle, ["a", "b"]);
});

Deno.test("order keeps the requested plans and what they depend on", async () => {
  const f = await fixture({ app: { deps: ["lib"] }, lib: {}, other: {} });
  const { context, getWrittenResources } = contextFor(f);
  await behavior.methods.order.execute({
    plans: ["app"],
    withDependencies: true,
  }, context);
  const [order] = getWrittenResources();
  assertEquals(order.data.waves, [["lib"], ["app"]]);
  assertEquals(order.data.count, 2);
});

Deno.test("order refuses a plan the checkout does not have", async () => {
  const f = await fixture({ app: {} });
  const { context } = contextFor(f);
  await assertRejects(
    () =>
      behavior.methods.order.execute({
        plans: ["nope"],
        withDependencies: true,
      }, context),
    Error,
    "cannot build nope",
  );
});

Deno.test("build records the installed package, then skips the same plan", async () => {
  const f = await fixture({ lib: {} });
  const first = contextFor(f);
  await behavior.methods.build.execute(
    { plan: "lib", force: false, check: false, refuseHostPaths: false },
    first.context,
  );
  const [record] = first.getWrittenResources();
  assertEquals(record.name, "build-lib");
  assertEquals(record.data.status, "built");
  assertEquals(record.data.ident, "karate/lib/1.0/20261026000000");
  assertEquals(
    record.data.prefix,
    `${f.root}/pkgs/karate/lib/1.0/20261026000000`,
  );
  assertEquals(
    record.data.artifact,
    `${f.root}/results/karate-lib-1.0-20261026000000-x86_64-linux.hart`,
  );
  const log = first.getWrittenFiles().find((file) => file.name === "log-lib");
  assert(log, "the build wrote its log");

  const second = contextFor(f, { "build-lib": record.data });
  const result = await behavior.methods.build.execute(
    { plan: "lib", force: false, check: false, refuseHostPaths: false },
    second.context,
  );
  assertEquals(result.dataHandles, []);
  assertEquals(second.getWrittenResources(), []);
});

Deno.test("build rebuilds a plan whose files changed", async () => {
  const f = await fixture({ lib: {} });
  const first = contextFor(f);
  await behavior.methods.build.execute({
    plan: "lib",
    force: false,
    check: false,
    refuseHostPaths: false,
  }, first.context);
  const [record] = first.getWrittenResources();
  await Deno.writeTextFile(
    `${f.checkout}/lib/plan.fnl`,
    `{:name "lib" :version "2"}\n`,
  );
  const second = contextFor(f, { "build-lib": record.data });
  await behavior.methods.build.execute({
    plan: "lib",
    force: false,
    check: false,
    refuseHostPaths: false,
  }, second.context);
  assertEquals(second.getWrittenResources().length, 1);
});

Deno.test("a failed build records the failure and throws with the log's tail", async () => {
  const f = await fixture({ lib: { broken: true } });
  const { context, getWrittenResources } = contextFor(f);
  await assertRejects(
    () =>
      behavior.methods.build.execute({
        plan: "lib",
        force: false,
        check: false,
        refuseHostPaths: false,
      }, context),
    Error,
    "lib failed in build",
  );
  const [record] = getWrittenResources();
  assertEquals(record.data.status, "failed");
  assertEquals(record.data.exitCode, 1);
});

Deno.test("build is blocked by a dependency that failed in the same run", async () => {
  const f = await fixture({ lib: {}, app: { deps: ["lib"] } });
  const failed = { plan: "lib", status: "failed", runId: "run-1" };
  const { context, getWrittenResources } = contextFor(f, {
    "build-lib": failed,
  });
  await assertRejects(
    () =>
      behavior.methods.build.execute(
        {
          plan: "app",
          force: false,
          check: false,
          refuseHostPaths: false,
          runId: "run-1",
        },
        context,
      ),
    Error,
    "it depends on lib, whose last build failed",
  );
  const [record] = getWrittenResources();
  assertEquals(record.data.status, "blocked");
  assertEquals(record.data.blockedBy, "lib");
});

Deno.test("a failure from an earlier run does not block build", async () => {
  const f = await fixture({ lib: {}, app: { deps: ["lib"] } });
  const failed = { plan: "lib", status: "failed", runId: "run-1" };
  const { context, getWrittenResources } = contextFor(f, {
    "build-lib": failed,
  });
  await behavior.methods.build.execute(
    {
      plan: "app",
      force: false,
      check: false,
      refuseHostPaths: false,
      runId: "run-2",
    },
    context,
  );
  assertEquals(getWrittenResources()[0].data.status, "built");
});

Deno.test("build says which setting to fix when doj-plan-build is missing", async () => {
  const f = await fixture({ lib: {} });
  const { context } = createModelTestContext({
    globalArgs: { ...globalArgs(f), planBuild: `${f.root}/no-such-builder` },
  });
  await assertRejects(
    () =>
      behavior.methods.build.execute(
        { plan: "lib", force: true, check: false, refuseHostPaths: false },
        context,
      ),
    Error,
    "set planBuild to its path",
  );
});

Deno.test("build passes refuseHostPaths to doj-plan-build", async () => {
  const f = await fixture({ lib: {} });
  const { context, getWrittenFiles } = contextFor(f);
  await behavior.methods.build.execute(
    { plan: "lib", force: false, check: false, refuseHostPaths: true },
    context,
  );
  const log = getWrittenFiles().find((file) => file.name === "log-lib");
  assert(log, "the build wrote its log");
  const text = typeof log.content === "string"
    ? log.content
    : new TextDecoder().decode(log.content);
  assert(
    text.split("\n")[0].endsWith(" --refuse-host-paths"),
    text.split("\n")[0],
  );
});
