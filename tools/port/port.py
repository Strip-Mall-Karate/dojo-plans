"""Ports a package's plan.sh to plan.fnl.

    python3 tools/port/port.py <package-dir>...

Reads each plan statically (bashplan.py: nothing in it runs), writes
plan.fnl beside it, and prints one line per package: `ok`, or what is left
to port by hand. A callback this tool cannot translate is written as a
`;; UNPORTED` block holding the bash, which check.py refuses, so a plan is
never taken for ported while any of it is still shell.
"""

import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import bashplan  # noqa: E402
import translate  # noqa: E402

TARGET = "x86_64-linux"
KERNEL2 = "x86_64-linux-kernel2"
MAINTAINER = "Strip Mall Karate Company"

# What the build helpers stand for while a plan's top level is read. Paths a
# value can name at build time become markers the emitter turns into Fennel.
MARKERS = {
    "pkg_prefix": "@{prefix}",
    "PLAN_CONTEXT": "@{plan_dir}",
    "HAB_CACHE_SRC_PATH": "@{cache}",
    "CACHE_PATH": "@{src}",
    "SRC_PATH": "@{src}",
    "pkg_target": TARGET,
    "pkg_svc_path": "@{svc}",
    "pkg_svc_data_path": "@{svc}/data",
    "pkg_svc_config_path": "@{svc}/config",
    "pkg_svc_var_path": "@{svc}/var",
    "pkg_svc_files_path": "@{svc}/files",
    "pkg_svc_static_path": "@{svc}/static",
    "STUDIO_TYPE": "",
}

PHASE_OF = {
    "do_download": "download",
    "do_verify": "verify",
    "do_unpack": "unpack",
    "do_prepare": "prepare",
    "do_build": "build",
    "do_check": "check",
    "do_install": "install",
    "do_strip": "strip",
}

# Callbacks with no phase of their own: where their work goes.
FOLDED = {
    "do_begin": ("download", "before"),
    "do_before": ("download", "before"),
    "do_setup_environment": ("prepare", "before"),
    "do_after": ("strip", "after"),
    "do_end": ("strip", "after"),
}


def fennel_string(value):
    out = ['"']
    for c in value:
        if c == "\\":
            out.append("\\\\")
        elif c == '"':
            out.append('\\"')
        elif c == "\n":
            out.append("\\n")
        elif c == "\t":
            out.append("\\t")
        else:
            out.append(c)
    out.append('"')
    return "".join(out)


# The tree's rename (Habitat to Dojo, hab to doj, core to karate), applied to
# what the port writes. Quoted bash in an UNPORTED block keeps the original.
RENAME = [
    (re.compile(r"https?://github\.com/habitat-sh/core-plans"), "https://github.com/Strip-Mall-Karate/dojo-plans"),
    (re.compile(r"https?://github\.com/habitat-sh/habitat"), "https://github.com/Strip-Mall-Karate/dojo"),
    (re.compile(r"\bHAB_"), "DOJ_"),
    (re.compile(r"(?<![\w.])/hab(?=/|\b)"), "/doj"),
    (re.compile(r"\bv-hab-"), "v-doj-"),
    (re.compile(r"(?<![\w/.-])hab(?![\w-])"), "doj"),
    (re.compile(r"(?<![\w/@.-])core/(?=[a-z0-9])"), "karate/"),
    (re.compile(r"\bHABITAT\b"), "DOJO"),
    (re.compile(r"\bHabitat\b"), "Dojo"),
    (re.compile(r"(?<![\w.@/-])habitat(?![\w.-])"), "dojo"),
]


def renamed(text):
    out = []
    for line in text.split("\n"):
        if not line.lstrip().startswith(";;   "):
            for rx, rep in RENAME:
                line = rx.sub(rep, line)
        out.append(line)
    return "\n".join(out)


def ident(value):
    if value.startswith("core/"):
        return "karate/" + value[len("core/"):]
    return value


def svc_path(name, value):
    """A service path marker, made literal: services live under /doj/svc/<name>."""
    return value.replace("@{svc}", f"/doj/svc/{name}")


