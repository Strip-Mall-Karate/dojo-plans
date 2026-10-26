/**
 * Dojo plans as a swamp behavior: show a plan, build it with `doj-plan-build`,
 * and order a set of plans by their dependencies for building.
 *
 * @module
 */
import { z } from "npm:zod@4";

/** Where the plans are, the builder that builds them, and where packages go. */
const GlobalArgsSchema = z.object({
  checkout: z.string().describe(
    "Path to a dojo-plans checkout: one directory per package, each with a plan.fnl",
  ),
  planBuild: z.string().default("doj-plan-build").describe(
    "The doj-plan-build program, a path or a name on PATH",
  ),
  target: z.string().default("x86_64-linux").describe(
    "The package target to show and build for",
  ),
  root: z.string().optional().describe(
    "DOJ_ROOT_PATH for builds: where packages are installed and sources cached (default /doj)",
  ),
  keyPath: z.string().optional().describe(
    "DOJ_CACHE_KEY_PATH: where origin signing keys are",
  ),
  outputPath: z.string().optional().describe(
    "DOJ_OUTPUT_PATH: where built artifacts are copied",
  ),
  doj: z.string().optional().describe(
    "DOJ_BIN: the doj program builds use to resolve installed packages and sign artifacts",
  ),
  baseOrder: z.string().default("base-plans.txt").describe(
    "The base toolchain's build order, a file in the plans checkout: these plans build first, in this order",
  ),
});

type GlobalArgs = z.infer<typeof GlobalArgsSchema>;

const PlanArgsSchema = z.object({
  plan: z.string().regex(/^[A-Za-z0-9][A-Za-z0-9_.-]*$/).describe(
    "The plan's directory name in the checkout",
  ),
});

const BuildArgsSchema = PlanArgsSchema.extend({
  force: z.boolean().default(false).describe(
    "Build even when the package from the same plan content is installed, or a dependency's last build failed",
  ),
  check: z.boolean().default(false).describe("Run the plan's check phase"),
  refuseHostPaths: z.boolean().default(false).describe(
    "Fail when the package names the build machine's files: a dynamic linker, RUNPATH or script interpreter outside Dojo's root",
  ),
  runId: z.string().optional().describe(
    "The workflow run building this plan: only failures in the same run block it; without one, any last failure does",
  ),
});

const OrderArgsSchema = z.object({
  plans: z.array(z.string()).default([]).describe(
    "Plans to build, by directory name; empty means every plan in the checkout",
  ),
  withDependencies: z.boolean().default(true).describe(
    "Add every plan the requested ones depend on, build or run, through scaffoldings",
  ),
});

/** A plan's metadata, as `doj-plan-build show` reports it for the target. */
const PlanSchema = z.object({
  plan: z.string(),
  target: z.string(),
  name: z.string(),
  origin: z.string(),
  version: z.string().nullable(),
  deps: z.array(z.string()),
  buildDeps: z.array(z.string()),
  scaffolding: z.string().nullable(),
  metadata: z.record(z.string(), z.unknown()),
});

/** A plan's last build: the package it installed, or that it failed. */
const BuildSchema = z.object({
  plan: z.string(),
  target: z.string(),
  status: z.enum(["built", "failed", "blocked"]),
  exitCode: z.number().nullable(),
  blockedBy: z.string().nullable().describe(
    "The dependency whose failed or blocked build stopped this one",
  ),
  runId: z.string().nullable().describe("The workflow run that built it"),
  ident: z.string().nullable(),
  prefix: z.string().nullable(),
  artifact: z.string().nullable(),
  planHash: z.string(),
  startedAt: z.iso.datetime(),
  finishedAt: z.iso.datetime(),
  durationSeconds: z.number(),
});

/** Plans in dependency order: each wave's plans depend only on earlier waves. */
const OrderSchema = z.object({
  target: z.string(),
  waves: z.array(z.array(z.string())),
  count: z.number(),
  external: z.array(z.string()).describe(
    "Dependencies no plan in the checkout provides, which must already be installed",
  ),
  bootstrap: z.array(z.object({ plan: z.string(), needs: z.array(z.string()) }))
    .describe(
      "Base plans that need a plan the base order builds after them: the build environment provides it",
    ),
  skipped: z.array(z.object({ plan: z.string(), reason: z.string() })),
});

type Plan = z.infer<typeof PlanSchema>;

type WriteResource = (
  specName: string,
  name: string,
  data: Record<string, unknown>,
) => Promise<{ name: string }>;

type DataWriter = {
  writeLine: (line: string) => Promise<void>;
  finalize: () => Promise<{ name: string }>;
};

type Logger = {
  info: (message: string, properties?: Record<string, unknown>) => void;
  warning: (message: string, properties?: Record<string, unknown>) => void;
};

/** The environment a doj-plan-build run gets: this process's, plus the Dojo paths set. */
function builderEnv(args: GlobalArgs): Record<string, string> {
  const env: Record<string, string> = {};
  if (args.root) env.DOJ_ROOT_PATH = args.root;
  if (args.keyPath) env.DOJ_CACHE_KEY_PATH = args.keyPath;
  if (args.outputPath) env.DOJ_OUTPUT_PATH = args.outputPath;
  if (args.doj) env.DOJ_BIN = args.doj;
  return env;
}

/** A path from the definition, relative to the swamp repository unless absolute. */
function resolvePath(repoDir: string, path: string): string {
  const full = path.startsWith("/") ? path : `${repoDir}/${path}`;
  // Without `.` and `..`, so logs and records name the directory plainly.
  const parts: string[] = [];
  for (const part of full.split("/")) {
    if (part === "..") parts.pop();
    else if (part !== "." && part !== "") parts.push(part);
  }
  return `/${parts.join("/")}`;
}

/** The global arguments with every path made absolute against the repository. */
function resolveArgs(args: GlobalArgs, repoDir: string): GlobalArgs {
  const optional = (path?: string) =>
    path === undefined ? undefined : resolvePath(repoDir, path);
  return {
    ...args,
    checkout: resolvePath(repoDir, args.checkout),
    planBuild: args.planBuild.includes("/")
      ? resolvePath(repoDir, args.planBuild)
      : args.planBuild,
    root: optional(args.root),
    keyPath: optional(args.keyPath),
    outputPath: resolvePath(repoDir, args.outputPath ?? "results"),
    doj: args.doj?.includes("/") ? resolvePath(repoDir, args.doj) : args.doj,
  };
}

/** Runs `start`, saying which setting to fix when doj-plan-build is not there. */
async function spawnable<T>(
  args: GlobalArgs,
  start: () => Promise<T>,
): Promise<T> {
  try {
    return await start();
  } catch (error) {
    if (error instanceof Deno.errors.NotFound) {
      throw new Error(
        `doj-plan-build is not at ${args.planBuild}: set planBuild to its path, or put it on PATH`,
      );
    }
    throw error;
  }
}

/** Runs doj-plan-build with `argv`, returning its exit code and output. */
async function runBuilder(
  args: GlobalArgs,
  argv: string[],
  signal?: AbortSignal,
): Promise<{ code: number; stdout: string; stderr: string }> {
  const out = await spawnable(args, () =>
    new Deno.Command(args.planBuild, {
      args: argv,
      env: builderEnv(args),
      stdout: "piped",
      stderr: "piped",
      signal,
    }).output());
  const decode = new TextDecoder();
  return {
    code: out.code,
    stdout: decode.decode(out.stdout),
    stderr: decode.decode(out.stderr),
  };
}

/** Each line of `stream`, as it arrives. */
async function* lines(
  stream: ReadableStream<Uint8Array>,
): AsyncGenerator<string> {
  let partial = "";
  for await (const chunk of stream.pipeThrough(new TextDecoderStream())) {
    const parts = (partial + chunk).split("\n");
    partial = parts.pop() ?? "";
    yield* parts;
  }
  if (partial) yield partial;
}

/**
 * Runs doj-plan-build with `argv`, sending each output line to `line` as it
 * comes, and returns its exit code and the last line it printed on stdout.
 */
async function streamBuilder(
  args: GlobalArgs,
  argv: string[],
  line: (text: string, stream: "stdout" | "stderr") => Promise<void>,
  env: Record<string, string>,
  signal?: AbortSignal,
): Promise<{ code: number; lastStdout: string }> {
  const child = await spawnable(args, () =>
    Promise.resolve(
      new Deno.Command(args.planBuild, {
        args: argv,
        env: { ...builderEnv(args), ...env },
        stdin: "null",
        stdout: "piped",
        stderr: "piped",
        signal,
      }).spawn(),
    ));
  let lastStdout = "";
  // One writer: the two streams take turns appending to the log.
  let queue = Promise.resolve();
  const send = (text: string, stream: "stdout" | "stderr") => {
    queue = queue.then(() => line(text, stream));
    return queue;
  };
  const pump = async (
    stream: ReadableStream<Uint8Array>,
    name: "stdout" | "stderr",
  ) => {
    for await (const text of lines(stream)) {
      if (name === "stdout" && text.trim()) lastStdout = text.trim();
      await send(text, name);
    }
  };
  await Promise.all([
    pump(child.stdout, "stdout"),
    pump(child.stderr, "stderr"),
  ]);
  const status = await child.status;
  await queue;
  return { code: status.code, lastStdout };
}