class Emitter:
    def __init__(self, name):
        self.name = name
        self.problems = []

    def value(self, key, raw):
        if "@{" in raw:
            self.problems.append(f"{key} names a build path: {raw}")
        return fennel_string(raw)

    def strings(self, key, values):
        return "[" + " ".join(self.value(key, v) for v in values) + "]"


def metadata(plan, name, emitter):
    """The plan's metadata as Fennel key-value lines, in the schema's order."""
    s, a, h = plan.scalars, plan.arrays, plan.assocs
    lines = []

    def put(key, text):
        lines.append(f":{key} {text}")

    put("name", fennel_string(s.get("pkg_name", name)))
    put("origin", '"karate"')
    if "pkg_version" in plan.functions or "update_pkg_version" in s:
        pass  # The version function is a callback; translate.py writes it.
    elif "pkg_version" in s:
        put("version", fennel_string(s["pkg_version"]))
    put("maintainer", fennel_string(MAINTAINER))
    licenses = a.get("pkg_license") or ([s["pkg_license"]] if "pkg_license" in s else [])
    if licenses:
        put("license", emitter.strings("license", licenses))
    if s.get("pkg_description", "").strip():
        description = re.sub(r"[ \t]*\n[ \t]*", "\n", s["pkg_description"].strip())
        description = re.sub(r"(?<=\S)[ \t]{2,}(?=\S)", " ", description)
        put("description", fennel_string(description))
    if s.get("pkg_upstream_url"):
        put("upstream_url", fennel_string(s["pkg_upstream_url"]))
    if s.get("pkg_source") and s.get("pkg_shasum") and not re.fullmatch(r"[0-9a-fA-F]{64}", s["pkg_shasum"]):
        emitter.problems.append(f"source has no checksum ({s['pkg_shasum']}): it fetches unverified code")
    elif s.get("pkg_source") and s.get("pkg_shasum"):
        fields = [f":url {emitter.value('source', s['pkg_source'])}", f":sha256 {fennel_string(s['pkg_shasum'])}"]
        if s.get("pkg_filename"):
            fields.append(f":filename {fennel_string(s['pkg_filename'])}")
        if s.get("pkg_dirname"):
            fields.append(f":dirname {fennel_string(s['pkg_dirname'])}")
        put("source", "{" + " ".join(fields) + "}")
    for var, key in (("pkg_deps", "deps"), ("pkg_build_deps", "build_deps")):
        values = [ident(v) for v in a.get(var, [])]
        if values:
            put(key, "[" + " ".join(fennel_string(v) for v in values) + "]")
    if s.get("pkg_scaffolding"):
        put("scaffolding", fennel_string(ident(s["pkg_scaffolding"])))
    for var, key in (("pkg_bin_dirs", "bin_dirs"), ("pkg_lib_dirs", "lib_dirs"),
                     ("pkg_include_dirs", "include_dirs"), ("pkg_pconfig_dirs", "pconfig_dirs"),
                     ("pkg_interpreters", "interpreters")):
        if a.get(var):
            # The source project joined each to the prefix, so a leading / named the same place.
            put(key, emitter.strings(key, [v.lstrip("/") for v in a[var]]))
    if s.get("pkg_svc_run"):
        fields = [f":run {emitter.value('svc.run', svc_path(name, s['pkg_svc_run']))}"]
        if s.get("pkg_svc_user"):
            fields.append(f":user {fennel_string(s['pkg_svc_user'])}")
        if s.get("pkg_svc_group"):
            fields.append(f":group {fennel_string(s['pkg_svc_group'])}")
        put("svc", "{" + " ".join(fields) + "}")
    elif s.get("pkg_svc_user") or s.get("pkg_svc_group"):
        # Started by its run hook: the build refuses this without hooks/run.
        fields = []
        if s.get("pkg_svc_user"):
            fields.append(f":user {fennel_string(s['pkg_svc_user'])}")
        if s.get("pkg_svc_group"):
            fields.append(f":group {fennel_string(s['pkg_svc_group'])}")
        put("svc", "{" + " ".join(fields) + "}")
    if h.get("pkg_exports"):
        put("exports", "{" + " ".join(f"{fennel_string(k)} {fennel_string(v)}"
                                      for k, v in h["pkg_exports"].items()) + "}")
    if a.get("pkg_exposes"):
        put("exposes", "[" + " ".join(fennel_string(v) for v in a["pkg_exposes"]) + "]")
    for var, key in (("pkg_binds", "binds"), ("pkg_binds_optional", "binds_optional")):
        if h.get(var):
            put(key, "{" + " ".join(
                f"{fennel_string(k)} [" + " ".join(fennel_string(e) for e in v.split()) + "]"
                for k, v in h[var].items()) + "}")
    return lines