/** The package name an ident names: `origin/name[/version[/release]]` -> `name`. */
function identName(ident: string): string {
  return ident.split("/")[1] ?? ident;
}

/** Reads one plan with `doj-plan-build show`. */
async function showPlan(
  args: GlobalArgs,
  plan: string,
  signal?: AbortSignal,
): Promise<Plan> {
  const shown = await runBuilder(
    args,
    ["show", `${args.checkout}/${plan}`, "--target", args.target],
    signal,
  );
  if (shown.code !== 0) {
    throw new Error(
      `doj-plan-build show ${plan} --target ${args.target}: ${shown.stderr.trim()}`,
    );
  }
  const metadata = JSON.parse(shown.stdout) as Record<string, unknown>;
  const scaffolding = metadata.scaffolding;
  return {
    plan,
    target: args.target,
    name: String(metadata.name),
    origin: String(metadata.origin),
    version: typeof metadata.version === "string" ? metadata.version : null,
    deps: (metadata.deps as string[] | undefined) ?? [],
    buildDeps: (metadata.build_deps as string[] | undefined) ?? [],
    scaffolding: typeof scaffolding === "string"
      ? scaffolding
      : (scaffolding as { package?: string } | undefined)?.package ?? null,
    metadata,
  };
}

/** The plan directories in a checkout: top-level directories holding a plan.fnl. */
async function planDirs(plans: string): Promise<string[]> {
  const found: string[] = [];
  for await (const entry of Deno.readDir(plans)) {
    if (!entry.isDirectory || entry.name.startsWith(".")) continue;
    try {
      const info = await Deno.stat(`${plans}/${entry.name}/plan.fnl`);
      if (info.isFile) found.push(entry.name);
    } catch {
      // Not a plan.
    }
  }
  return found.sort();
}

/** A sha256 over a plan directory's files, paths and contents, so a changed plan rebuilds. */
async function planHash(dir: string): Promise<string> {
  const files: string[] = [];
  const walk = async (path: string, rel: string): Promise<void> => {
    for await (const entry of Deno.readDir(path)) {
      const childRel = rel ? `${rel}/${entry.name}` : entry.name;
      if (entry.isDirectory) await walk(`${path}/${entry.name}`, childRel);
      else if (entry.isFile) files.push(childRel);
    }
  };
  await walk(dir, "");
  files.sort();
  const encoder = new TextEncoder();
  const parts: Uint8Array[] = [];
  for (const rel of files) {
    parts.push(encoder.encode(`${rel}\0`));
    parts.push(await Deno.readFile(`${dir}/${rel}`));
    parts.push(encoder.encode("\0"));
  }
  const total = parts.reduce((n, p) => n + p.length, 0);
  const all = new Uint8Array(total);
  let at = 0;
  for (const p of parts) {
    all.set(p, at);
    at += p.length;
  }
  const digest = await crypto.subtle.digest("SHA-256", all);
  return Array.from(new Uint8Array(digest)).map((b) =>
    b.toString(16).padStart(2, "0")
  ).join("");
}

/** Whether a path exists. */
async function exists(path: string): Promise<boolean> {
  try {
    await Deno.stat(path);
    return true;
  } catch {
    return false;
  }
}

/** Runs `work` over `items`, at most `limit` at once, keeping the results' order. */
async function mapLimit<T, R>(
  items: T[],
  limit: number,
  work: (item: T) => Promise<R>,
): Promise<R[]> {
  const results = new Array<R>(items.length);
  let next = 0;
  const runners = Array.from(
    { length: Math.min(limit, items.length) },
    async () => {
      while (next < items.length) {
        const i = next++;
        results[i] = await work(items[i]);
      }
    },
  );
  await Promise.all(runners);
  return results;
}

/**
 * The base toolchain's plans in build order, from a file of `dojo-plans/<plan>`
 * lines: the first listing of each plan, without other repositories' entries
 * or the source project's build variables.
 */
async function readBaseOrder(path: string): Promise<string[]> {
  let text: string;
  try {
    text = await Deno.readTextFile(path);
  } catch (error) {
    if (error instanceof Deno.errors.NotFound) return [];
    throw error;
  }
  const order: string[] = [];
  for (const line of text.split("\n")) {
    const entry = line.trim().split(/\s+/)[0];
    if (!entry?.startsWith("dojo-plans/")) continue;
    const plan = entry.slice("dojo-plans/".length);
    if (!order.includes(plan)) order.push(plan);
  }
  return order;
}

/**
 * Orders plans into waves by their dependencies (run, build and scaffolding)
 * among `plans`; a dependency no plan provides is external. Plans in `base`
 * come first, one per wave in that order, since the base toolchain depends on
 * itself; a base plan's need for a later one is reported as `bootstrap`.
 */
export function orderWaves(
  plans: Plan[],
  base: string[] = [],
): {
  waves: string[][];
  external: string[];
  bootstrap: Array<{ plan: string; needs: string[] }>;
  cycle: string[];
} {
  const byName = new Map<string, string>();
  for (const p of plans) byName.set(p.name, p.plan);
  const needs = new Map<string, Set<string>>();
  const external = new Set<string>();
  for (const p of plans) {
    const set = new Set<string>();
    const idents = [
      ...p.deps,
      ...p.buildDeps,
      ...(p.scaffolding ? [p.scaffolding] : []),
    ];
    for (const ident of idents) {
      const dep = byName.get(identName(ident));
      if (dep === undefined) external.add(ident);
      else if (dep !== p.plan) set.add(dep);
    }
    needs.set(p.plan, set);
  }
  const waves: string[][] = [];
  const done = new Set<string>();
  const bootstrap: Array<{ plan: string; needs: string[] }> = [];
  for (const plan of base.filter((plan) => needs.has(plan))) {
    const later = [...needs.get(plan)!].filter((dep) => !done.has(dep)).sort();
    if (later.length > 0) bootstrap.push({ plan, needs: later });
    done.add(plan);
    waves.push([plan]);
  }
  let left = plans.map((p) => p.plan).filter((plan) => !done.has(plan));
  while (left.length > 0) {
    const wave = left.filter((plan) =>
      [...needs.get(plan)!].every((d) => done.has(d))
    ).sort();
    if (wave.length === 0) {
      return {
        waves,
        external: [...external].sort(),
        bootstrap,
        cycle: left.sort(),
      };
    }
    for (const plan of wave) done.add(plan);
    waves.push(wave);
    left = left.filter((plan) => !done.has(plan));
  }
  return { waves, external: [...external].sort(), bootstrap, cycle: [] };
}