def read_plan(path):
    with open(path, encoding="utf-8") as f:
        text = f.read()
    return bashplan.read(text, MARKERS, os.path.dirname(os.path.abspath(path))), text


def port(package_dir):
    name = os.path.basename(os.path.normpath(package_dir))
    plan, text = read_plan(os.path.join(package_dir, "plan.sh"))
    emitter = Emitter(name)
    for var, why in plan.unresolved.items():
        if var.startswith("pkg_") and var not in ("pkg_distname", "pkg_dist_name"):
            emitter.problems.append(f"{var} needs code to know: {why}")
    for statement in plan.unread:
        emitter.problems.append(f"top-level statement: {statement.strip().splitlines()[0][:80]}")

    out = [f";; {name}, ported from its plan.sh."]
    if plan.scalars.get("pkg_deprecated"):
        out.append(f";; Deprecated: {plan.scalars['pkg_deprecated']}")
    if plan.sourced:
        out.append(f";; Built from the {', '.join(plan.sourced)} plan, with its own changes.")
    body = metadata(plan, name, emitter)
    targets = [TARGET]
    kernel2_path = os.path.join(package_dir, KERNEL2, "plan.sh")
    kernel2 = None
    if os.path.isfile(kernel2_path):
        targets.append(KERNEL2)
        kernel2, _ = read_plan(kernel2_path)
    body.insert(3, ":targets [" + " ".join(fennel_string(t) for t in targets) + "]")

    phases, helpers = translate.callbacks(plan, emitter)
    out.extend(helpers)
    out.append("{" + "\n ".join(body + phases))
    if kernel2 is not None:
        k_emitter = Emitter(name)
        k_body = [line for line in metadata(kernel2, name, k_emitter)
                  if not line.startswith((":name ", ":origin ", ":maintainer "))]
        k_phases, k_helpers = translate.callbacks(kernel2, k_emitter)
        emitter.problems.extend(f"{KERNEL2}: {p}" for p in k_emitter.problems)
        # The target's definitions join the plan's, unless one names another body.
        defined = {d.split("\n", 1)[0]: d for d in helpers}
        for definition in k_helpers:
            head = definition.split("\n", 1)[0]
            if head not in defined:
                out.insert(len(out) - 1, definition)
            elif defined[head] != definition:
                emitter.problems.append(f"{KERNEL2}: {head} differs from the plan's")
        out.append(" :on {" + fennel_string(KERNEL2))
        out.append("      {" + "\n       ".join(k_body + k_phases) + "}}")
    out[-1] += "}"
    # Every problem is marked in the plan, so check.py holds it back until a
    # person has resolved it, whether or not a statement was kept as bash.
    notes = [f";; UNPORTED: {p}" for p in emitter.problems]
    out[1:1] = notes
    with open(os.path.join(package_dir, "plan.fnl"), "w", encoding="utf-8") as f:
        f.write(renamed("\n".join(out)) + "\n")
    return emitter.problems


def main(argv):
    status = 0
    for package_dir in argv:
        try:
            problems = port(package_dir)
        except Exception as e:  # noqa: BLE001 - one plan's failure must not stop the others.
            problems = [f"the port tool failed: {type(e).__name__}: {e}"]
        name = os.path.basename(os.path.normpath(package_dir))
        if problems:
            status = 1
            print(f"{name}: " + "; ".join(problems))
        else:
            print(f"{name}: ok")
    return status


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