/** The behavior: one definition per plans checkout and target. */
export const behavior = {
  type: "@strip-mall-karate/dojo",
  version: "2026.10.26.1",
  globalArguments: GlobalArgsSchema,
  resources: {
    plan: {
      description: "A plan's metadata for the target, from doj-plan-build show",
      schema: PlanSchema,
      lifetime: "infinite",
      garbageCollection: 5,
    },
    build: {
      description:
        "A plan's last build: the package's ident, prefix and artifact, or that it failed",
      schema: BuildSchema,
      lifetime: "infinite",
      garbageCollection: 10,
    },
    order: {
      description: "Plans in dependency order, as waves",
      schema: OrderSchema,
      lifetime: "infinite",
      garbageCollection: 10,
    },
  },
  files: {
    log: {
      description: "A build's output",
      contentType: "text/plain",
      lifetime: "30d",
      garbageCollection: 10,
    },
  },
  methods: {
    show: {
      description:
        "Read a plan's metadata for the target with doj-plan-build show",
      arguments: PlanArgsSchema,
      execute: async (
        args: z.infer<typeof PlanArgsSchema>,
        context: {
          globalArgs: GlobalArgs;
          repoDir: string;
          signal?: AbortSignal;
          logger: Logger;
          writeResource: WriteResource;
        },
      ): Promise<{ dataHandles: Array<{ name: string }> }> => {
        const g = resolveArgs(context.globalArgs, context.repoDir);
        context.logger.info("Reading {plan} for {target}", {
          plan: args.plan,
          target: g.target,
        });
        const plan = await showPlan(g, args.plan, context.signal);
        const handle = await context.writeResource(
          "plan",
          `plan-${args.plan}`,
          plan,
        );
        return { dataHandles: [handle] };
      },
    },
    build: {
      description:
        "Build a plan with doj-plan-build, unless its package from the same plan content is installed or a plan it depends on failed its last build",
      arguments: BuildArgsSchema,
      execute: async (
        args: z.infer<typeof BuildArgsSchema>,
        context: {
          globalArgs: GlobalArgs;
          repoDir: string;
          signal?: AbortSignal;
          logger: Logger;
          traceHeaders?: Readonly<Record<string, string>>;
          writeResource: WriteResource;
          readResource: (
            name: string,
          ) => Promise<Record<string, unknown> | null>;
          createFileWriter: (
            specName: string,
            name: string,
            overrides?: { streaming?: boolean },
          ) => DataWriter;
        },
      ): Promise<{ dataHandles: Array<{ name: string }> }> => {
        const g = resolveArgs(context.globalArgs, context.repoDir);
        const dir = `${g.checkout}/${args.plan}`;
        const hash = await planHash(dir);
        const last = await context.readResource(`build-${args.plan}`);
        if (
          !args.force && last?.status === "built" && last.planHash === hash &&
          last.target === g.target && await exists(String(last.prefix))
        ) {
          context.logger.info(
            "{plan} is already built from this plan: {ident}",
            {
              plan: args.plan,
              ident: last.ident,
            },
          );
          return { dataHandles: [] };
        }
        // A plan whose dependency failed would build against that dependency's
        // older package, or fail for want of it: stop the chain at the failure.
        if (!args.force) {
          const plan = await showPlan(g, args.plan, context.signal);
          const idents = [
            ...plan.deps,
            ...plan.buildDeps,
            ...(plan.scaffolding ? [plan.scaffolding] : []),
          ];
          for (
            const dep of idents.map(identName).filter((dep) =>
              dep !== args.plan
            )
          ) {
            const record = await context.readResource(`build-${dep}`);
            if (record?.status !== "failed" && record?.status !== "blocked") {
              continue;
            }
            // A failure in an earlier run says nothing about this one: the base
            // toolchain needs plans the base order builds after it.
            if (args.runId !== undefined && record.runId !== args.runId) {
              continue;
            }
            await context.writeResource("build", `build-${args.plan}`, {
              plan: args.plan,
              target: g.target,
              status: "blocked",
              exitCode: null,
              blockedBy: dep,
              runId: args.runId ?? null,
              ident: null,
              prefix: null,
              artifact: null,
              planHash: hash,
              startedAt: new Date().toISOString(),
              finishedAt: new Date().toISOString(),
              durationSeconds: 0,
            });
            throw new Error(
              `not building ${args.plan}: it depends on ${dep}, ${
                record.status === "failed"
                  ? "whose last build failed"
                  : "which was not built"
              }`,
            );
          }
        }
        context.logger.info("Building {plan} for {target}", {
          plan: args.plan,
          target: g.target,
        });
        const argv = [
          "build",
          dir,
          "--target",
          g.target,
          ...(args.check ? ["--check"] : []),
          ...(args.refuseHostPaths ? ["--refuse-host-paths"] : []),
        ];
        const trace: Record<string, string> = {};
        if (context.traceHeaders?.traceparent) {
          trace.TRACEPARENT = context.traceHeaders.traceparent;
        }
        if (context.traceHeaders?.tracestate) {
          trace.TRACESTATE = context.traceHeaders.tracestate;
        }
        // A failed build still writes its log and its record: the log is the
        // failure's evidence, and the record blocks the plans that depend on it.
        const logWriter = context.createFileWriter("log", `log-${args.plan}`, {
          streaming: true,
        });
        await logWriter.writeLine(`$ ${g.planBuild} ${argv.join(" ")}`);
        const tail: string[] = [];
        const installs = new Map<string, string>();
        let artifact: string | null = null;
        const startedAt = new Date();
        let ran: { code: number; lastStdout: string };
        try {
          ran = await streamBuilder(
            g,
            argv,
            async (text, stream) => {
              const line = stream === "stderr" ? `! ${text}` : text;
              tail.push(line);
              if (tail.length > 20) tail.shift();
              const installed = /Installed (\S+) in (\S+)$/.exec(text);
              if (installed) installs.set(installed[1], installed[2]);
              artifact = /: Artifact: (\S+)$/.exec(text)?.[1] ?? artifact;
              await logWriter.writeLine(line);
            },
            trace,
            context.signal,
          );
        } finally {
          await logWriter.finalize();
        }
        const finishedAt = new Date();
        const timing = {
          planHash: hash,
          startedAt: startedAt.toISOString(),
          finishedAt: finishedAt.toISOString(),
          durationSeconds: (finishedAt.getTime() - startedAt.getTime()) / 1000,
        };
        if (ran.code !== 0) {
          await context.writeResource("build", `build-${args.plan}`, {
            plan: args.plan,
            target: g.target,
            status: "failed",
            exitCode: ran.code,
            blockedBy: null,
            runId: args.runId ?? null,
            ident: null,
            prefix: null,
            artifact: null,
            ...timing,
          });
          throw new Error(
            `building ${args.plan} failed (exit ${ran.code}); the log is log-${args.plan}:\n${
              tail.join("\n")
            }`,
          );
        }
        // doj-plan-build prints the installed ident last; the log says where.
        const ident = ran.lastStdout;
        const prefix = installs.get(ident);
        if (ident.split("/").length !== 4 || prefix === undefined) {
          throw new Error(
            `building ${args.plan}: doj-plan-build finished without naming the package it installed`,
          );
        }
        const build = await context.writeResource(
          "build",
          `build-${args.plan}`,
          {
            plan: args.plan,
            target: g.target,
            status: "built",
            exitCode: 0,
            blockedBy: null,
            runId: args.runId ?? null,
            ident,
            prefix,
            artifact,
            ...timing,
          },
        );
        context.logger.info("Built {ident} in {seconds}s", {
          ident,
          seconds: Math.round(
            (finishedAt.getTime() - startedAt.getTime()) / 1000,
          ),
        });
        return { dataHandles: [build] };
      },
    },
    order: {
      description:
        "Order plans into dependency waves for building, with their dependencies",
      arguments: OrderArgsSchema,
      execute: async (
        args: z.infer<typeof OrderArgsSchema>,
        context: {
          globalArgs: GlobalArgs;
          repoDir: string;
          signal?: AbortSignal;
          logger: Logger;
          writeResource: WriteResource;
        },
      ): Promise<{ dataHandles: Array<{ name: string }> }> => {
        const g = resolveArgs(context.globalArgs, context.repoDir);
        context.logger.info("Reading the plans in {checkout} for {target}", {
          checkout: g.checkout,
          target: g.target,
        });
        const all = await planDirs(g.checkout);
        const skipped: Array<{ plan: string; reason: string }> = [];
        const shown = await mapLimit(all, 8, async (plan) => {
          try {
            return await showPlan(g, plan, context.signal);
          } catch (e) {
            skipped.push({ plan, reason: (e as Error).message });
            return null;
          }
        });
        const plans = shown.filter((p): p is Plan => p !== null);
        let chosen = plans;
        if (args.plans.length > 0) {
          const byPlan = new Map(plans.map((p) => [p.plan, p]));
          const byName = new Map(plans.map((p) => [p.name, p]));
          for (const want of args.plans) {
            if (!byPlan.has(want)) {
              const why = skipped.find((s) => s.plan === want)?.reason ??
                "no such plan";
              throw new Error(`cannot build ${want}: ${why}`);
            }
          }
          const keep = new Set<string>();
          const visit = (p: Plan): void => {
            if (keep.has(p.plan)) return;
            keep.add(p.plan);
            if (!args.withDependencies) return;
            for (
              const ident of [
                ...p.deps,
                ...p.buildDeps,
                ...(p.scaffolding ? [p.scaffolding] : []),
              ]
            ) {
              const dep = byName.get(identName(ident));
              if (dep) visit(dep);
            }
          };
          for (const want of args.plans) visit(byPlan.get(want)!);
          chosen = plans.filter((p) => keep.has(p.plan));
        }
        const base = await readBaseOrder(`${g.checkout}/${g.baseOrder}`);
        const { waves, external, bootstrap, cycle } = orderWaves(chosen, base);
        if (cycle.length > 0) {
          throw new Error(
            `these plans depend on each other in a cycle: ${cycle.join(", ")}`,
          );
        }
        context.logger.info("Ordered {count} plans into {waves} waves", {
          count: chosen.length,
          waves: waves.length,
        });
        const handle = await context.writeResource("order", "order", {
          target: g.target,
          waves,
          count: chosen.length,
          external,
          bootstrap,
          skipped: skipped.sort((a, b) => a.plan.localeCompare(b.plan)),
        });
        return { dataHandles: [handle] };
      },
    },
  },
};
