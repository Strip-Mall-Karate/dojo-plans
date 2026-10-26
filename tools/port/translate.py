"""Translates a plan's bash callbacks to Fennel phases.

Each statement becomes the b operation that does what the shell did: files
are copied, moved, removed, linked and edited through b, programs run
through b:run with an argument list, and environment variables are read and
set through b. A statement with no faithful translation is kept, as bash,
in a `;; UNPORTED` block for a person to port; check.py refuses a plan
holding one.
"""

import re

import bashplan

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
# Callbacks with no phase of their own, and the phase their work joins.
FOLDED = {
    "do_begin": "download",
    "do_before": "download",
    "do_setup_environment": "prepare",
    "do_after": "strip",
    "do_end": "strip",
}
ORDER = ["download", "verify", "unpack", "prepare", "build", "check", "install", "strip"]

# Variables whose value the build knows, as Fennel.
BUILD_VARS = {
    "pkg_prefix": "b.prefix",
    "PLAN_CONTEXT": "b.plan_dir",
    "HAB_CACHE_SRC_PATH": "b.cache",
    "CACHE_PATH": "b.src",
    "SRC_PATH": "b.src",
    "pkg_name": "b.name",
    "pkg_origin": "b.origin",
    "pkg_version": "b.version",
    "pkg_release": "b.release",
    "pkg_target": "b.target",
}
SVC_VARS = {
    "pkg_svc_path": "",
    "pkg_svc_data_path": "/data",
    "pkg_svc_config_path": "/config",
    "pkg_svc_var_path": "/var",
    "pkg_svc_files_path": "/files",
    "pkg_svc_static_path": "/static",
}


class Unported(Exception):
    """A statement with no faithful translation."""


def fstr(value):
    out = ['"']
    for c in value:
        out.append({"\\": "\\\\", '"': '\\"', "\n": "\\n", "\t": "\\t"}.get(c, c))
    out.append('"')
    return "".join(out)


def concat(parts):
    """Fennel for the concatenation of `parts`, each a Fennel expression."""
    merged = []
    for part in parts:
        if merged and part.startswith('"') and merged[-1].startswith('"') and part.endswith('"') and merged[-1].endswith('"'):
            merged[-1] = merged[-1][:-1] + part[1:]
        else:
            merged.append(part)
    merged = [p for p in merged if p != '""'] or ['""']
    if len(merged) == 1:
        return merged[0]
    return "(.. " + " ".join(merged) + ")"


class Scope:
    """What a callback knows while it is translated: its locals and its directory."""

    def __init__(self, plan, name, shared=(), params=0):
        self.plan = plan
        self.name = name
        self.locals = {v: _local(v) for v in shared}
        self.shared = set(shared)
        # Variables declared at the function's top; assigning one is a set.
        self.declared = set()
        self.params = params
        # The value of each local that is a plain string, for expansions on it.
        self.literal = {}
        self.cwd = []  # Fennel expressions, innermost last.
        # Set when a cd or pushd could not be translated: nothing after it knows its directory.
        self.lost_cwd = False
        self.helpers_used = set()

    def var(self, name):
        if name in self.locals:
            return self.locals[name]
        if name in BUILD_VARS:
            return BUILD_VARS[name]
        if name in SVC_VARS:
            return fstr(f"/doj/svc/{self.name}{SVC_VARS[name]}")
        if name == "pkg_dirname" and "pkg_dirname" not in self.plan.scalars:
            return concat(["b.name", '"-"', "b.version"])
        if name == "pkg_filename" and "pkg_filename" not in self.plan.scalars and "pkg_source" in self.plan.scalars:
            return fstr(self.plan.scalars["pkg_source"].rstrip("/").rsplit("/", 1)[-1])
        if name in self.plan.scalars:
            return fstr(self.plan.scalars[name])
        if name in self.plan.arrays:
            return fstr(" ".join(self.plan.arrays[name]))
        if re.fullmatch(r"[A-Z][A-Z0-9_]*", name):
            return f'(or (b:getenv {fstr(name)}) "")'
        raise Unported(f"${name}")


def word(text, scope):
    """A bash word as one Fennel string expression."""
    parts = []
    i = 0
    n = len(text)
    while i < n:
        c = text[i]
        if c == "'":
            j = text.index("'", i + 1)
            parts.append(fstr(text[i + 1:j]))
            i = j + 1
        elif c == '"':
            j = bashplan._skip_quoted(text, i)
            parts.extend(_dquoted(text[i + 1:j - 1], scope))
            i = j
        elif c == "\\" and i + 1 < n:
            parts.append(fstr(text[i + 1]))
            i += 2
        elif c == "$":
            expr, i = _param(text, i, scope)
            parts.append(expr)
        elif c in "*?[" and not re.search(r"[:@=]", text):
            raise Unported("glob in " + text)
        elif c == "~":
            raise Unported("~ in " + text)
        elif c == "`":
            raise Unported("backticks")
        else:
            parts.append(fstr(c))
            i += 1
    return concat(parts)


def word_parts(text, scope):
    """A bash word as [("lit", text) | ("expr", fennel)], literal text kept raw."""
    parts = []

    def lit(t):
        if parts and parts[-1][0] == "lit":
            parts[-1] = ("lit", parts[-1][1] + t)
        else:
            parts.append(("lit", t))

    i = 0
    n = len(text)
    while i < n:
        c = text[i]
        if c == "'":
            j = text.index("'", i + 1)
            lit(text[i + 1:j])
            i = j + 1
        elif c == '"':
            j = bashplan._skip_quoted(text, i)
            body = text[i + 1:j - 1]
            k = 0
            while k < len(body):
                ch = body[k]
                if ch == "\\" and k + 1 < len(body):
                    nxt = body[k + 1]
                    lit(nxt if nxt in '$`"\\' else ch + nxt)
                    k += 2
                elif ch == "$":
                    expr, k = _param(body, k, scope)
                    parts.append(("expr", expr))
                else:
                    lit(ch)
                    k += 1
            i = j
        elif c == "\\" and i + 1 < n:
            lit(text[i + 1])
            i += 2
        elif c == "$":
            expr, i = _param(text, i, scope)
            parts.append(("expr", expr))
        else:
            lit(c)
            i += 1
    return parts


def _dquoted(body, scope):
    parts = []
    i = 0
    n = len(body)
    while i < n:
        c = body[i]
        if c == "\\" and i + 1 < n:
            nxt = body[i + 1]
            if nxt in '$`"\\':
                parts.append(fstr(nxt))
            elif nxt != "\n":
                parts.append(fstr(c + nxt))
            i += 2
        elif c == "$":
            expr, i = _param(body, i, scope)
            parts.append(expr)
        elif c == "`":
            raise Unported("backticks")
        else:
            parts.append(fstr(c))
            i += 1
    return parts


def _param(text, i, scope):
    if text.startswith("$(", i):
        j = bashplan._skip_balanced(text, i + 1, "(", ")")
        return substitution(text[i + 2:j - 1].strip(), scope), j
    if text.startswith("${", i):
        j = bashplan._skip_balanced(text, i + 1, "{", "}")
        inner = text[i + 2:j - 1]
        unset_check = re.fullmatch(r"([A-Za-z_][A-Za-z0-9_]*):?\?.*", inner, re.S)
        if unset_check:
            inner = unset_check.group(1)  # The build fails on an unset variable anyway.
        if bashplan.NAME.fullmatch(inner):
            return scope.var(inner), j
        if inner.isdigit() and 1 <= int(inner) <= scope.params:
            return f"a{inner}", j
        try:
            name = bashplan.NAME.match(inner).group(0)
            env = {k: v for k, v in scope.plan.scalars.items()}
            env.update({k: v for k, v in scope.plan.arrays.items()})
            env.update(scope.literal)
            if name in scope.locals and name not in scope.literal:
                raise Unported("${" + inner + "}")
            if name in BUILD_VARS and name not in ("pkg_name", "pkg_version") and name not in scope.locals:
                raise Unported("${" + inner + "}")
            value = bashplan._braced(inner, env)
            return fstr(value), j
        except (bashplan.Unresolved, AttributeError, ValueError, IndexError) as e:
            raise Unported("${" + inner + "}") from e
    m = bashplan.NAME.match(text, i + 1)
    if m:
        return scope.var(m.group(0)), m.end()
    if text[i + 1:i + 2] == "?":
        # The last command's status: 0, as a failing one has already stopped the build.
        return '"0"', i + 2
    d = re.match(r"\d", text[i + 1:i + 2])
    if d and 1 <= int(d.group(0)) <= scope.params:
        return f"a{d.group(0)}", i + 2
    raise Unported(text[i:i + 2])


def substitution(command, scope):
    """$(command) as a Fennel expression."""
    words = bashplan.split_words(command)
    if not words:
        raise Unported("$()")
    if words[0] == "pkg_path_for" and len(words) == 2:
        return f"(b:path_for {_dep(words[1], scope)})"
    if words[0] == "pkg_interpreter_for" and len(words) == 3:
        return f"(b:path_for {_dep(words[1], scope)} {word(words[2], scope)})"
    cut = re.fullmatch(r'echo\s+("?\$\{?(\w+)\}?"?)\s*\|\s*cut\s+-d\s*["\']?(.)["\']?\s+-f\s*(\d+)(?:-(\d+))?', command)
    if cut:
        value = word(cut.group(1), scope)
        if not (value.startswith('"') and value.endswith('"')):
            raise Unported(f"$({command})")
        fields = value[1:-1].split(cut.group(3))
        lo, hi = int(cut.group(4)), int(cut.group(5) or cut.group(4))
        return fstr(cut.group(3).join(fields[lo - 1:hi]))
    if words[:3] == ["hab", "pkg", "path"] and len(words) == 4:
        return f"(b:path_for {_dep(words[3], scope)})"
    if words[0] == "abspath" and len(words) == 2:
        rel = word(words[1], scope)
        if rel == '".."':
            return f'(: {base(scope)} :match "^(.*)/[^/]+$")'
        if rel in ('"."', '"./"'):
            return base(scope)
        if rel.startswith('"') and ".." not in rel:
            return anchor(rel, scope)
        raise Unported(f"$({command})")
    if words[0] in BUILDER_HELPERS:
        raise Unported(f"the source project's builder function {words[0]}")
    if words[0] == "nproc" and len(words) == 1:
        return "(tostring b.jobs)"
    if any(w in ("|", "||", "&&", ";") or w.startswith(("|", ">", "<", "2>")) for w in words) or "|" in command:
        raise Unported(f"$({command})")
    return f"(b:capture {argv(words, scope)})"


def _dep(text, scope):
    value = word(text, scope)
    if value.startswith('"core/'):
        value = '"karate/' + value[len('"core/'):]
    return value


def argv(words, scope):
    return "[" + " ".join(word(w, scope) for w in words) + "]"


GLOB = re.compile(r"[*?]")

ABSOLUTE = re.compile(r'^(\(\.\. )?("/|b\.(prefix|src|cache|plan_dir)\b|\(b:path_for |\(b:join b\.)')


def base(scope):
    """The directory relative paths name: the pushd or cd directory, or b.src."""
    if not scope.cwd:
        return "b.src"
    cwd = scope.cwd[-1]
    return cwd if ABSOLUTE.match(cwd) or not cwd.startswith('"') else f"(b:join b.src {cwd})"


def anchor(expr, scope):
    """`expr` as an absolute path. b's writes take a relative path inside the
    prefix and its reads from b.src; the shell took both from its working
    directory, so a literal relative path is joined to it."""
    if ABSOLUTE.match(expr) or not (expr.startswith('"') or expr.startswith('(.. "')):
        return expr
    if expr in ('"."', '"./"'):
        return base(scope)
    if expr.startswith('"./'):
        expr = '"' + expr[3:]
    return f"(b:join {base(scope)} {expr})"


def path(text, scope):
    return anchor(word(text, scope), scope)


def paths(text, scope):
    """A path argument as a list of Fennel expressions, or one expression
    for a glob, marked with a leading `*` for each-over."""
    if GLOB.search(_unquoted(text)):
        # dir/pattern with the glob only in the last component.
        raw = _unquoted_split(text)
        if raw is None:
            raise Unported("glob " + text)
        directory, pattern = raw
        if directory in ("", "."):
            where = base(scope)
        else:
            where = anchor(word(directory, scope), scope)
        return "*", f"(b:glob {where} {fstr(pattern)})"
    return "", path(text, scope)


def _unquoted(text):
    out = []
    i = 0
    while i < len(text):
        c = text[i]
        if c in "'\"" or text.startswith("$(", i) or text.startswith("${", i):
            j = bashplan._skip_quoted(text, i)
            out.append("_" * (j - i))
            i = j
        else:
            out.append(c)
            i += 1
    return "".join(out)


def _unquoted_split(text):
    """(directory word, glob pattern) when only the last path part is a glob."""
    quoted = re.fullmatch(r'("[^"]*")(/?)([A-Za-z0-9_.*?+@-]*)', text)
    if quoted and GLOB.search(quoted.group(3)):
        directory = quoted.group(1)
        if not quoted.group(2):
            if not directory.endswith('/"'):
                return None
            directory = directory[:-2] + '"'
        return directory, quoted.group(3)
    masked = _unquoted(text)
    slash = masked.rfind("/")
    tail = text[slash + 1:]
    if GLOB.search(masked[:slash + 1] if slash >= 0 else ""):
        return None
    if not re.fullmatch(r"[A-Za-z0-9_.*?+@-]*", tail):
        return None
    return (text[:slash] if slash >= 0 else ""), tail


def each_path(text, scope, body):
    """Fennel applying `body` (a format with {p}) to each path `text` names."""
    kind, expr = paths(text, scope)
    if kind == "*":
        return f"(each [_ p (ipairs {expr})] {body.replace('{p}', 'p')})"
    return body.replace("{p}", expr)


def basename(expr):
    if expr.startswith('"') and expr.endswith('"') and "\\" not in expr:
        return fstr(expr[1:-1].rstrip("/").rsplit("/", 1)[-1])
    return f'(: {expr} :match "[^/]+$")'


def flags(words, allowed):
    """Splits leading -flags off, checking each against `allowed` letters/words."""
    found = set()
    rest = list(words)
    while rest and rest[0].startswith("-") and rest[0] != "-":
        f = rest.pop(0)
        if f == "--":
            break
        if f.startswith("--"):
            if f not in allowed:
                raise Unported("flag " + f)
            found.add(f)
            continue
        for letter in f[1:]:
            if letter not in allowed:
                raise Unported("flag -" + letter)
            found.add(letter)
    return found, rest


DIRLIKE = re.compile(r"/$|(^|/)(bin|sbin|lib|lib64|libexec|share|include|etc|man\d?|doc|docs|config|hooks)$")


def into_dir(dest_word):
    """Whether a destination names a directory: a trailing slash or a directory's usual name."""
    bare = dest_word.replace('"', "").replace("'", "")
    return bool(DIRLIKE.search(bare))


def cmd_cp(words, scope, move=False):
    found, rest = flags(words, set("arRvfpLPdnuTt") | {"--preserve=mode", "--preserve=links", "--parents"} if not move else set("vfnT"))
    if "--parents" in found or "t" in found:
        raise Unported("cp --parents/-t")
    if len(rest) < 2:
        raise Unported("cp arity")
    *sources, dest = rest
    op = "b:move" if move else "b:copy"
    dest_expr = path(dest, scope)
    many = len(sources) > 1 or any(GLOB.search(_unquoted(s)) for s in sources)
    out = []
    for src in sources:
        if many or dest.rstrip('"').endswith("/"):
            out.append(_into(op, src, dest_expr, scope))
        elif "T" in found:
            out.append(f"({op} {path(src, scope)} {dest_expr})")
        else:
            # cp and mv copy into a directory that is there, and onto the path otherwise.
            out.append(f"(if (b:exists {dest_expr})\n  {_into(op, src, dest_expr, scope)}\n  ({op} {path(src, scope)} {dest_expr}))")
    return out


def _into(op, src, dest_expr, scope):
    kind, expr = paths(src, scope)
    if kind == "*":
        return f'(each [_ p (ipairs {expr})] ({op} p (b:join {dest_expr} (: p :match "[^/]+$"))))'
    return f"({op} {expr} (b:join {dest_expr} {basename(expr)}))"


def cmd_rm(words, scope):
    _, rest = flags(words, set("rRfvd"))
    return [each_path(w, scope, "(b:remove {p})") for w in rest]


def cmd_mkdir(words, scope):
    _, rest = flags(words, set("pv"))
    out = []
    for w in rest:
        if w.startswith("-m"):
            raise Unported("mkdir -m")
        out.append(f"(b:mkdir {path(w, scope)})")
    return out


def cmd_ln(words, scope):
    found, rest = flags(words, set("sfvnrT"))
    if "s" not in found:
        raise Unported("hard link")
    if len(rest) == 1:
        target, link = rest[0], None
    elif len(rest) == 2:
        target, link = rest
    else:
        raise Unported("ln arity")
    target_expr = word(target, scope)
    if link is None:
        link_expr = anchor(basename(target_expr), scope)
    else:
        link_expr = path(link, scope)
        if into_dir(link):
            link_expr = f"(b:join {link_expr} {basename(target_expr)})"
    out = []
    if "r" in found:
        # Relative link: only when target and link are in the same directory.
        t_dir = target_expr.rsplit("/", 1)[0] if target_expr.startswith("(..") else None
        l_dir = link_expr.rsplit("/", 1)[0] if link_expr.startswith("(..") else None
        if t_dir is None or t_dir != l_dir:
            raise Unported("ln -r across directories")
        target_expr = basename(target_expr)
    if "f" in found:
        out.append(f"(b:remove {link_expr})")
    out.append(f"(b:symlink {target_expr} {link_expr})")
    return out


def cmd_chmod(words, scope):
    _, rest = flags(words, set("Rvf"))
    symbolic = r"[ugoa]*[-+=][rwxXst]*(,[ugoa]*[-+=][rwxXst]*)*"
    if len(rest) < 2 or not (re.fullmatch(r"[0-7]{3,4}", rest[0]) or re.fullmatch(symbolic, rest[0])):
        raise Unported("chmod " + " ".join(rest[:1]))
    mode = fstr(rest[0])
    return [each_path(w, scope, "(b:chmod {p} " + mode + ")") for w in rest[1:]]


def cmd_install(words, scope):
    mode = None
    target_dir = None
    directory = False
    create_parents = False
    rest = []
    it = iter(words)
    for w in it:
        if w in ("-v", "--verbose", "-c", "-s", "--strip", "-p", "--preserve-timestamps", "-C", "--compare"):
            continue
        if w in ("-t", "--target-directory"):
            target_dir = next(it)
            continue
        if w in ("-d", "--directory"):
            directory = True
        elif w == "-D":
            create_parents = True
        elif re.fullmatch(r"-[Dvdc]*m[0-7]{3,4}", w):
            create_parents = create_parents or "D" in w
            directory = directory or "d" in w
            mode = re.search(r"[0-7]{3,4}", w).group(0)
        elif re.fullmatch(r"-[Dvdc]*m", w):
            create_parents = create_parents or "D" in w
            directory = directory or "d" in w
            mode = next(it)
            if not re.fullmatch(r"[0-7]{3,4}", mode):
                raise Unported("install -m " + mode)
        elif w in ("-m", "--mode"):
            mode = next(it)
            if not re.fullmatch(r"[0-7]{3,4}", mode):
                raise Unported("install -m " + mode)
        elif re.fullmatch(r"-[Dvcdp]+", w):
            create_parents = create_parents or "D" in w
            directory = directory or "d" in w
        elif w.startswith("-"):
            raise Unported("install " + w)
        else:
            rest.append(w)
    # install -D copies onto the destination path; without it a directory there is copied into.
    create_parents_seen = create_parents
    if mode is None and not directory:
        mode = "755"  # install's own default.
    if directory:
        out = []
        for w in rest:
            out.append(f"(b:mkdir {path(w, scope)})")
            if mode:
                out.append(f"(b:chmod {path(w, scope)} {fstr(mode)})")
        return out
    if target_dir is not None:
        rest = rest + [target_dir.rstrip("/") + "/" if not target_dir.endswith('"') else target_dir[:-1] + '/"']
    if len(rest) < 2:
        raise Unported("install arity")
    *sources, dest = rest
    out = []
    many = len(sources) > 1 or any(GLOB.search(_unquoted(s)) for s in sources)
    dest_expr = path(dest, scope)
    for src in sources:
        if many or dest.rstrip('"').endswith("/") or into_dir(dest) and not create_parents_seen:
            kind, expr = paths(src, scope)
            if kind == "*":
                chmod = f" (b:chmod (b:join {dest_expr} (: p :match \"[^/]+$\")) {fstr(mode)})" if mode else ""
                out.append(f'(each [_ p (ipairs {expr})] (b:copy p (b:join {dest_expr} (: p :match "[^/]+$"))){chmod})')
                continue
            target = f"(b:join {dest_expr} {basename(expr)})"
            out.append(f"(b:copy {expr} {target})")
        else:
            target = dest_expr
            out.append(f"(b:copy {path(src, scope)} {target})")
        if mode:
            out.append(f"(b:chmod {target} {fstr(mode)})")
    return out


SED_EXPR = re.compile(r"^s(.)(.*?)(?<!\\)\1(.*?)(?<!\\)\1([gI0-9]*)$", re.S)


def sed_to_lua(pattern, extended):
    """A sed regex as a Lua pattern, for the forms both can say."""
    out = []
    i = 0
    n = len(pattern)
    while i < n:
        c = pattern[i]
        if c == "\\" and i + 1 < n:
            nxt = pattern[i + 1]
            if nxt in "()" and not extended:
                # A BRE group is a Lua capture; Lua cannot repeat one.
                out.append(nxt)
                if nxt == ")" and pattern[i + 2:i + 3] in ("*", "+", "?", "\\"):
                    raise Unported("sed repeated group")
                i += 2
                continue
            if nxt in "|+?{}" and not extended:
                raise Unported("sed alternation or interval")
            if nxt in "[].*^$/\\-+?()":
                out.append("%" + nxt if nxt not in "/" else nxt)
            elif nxt == "n":
                out.append("\n")
            elif nxt == "t":
                out.append("\t")
            elif nxt in "#@,|:;!=_~&\"'<>`":
                out.append(nxt)
            elif nxt in "sSdDwW":
                out.append("%" + {"s": "s", "S": "S", "d": "d", "D": "D", "w": "w", "W": "W"}[nxt])
            else:
                raise Unported("sed escape \\" + nxt)
            i += 2
        elif c in "()" and extended:
            out.append(c)
            if c == ")" and pattern[i + 1:i + 2] in ("*", "+", "?"):
                raise Unported("sed repeated group")
            i += 1
        elif c in "|{}" and extended:
            raise Unported("sed alternation or interval")
        elif c == "+" and extended:
            out.append("+")
            i += 1
        elif c == "?" and extended:
            out.append("?")
            i += 1
        elif c in "-%":
            out.append("%" + c)
            i += 1
        elif c in "()+?" and not extended:
            # Plain characters in a basic regex; special in a Lua pattern.
            out.append("%" + c)
            i += 1
        elif c == "[":
            j = pattern.index("]", i + 2 if pattern[i + 1:i + 2] in ("^", "]") else i + 1)
            cls = pattern[i:j + 1]
            if "[:" in cls:
                cls = (cls.replace("[:space:]", "%s").replace("[:digit:]", "%d").replace("[:alpha:]", "%a")
                       .replace("[:alnum:]", "%w").replace("[:upper:]", "%u").replace("[:lower:]", "%l"))
                if "[:" in cls:
                    raise Unported("sed class " + cls)
            out.append(cls)
            i = j + 1
        else:
            out.append(c)
            i += 1
    return "".join(out)


def sed_replacement(text):
    out = []
    i = 0
    while i < len(text):
        c = text[i]
        if c == "\\" and i + 1 < len(text):
            nxt = text[i + 1]
            if nxt.isdigit():
                out.append("%" + nxt)
            else:
                out.append({"n": "\n", "t": "\t", "%": "%%"}.get(nxt, nxt))
            i += 2
        elif c == "&":
            out.append("%0")
            i += 1
        elif c == "%":
            out.append("%%")
            i += 1
        else:
            out.append(c)
            i += 1
    return "".join(out)


def cmd_sed(words, scope):
    extended = False
    exprs = []
    rest = []
    inplace = False
    it = iter(words)
    for w in it:
        if w.startswith("-i") or w.startswith("--in-place"):
            inplace = True
            if len(w) > 2 and not w.startswith("--"):
                pass  # -i.bak keeps a backup the build never reads.
        elif w in ("-r", "-E", "--regexp-extended"):
            extended = True
        elif w in ("-ir", "-ri"):
            inplace = extended = True
        elif w in ("-e", "--expression"):
            exprs.append(next(it))
        elif w.startswith("-"):
            raise Unported("sed " + w)
        else:
            rest.append(w)
    if not inplace:
        raise Unported("sed without -i")
    if not exprs:
        if not rest:
            raise Unported("sed arity")
        exprs.append(rest.pop(0))
    ops = [sed_operation(word_parts(e, scope), extended) for e in exprs]
    body = ("(let [text (b:read {p}) ends (= (text:sub -1) \"\\n\") lines [] out []]\n"
            "  (each [l (string.gmatch (if ends text (.. text \"\\n\")) \"(.-)\\n\")] (table.insert lines l))\n"
            "  (each [n l (ipairs lines)]\n"
            "    (var line l) (var deleted false) (local after [])\n"
            + "".join(f"    (when (not deleted) {op})\n" for op in ops) +
            "    (when (not deleted) (table.insert out line))\n"
            "    (each [_ x (ipairs after)] (table.insert out x)))\n"
            "  (b:write {p} (.. (table.concat out \"\\n\") (if (and ends (> (length out) 0)) \"\\n\" \"\"))))")
    return [each_path(f, scope, body) for f in rest]


SED_ADDRESS = re.compile(r"(\d+)(?:,(\d+|\$))?|\$|/((?:[^/\\]|\\.)*)/")


def sed_operation(parts, extended):
    """One sed expression as a Fennel form run on each `line` (numbered `n`, of `lines`)."""
    if not parts or parts[0][0] != "lit":
        raise Unported("sed expression")
    text = parts[0][1]
    cond = None
    m = SED_ADDRESS.match(text)
    if m and m.end() > 0:
        if m.group(3) is not None:
            cond = f"(string.find line {fstr(sed_to_lua(m.group(3), extended))})"
        elif m.group(0) == "$":
            cond = "(= n (length lines))"
        elif m.group(2) == "$":
            cond = f"(>= n {m.group(1)})"
        elif m.group(2):
            cond = f"(and (>= n {m.group(1)}) (<= n {m.group(2)}))"
        else:
            cond = f"(= n {m.group(1)})"
        text = text[m.end():].lstrip()
    parts = [("lit", text)] + parts[1:]
    if not text:
        raise Unported("sed expression")
    command = text[0]
    if command == "s":
        pat, rep, count = sed_substitution(parts, extended)
        form = f"(set line (pick-values 1 (string.gsub line {pat} {rep}{count})))"
    elif command == "d" and text.strip() == "d" and len(parts) == 1:
        form = "(set deleted true)"
    elif command in "ia" and len(parts) == 1:
        rest = text[1:]
        rest = rest[1:] if rest.startswith("\\") else rest
        rest = rest[1:] if rest.startswith("\n") else rest.lstrip()
        if "\n" in rest:
            raise Unported("sed multi-line text")
        form = (f"(table.insert out {fstr(rest)})" if command == "i" else f"(table.insert after {fstr(rest)})")
    else:
        raise Unported("sed " + text[:30])
    return form if cond is None else f"(when {cond} {form})"


# A variable's value inside a sed pattern or replacement: Lua's magic
# characters escaped, as the shell's value is meant literally there.
LUA_MAGIC = '"[%^%$%(%)%%%.%[%]%*%+%-%?]"'


def sed_substitution(parts, extended):
    """`s<d>pattern<d>replacement<d>flags` from word parts, as Fennel (pattern, replacement, count)."""
    if not parts or parts[0][0] != "lit" or len(parts[0][1]) < 2 or parts[0][1][0] != "s":
        raise Unported("sed " + "".join(t if k == "lit" else "$" for k, t in parts)[:40])
    delim = parts[0][1][1]
    parts = [("lit", parts[0][1][2:])] + parts[1:]
    sections = [[]]
    for kind, text in parts:
        if kind == "expr":
            sections[-1].append((kind, text))
            continue
        piece = ""
        i = 0
        while i < len(text):
            if text[i] == "\\" and i + 1 < len(text):
                piece += text[i:i + 2]
                i += 2
            elif text[i] == delim:
                sections[-1].append(("lit", piece))
                sections.append([])
                piece = ""
                i += 1
            else:
                piece += text[i]
                i += 1
        sections[-1].append(("lit", piece))
    if len(sections) != 3:
        raise Unported("sed expression")
    pattern, replacement, flag_parts = sections
    if any(k == "expr" for k, _ in flag_parts):
        raise Unported("sed flags")
    flags = "".join(t for _, t in flag_parts)
    if re.search(r"[^g]", flags):
        raise Unported("sed flag " + flags)
    pat = []
    for kind, text in pattern:
        if kind == "expr":
            pat.append(f"(pick-values 1 (: {text} :gsub {LUA_MAGIC} \"%%%0\"))")
        elif text:
            lua = sed_to_lua(text, extended)
            if "\n" in lua:
                raise Unported("sed multiline")
            pat.append(fstr(lua))
    repl = []
    for kind, text in replacement:
        if kind == "expr":
            repl.append(f"(pick-values 1 (: {text} :gsub \"%%\" \"%%%%\"))")
        elif text:
            repl.append(fstr(sed_replacement(text)))
    if not pat:
        raise Unported("sed empty pattern")
    return concat(pat), concat(repl or ['""']), "" if "g" in flags else " 1"


def _line_anchor(pat):
    """sed works a line at a time: ^ and $ anchor lines, not the whole file."""
    if pat.startswith("^") or pat.endswith("$") and not pat.endswith("%$"):
        raise Unported("sed line anchor")
    return pat


def cmd_fix_interpreter(words, scope):
    if len(words) != 3:
        raise Unported("fix_interpreter arity")
    target, dep, interp = words
    kind, expr = paths(target, scope)
    files = expr if kind == "*" else f"[{expr}]"  # paths() anchors both forms.
    return [f"(b:fix_interpreter {files} {_dep(dep, scope)} {word(interp, scope)})"]


def cmd_patch(words, scope, stdin):
    args = list(words)
    if stdin is not None:
        args += ["-i", stdin]
    return [f"(b:run {argv(['patch'] + args, scope)}{scope_cwd(scope)})"]


def cmd_download_file(words, scope):
    if len(words) < 2:
        raise Unported("download_file arity")
    url, name = words[0], words[1]
    if len(words) < 3:
        raise Unported("download_file without a checksum")
    return [f"(b:download {word(url, scope)} {word(words[2], scope)} {word(name, scope)})"]


def scope_cwd(scope, env=None):
    fields = []
    if scope.cwd:
        fields.append(f":cwd {scope.cwd[-1]}")
    if env:
        fields.append(":env {" + " ".join(f"{fstr(k)} {v}" for k, v in env) + "}")
    return " {" + " ".join(fields) + "}" if fields else ""


def assignment(stmt, scope, exported):
    m = bashplan.ASSIGN.match(stmt)
    var, append = m.group(1), m.group(2) == "+"
    value_text = stmt[m.end():]
    if value_text.startswith("("):
        inner = value_text[1:bashplan._skip_balanced(value_text, 0, "(", ")") - 1]
        items = [word(w, scope) for w in bashplan.split_words(inner)]
        fennel = "[" + " ".join(items) + "]"
        name = _local(var)
        if var in scope.locals or var in scope.declared:
            return [f"(set {name} {fennel})"]
        scope.locals[var] = name
        return [f"(var {name} {fennel})"]
    words = bashplan.split_words(value_text)
    value = word(words[0], scope) if words else '""'
    if append:
        value = concat([scope.var(var), value])
    if re.fullmatch(r'"(?:[^"\\]|\\.)*"', value) and not append:
        scope.literal[var] = bytes(value[1:-1], "utf-8").decode("unicode_escape")
    else:
        scope.literal.pop(var, None)
    if exported or re.fullmatch(r"[A-Z][A-Z0-9_]*", var) and var not in scope.locals:
        if exported or var in ENV_LIKE:
            return [f"(b:env {fstr(var)} {value})"]
    name = _local(var)
    if var in scope.locals or var in scope.shared:
        return [f"(set {name} {value})"]
    scope.locals[var] = name
    return [f"(var {name} {value})"]


# Functions of the source project's builder: none is a program, so a call to
# one is translated or left for a person, never run.
BUILDER_HELPERS = {"update_pkg_version", "pkg_interpreter_for", "abspath", "trim", "record", "exists_in_path",
                   "add_path_env", "add_env", "pkg_path_for", "fix_interpreter", "download_file", "attach",
                   "exit_with", "build_line", "warn", "info", "debug", "set_runtime_env", "push_runtime_env",
                   "set_buildtime_env", "push_buildtime_env", "_resolve_dependency", "_render_metadata_FILES"}


# Variables a plan sets without `export` that the build reads anyway (the
# shell exported them from the builder).
ENV_LIKE = {"CFLAGS", "CXXFLAGS", "CPPFLAGS", "LDFLAGS", "LD_RUN_PATH", "PATH", "LD_LIBRARY_PATH",
            "PKG_CONFIG_PATH", "CC", "CXX", "PREFIX", "GOPATH", "GOROOT", "CGO_ENABLED"}


def _local(var):
    return "v-" + var.lower().replace("_", "-")


def split_list(stmt):
    """`a && b || c` as [(None, a), ("&&", b), ("||", c)], split outside quotes."""
    masked = _unquoted(stmt)
    parts = []
    last = 0
    op = None
    for m in re.finditer(r"&&|\|\|", masked):
        parts.append((op, stmt[last:m.start()].strip()))
        op = m.group(0)
        last = m.end()
    parts.append((op, stmt[last:].strip()))
    return parts


FAIL = re.compile(r"(return|exit)(\s+\S+)?$|(exit_with|die)\s+(.*)$")


def is_test(segment):
    return segment.startswith(("[[ ", "[ ", "! [[ ", "! [ ", "test "))


GREP_Q = re.compile(r"(.+?)\|\s*grep\s+(-[qsE]+\s+)+(\S+)\s*(?:>\s*/dev/null)?\s*$", re.S)


def grep_found(left, pattern, scope):
    """Fennel that is true when `left | grep -q pattern` would succeed."""
    lw = bashplan.split_words(left.strip())
    if not lw:
        raise Unported("grep pipeline")
    if lw[0] == "echo" and not any(w.startswith("-") for w in lw[1:2]):
        source = concat([word(w, scope) if i == 0 else concat(['" "', word(w, scope)]) for i, w in enumerate(lw[1:])] or ['""'])
    else:
        source = f"(b:capture {argv(lw, scope)}{scope_cwd(scope)})"
    pat = bashplan.expand(pattern, {}) if "$" not in pattern else None
    if pat is None:
        parts = word_parts(pattern, scope)
        lua = concat([fstr(sed_to_lua(t, False)) if k == "lit" else f"(pick-values 1 (: {t} :gsub {LUA_MAGIC} \"%%%0\"))"
                      for k, t in parts if t])
    else:
        lua = fstr(sed_to_lua(pat, False))
    return f"(string.find {source} {lua})"


def statement(text, scope):
    """One simple statement as Fennel forms."""
    stmt = text.strip()
    if not stmt or stmt.startswith("#"):
        return []
    if stmt.startswith("(") and stmt.endswith(")") and not stmt.startswith("(("):
        # A subshell: its cd stays inside it.
        saved = list(scope.cwd)
        try:
            return body_forms(stmt[1:-1], scope)
        finally:
            scope.cwd = saved
    # Redirections.
    heredoc = re.match(r"(cat|tee)[ \t]*(>{1,2})?[ \t]*([^ \t\n<]+)?[ \t]*<<-?[ \t]*(['\"]?)([A-Za-z_]+)\4[ \t]*(>{1,2})?[ \t]*([^ \t\n]+)?[ \t]*\n(.*)\n[ \t]*\5[ \t]*$", stmt, re.S)
    if heredoc:
        op = heredoc.group(2) or heredoc.group(6)
        target = heredoc.group(3) or heredoc.group(7)
        if not op or not target:
            raise Unported("heredoc without a file")
        body = heredoc.group(8) + "\n"
        content = fstr(body) if heredoc.group(4) else concat(_dquoted(body.replace('"', '\\"'), scope))
        dest = path(target, scope)
        if op == ">>":
            return [f"(b:write {dest} (.. (if (b:exists {dest}) (b:read {dest}) \"\") {content}))"]
        return [f"(b:write {dest} {content})"]
    if "<<" in _unquoted(stmt.split("\n", 1)[0]):
        raise Unported("heredoc")
    grep = GREP_Q.fullmatch(stmt)
    if grep and "|" not in _unquoted(grep.group(1)):
        return [f"(when (not {grep_found(grep.group(1), grep.group(3), scope)}) (error {fstr('grep -q ' + grep.group(3) + ' found nothing')}))"]
    parts = split_list(stmt) if re.search(r"&&|\|\|", _unquoted(stmt)) else None
    if parts:
        return list_forms(parts, scope)
    if re.search(r"(?<![<>|&])\|(?!\|)|(?<!\\);", _unquoted(stmt)):
        raise Unported("pipeline or list")
    if re.match(r"[A-Za-z_][A-Za-z0-9_]*\+?=\(", stmt):
        return assignment(stmt, scope, exported=False)
    array_local = re.match(r"(local|declare|readonly|typeset)\s+(?:-\w+\s+)*([A-Za-z_][A-Za-z0-9_]*\+?=\()", stmt)
    if array_local:
        return assignment(stmt[array_local.start(2):], scope, exported=False)
    words = bashplan.split_words(stmt)
    stdin = None
    stdout = None
    append = False
    plain = []
    it = iter(words)
    for w in it:
        if w in (">", ">>", "1>"):
            stdout, append = next(it), w == ">>"
        elif w.startswith((">", ">>")) and len(w.lstrip(">")) > 0 and not w.startswith(">&"):
            append = w.startswith(">>")
            stdout = w.lstrip(">")
        elif w == "<":
            stdin = next(it)
        elif w.startswith("<") and len(w) > 1 and not w.startswith("<<"):
            stdin = w[1:]
        elif w in ("2>&1", ">/dev/null", "2>/dev/null", "&>/dev/null") or w == "/dev/null" and plain and plain[-1] in (">", "2>"):
            continue
        elif w in ("2>", "&>"):
            if next(it) != "/dev/null":
                raise Unported("stderr redirect")
        else:
            plain.append(w)
    words = plain
    if not words:
        return []
    if bashplan.ASSIGN.match(words[0]) and len(words) == 1:
        return assignment(words[0], scope, exported=False)
    cmd = words[0]
    args = words[1:]
    if re.fullmatch(r"mkdir\s+-p\s+/(usr/)?s?bin/?", stmt):
        return []  # Where the studio link went; see use-dependency-path.
    if re.fullmatch(r"(local\s+)?_clean_\w+(=true|=\(\))", stmt):
        return []  # The studio link's bookkeeping; see use-dependency-path.
    if cmd in ("local", "declare", "readonly", "typeset"):
        args = [a for a in args if not a.startswith("-")]
        out = []
        for a in args:
            if bashplan.ASSIGN.match(a):
                out += assignment(a, scope, exported=False)
            elif a not in scope.declared:
                scope.locals[a] = _local(a)
                out.append(f'(var {_local(a)} "")')
        return out
    if cmd == "export":
        out = []
        for a in args:
            if a.startswith("-"):
                raise Unported("export " + a)
            if bashplan.ASSIGN.match(a):
                out += assignment(a, scope, exported=True)
            elif a in scope.locals:
                out.append(f"(b:env {fstr(a)} {scope.locals[a]})")
            # `export NAME` of a variable the build already exports: nothing to do.
        return out
    env = []
    while bashplan.ASSIGN.match(cmd) and args:
        m = bashplan.ASSIGN.match(cmd)
        if m.group(2):
            raise Unported("+= before a command")
        env.append((m.group(1), word(cmd[m.end():], scope) if cmd[m.end():] else '""'))
        cmd, args = args[0], args[1:]
        words = [cmd] + args
    if env:
        if stdout is not None or stdin is not None:
            raise Unported("environment with a redirect")
        if cmd in scope.plan.functions or cmd.startswith(("pkg_", "_", "do_")) or cmd in (
                "cd", "pushd", "popd", "export", "local", "source", ".", "eval", "exec"):
            raise Unported("assignment before " + cmd)
        return [f"(b:run {argv([cmd] + args, scope)}{scope_cwd(scope, env)})"]
    if stdout is not None:
        if stdout == "/dev/null":
            return _command(cmd, args, scope, stdin)
        dest = path(stdout, scope)
        if cmd == "echo":
            content = concat([concat([word(a, scope) for a in _echo_args(args)]), '"\\n"'])
        else:
            content = f"(.. (b:capture {argv(words, scope)}{scope_cwd(scope)}) \"\\n\")"
        if append:
            return [f"(b:write {dest} (.. (if (b:exists {dest}) (b:read {dest}) \"\") {content}))"]
        return [f"(b:write {dest} {content})"]
    return _command(cmd, args, scope, stdin)


def list_forms(parts, scope):
    """Fennel for a list of commands joined by && and ||."""
    ops = [op for op, _ in parts[1:]]
    # a || <fail>: the build already stops when a fails.
    if ops == ["||"] and FAIL.match(parts[1][1]):
        first = parts[0][1]
        if is_test(first):
            fail = FAIL.match(parts[1][1])
            message = word(fail.group(4).split()[0], scope) if fail.group(4) else fstr("a check failed")
            return [f"(when (not {condition(first, scope)}) (error {message}))"]
        return statement(first, scope)
    if all(op == "&&" for op in ops):
        if is_test(parts[0][1]):
            rest = []
            for _, seg in parts[1:]:
                if is_test(seg):
                    raise Unported("test after test")
                rest.extend(statement(seg, scope))
            return [f"(when {condition(parts[0][1], scope)}\n  {' '.join(rest)})"]
        forms = []
        for _, seg in parts:
            if is_test(seg):
                raise Unported("test inside a list")
            forms.extend(statement(seg, scope))
        return forms
    if ops == ["||"] and is_test(parts[0][1]) and not is_test(parts[1][1]):
        return [f"(when (not {condition(parts[0][1], scope)})\n  {' '.join(statement(parts[1][1], scope))})"]
    raise Unported("pipeline or list")


def _echo_args(args):
    if args and args[0] == "-n":
        raise Unported("echo -n")
    out = []
    for i, a in enumerate(args):
        if i:
            out.append('" "')
        out.append(a)
    return out


def _command(cmd, args, scope, stdin):
    if cmd in ("exit", "exit_with", "die"):
        if cmd == "exit" and (not args or args[0] == "0"):
            raise Unported("exit 0 ends the build successfully")
        message = word(args[0], scope) if cmd != "exit" and args else fstr(f"{cmd} {' '.join(args)}".strip())
        return [f"(error {message})"]
    if cmd in ("return", "true", ":"):
        if cmd == "return" and args and args[0] not in ("0",):
            raise Unported("return " + args[0])
        return []
    if cmd in ("build_line", "warn", "info", "debug", "echo") and stdin is None:
        if cmd == "echo" and args and args[0].startswith("-"):
            raise Unported("echo flags")
        return [f"(b:log {concat([word(a, scope) if a not in ('\" \"',) else fstr(' ') for a in _join_words(args)])})"]
    if cmd == "attach":
        return []
    env_helper = {"set_runtime_env": "b:runtime_env", "push_runtime_env": "b:runtime_env_push",
                  "set_buildtime_env": "b:buildtime_env", "push_buildtime_env": "b:buildtime_env_push"}
    if cmd in env_helper:
        rest = [a for a in args if a != "-f"]
        if len(rest) != 2:
            raise Unported(cmd + " arity")
        return [f"({env_helper[cmd]} {word(rest[0], scope)} {word(rest[1], scope)})"]
    if cmd in BUILDER_HELPERS:
        raise Unported("the source project's builder function " + cmd)
    if cmd.startswith("do_default_") and not args:
        phase = cmd[len("do_default_"):]
        if phase not in ORDER:
            raise Unported(cmd)
        if scope.cwd and phase == "build":
            # The default runs in b.src; after a cd it is spelled out where the cd went.
            return [f'(b:run ["./configure" (.. "--prefix=" b.prefix)]{scope_cwd(scope)})',
                    f'(b:run ["make"]{scope_cwd(scope)})']
        if scope.cwd and phase == "install":
            return [f'(b:run ["make" "install"]{scope_cwd(scope)})']
        if scope.cwd and phase in ("check", "unpack"):
            raise Unported(f"{cmd} after cd")
        return [f"(b.default.{phase} b)"]
    if cmd == "pushd":
        if len(args) != 1:
            raise Unported("pushd arity")
        scope.cwd.append(word(args[0], scope))
        return []
    if cmd == "popd":
        if not scope.cwd:
            raise Unported("popd without pushd")
        scope.cwd.pop()
        return []
    if cmd == "cd":
        if len(args) != 1:
            raise Unported("cd arity")
        if scope.cwd:
            scope.cwd[-1] = word(args[0], scope)
        else:
            scope.cwd.append(word(args[0], scope))
        return []
    if stdin is not None and cmd != "patch":
        raise Unported("stdin redirect")
    simple = {"cp": cmd_cp, "rm": cmd_rm, "mkdir": cmd_mkdir, "ln": cmd_ln,
              "chmod": cmd_chmod, "install": cmd_install, "sed": cmd_sed,
              "fix_interpreter": cmd_fix_interpreter, "download_file": cmd_download_file}
    if cmd == "mv":
        return cmd_cp(args, scope, move=True)
    if cmd == "patch":
        return cmd_patch(args, scope, stdin)
    if cmd in simple:
        return simple[cmd](args, scope)
    if cmd in ("source", ".") and len(args) == 1 and args[0].strip('"\'').endswith("bin/activate"):
        # A virtualenv's activate: VIRTUAL_ENV, and its bin first on PATH.
        venv = word(args[0], scope)
        venv = venv[:-len('/bin/activate"')] + '"' if venv.endswith('/bin/activate"') else f'(: {venv} :gsub "/bin/activate$" "")'
        return [f'(b:env "VIRTUAL_ENV" {venv})',
                f'(b:env "PATH" (.. {venv} "/bin:" (or (b:getenv "PATH") "")))']
    if cmd in ("sh", "bash") and args and not args[0].startswith("-"):
        # The package's own script, as ./configure is; a plan's code is never shell.
        return [f"(b:run {argv([cmd] + args, scope)}{scope_cwd(scope)})"]
    if cmd in ("bash", "sh", "eval", "source", "."):
        raise Unported(cmd)
    if cmd.startswith(("pkg_", "_")) or cmd in scope.plan.functions:
        return [f"({_local(cmd)} b {' '.join(word(a, scope) for a in args)})".replace(" )", ")")]
    for a in args:
        # A glob character in a package spec (name:version, name@version, key=value) is literal.
        if GLOB.search(_unquoted(a)) and not re.search(r"[:@=]", _unquoted(a)):
            raise Unported("glob argument to " + cmd)
    return [f"(b:run {argv([cmd] + args, scope)}{scope_cwd(scope)})"]


def _join_words(args):
    out = []
    for i, a in enumerate(args):
        if i:
            out.append('" "')
        out.append(a)
    return out


def _absolute_word(w):
    u = w.lstrip("\"'")
    return u.startswith(("/", "$pkg_prefix", "${pkg_prefix}", "$PLAN_CONTEXT", "${PLAN_CONTEXT}",
                         "$HAB_CACHE_SRC_PATH", "${HAB_CACHE_SRC_PATH}", "$(pkg_path_for", "$pkg_svc", "${pkg_svc"))


CONDITION = re.compile(r"\[\[?\s+(.*?)\s+\]\]?$")


def condition(text, scope):
    t = text.strip()
    negate = False
    if t.startswith("! "):
        negate, t = True, t[2:].strip()
    grep = GREP_Q.fullmatch(t)
    if grep and "|" not in _unquoted(grep.group(1)):
        expr = grep_found(grep.group(1), grep.group(3), scope)
        return f"(not {expr})" if negate else expr
    m = CONDITION.fullmatch(t)
    if not m:
        raise Unported("condition " + t)
    words = bashplan.split_words(m.group(1))
    if words and words[0] == "!":
        negate = not negate
        words = words[1:]
    if len(words) == 2 and words[0] in ("-f", "-e", "-d", "-L", "-x", "-s", "-r", "-h"):
        expr = f"(b:exists {path(words[1], scope)})"
    elif len(words) == 2 and words[0] in ("-z", "-n"):
        v = word(words[1], scope)
        expr = f'(= {v} "")' if words[0] == "-z" else f'(not= {v} "")'
    elif len(words) == 3 and words[1] in ("=", "==", "!="):
        expr = f"({'=' if words[1] != '!=' else 'not='} {word(words[0], scope)} {word(words[2], scope)})"
    else:
        raise Unported("condition " + t)
    return f"(not {expr})" if negate else expr


# The old studio's workaround: link a dependency's tool where the build's
# scripts look for it, and remove the link at the end. Dojo's build writes
# nothing outside itself, so the scripts are pointed at the dependency instead.
STUDIO_LINK = re.compile(
    r'if\s+\[\[?\s+!\s+-[rex]\s+(/(?:usr/)?(?:s?bin)/[\w.+-]+)\s+\]\]?\s*;?\s*then\s+'
    r'ln\s+-s[vf]*\s+"\$\(pkg_path_for\s+([\w/.-]+)\)/((?:s?bin)/[\w.+-]+)"\s+\1\s*'
    r'(?:_clean_\w+=true|_clean_cmds\+=\(\1\))?\s*fi$', re.S)
STUDIO_UNLINK = re.compile(
    r'(if\s+\[\[?\s+-n\s+"\$_clean_\w+"\s+\]\]?\s*;?\s*then\s+rm\s+-f?v?f?\s+/\S+\s*fi'
    r'|for\s+cmd\s+in\s+"\$\{_clean_cmds\[@\]\}"\s*;?\s*do\s+rm\s+-fv\s+"\$cmd"\s*;?\s*done)$', re.S)

STUDIO_UNLINK_EXISTS = re.compile(
    r'if\s+\[\[?\s+-[er]\s+(/(?:usr/)?(?:s?bin)/[\w.+-]+)\s+\]\]?\s*;?\s*then\s+rm\s+-f?v?f?\s+\1\s*fi$', re.S)

USE_DEPENDENCY_PATH = """(fn use-dependency-path [b path replacement]
  ;; The source project's studio linked a dependency's tool to `path` for the
  ;; build. A Dojo build writes nothing outside itself, so the build's scripts
  ;; name the dependency's tool instead.
  (each [_ f (ipairs (b:find b.src "*"))]
    (let [name (: f :match "[^/]+$")]
      (when (and (or (: name :match "^configure") (: name :match "^Makefile") (: name :match "^ltmain")
                     (: name :match "%.in$") (: name :match "%.am$") (: name :match "%.ac$")
                     (: name :match "%.m4$") (: name :match "%.mk$") (: name :match "%.sh$")
                     (: name :match "%.pl$") (: name :match "%.py$"))
                 (not (b:exists (b:join f "."))))
        (let [text (b:read f)
              escaped (pick-values 1 (: path :gsub "[%^%$%(%)%%%.%[%]%*%+%-%?]" "%%%0"))
              (fixed n) (: text :gsub escaped (pick-values 1 (: replacement :gsub "%%" "%%%%")))]
          (when (> n 0) (b:write f fixed)))))))"""


def block(text, scope):
    t = text.strip()
    link = STUDIO_LINK.match(t)
    if link:
        scope.plan.helpers.add("use-dependency-path")
        return [f'(use-dependency-path b {fstr(link.group(1))} (b:path_for {_dep(link.group(2), scope)} {fstr(link.group(3))}))']
    if STUDIO_UNLINK.match(t) or STUDIO_UNLINK_EXISTS.match(t):
        return []
    m = re.match(r"if\s+(.*?)\s*;?\s*then\b(.*)\bfi$", t, re.S)
    if m and not re.search(r"\b(elif|if)\b", m.group(2)):
        cond = condition(m.group(1), scope)
        body = m.group(2)
        parts = re.split(r"\belse\b", body)
        if len(parts) > 2:
            raise Unported("if")
        then = body_forms(parts[0], scope)
        other = body_forms(parts[1], scope) if len(parts) == 2 else []
        if other:
            return [f"(if {cond}\n  (do {' '.join(then) or 'nil'})\n  (do {' '.join(other)}))"]
        return [f"(when {cond}\n  {' '.join(then)})"]
    m = re.match(r"for\s+([A-Za-z_][A-Za-z0-9_]*)\s+in\s+(.*?)\s*;?\s*do\b(.*)\bdone$", t, re.S)
    if m:
        var = m.group(1)
        items_text = m.group(2)
        name = _local(var)
        saved = scope.locals.get(var)
        scope.locals[var] = name
        try:
            body = body_forms(m.group(3), scope)
        finally:
            if saved is None:
                scope.locals.pop(var, None)
            else:
                scope.locals[var] = saved
        words = bashplan.split_words(items_text)
        if len(words) == 1 and GLOB.search(_unquoted(words[0])):
            kind, expr = paths(words[0], scope)
            if "/" not in _unquoted(words[0]):
                # A relative glob gives names, not paths.
                return [f'(each [_ p (ipairs {expr})]\n  (let [{name} (: p :match "[^/]+$")]\n    {" ".join(body)}))']
            return [f"(each [_ {name} (ipairs {expr})]\n  {' '.join(body)})"]
        whole = re.fullmatch(r'"?\$\{([A-Za-z_][A-Za-z0-9_]*)\[[@*]\]\}"?', words[0]) if len(words) == 1 else None
        if whole:
            arr = whole.group(1)
            arr_expr = scope.locals.get(arr) or (
                "[" + " ".join(fstr(v) for v in scope.plan.arrays.get(arr, [])) + "]" if arr in scope.plan.arrays else None)
            if arr_expr is None:
                raise Unported("for over " + arr)
            return [f"(each [_ {name} (ipairs {arr_expr})]\n  {' '.join(body)})"]
        if any(GLOB.search(_unquoted(w)) or w.startswith("$(") for w in words):
            raise Unported("for over a glob or command")
        items = "[" + " ".join(word(w, scope) for w in words) + "]"
        return [f"(each [_ {name} (ipairs {items})]\n  {' '.join(body)})"]
    raise Unported(t.split(None, 1)[0])


def body_forms(text, scope):
    forms = []
    for kind, _, body in bashplan.statements(text):
        if kind == "function":
            raise Unported("nested function")
        if kind == "block":
            forms.extend(block(body, scope))
        else:
            forms.extend(statement(body, scope))
    return forms


def translate_function(name, body, plan, scope_name, shared=(), params=0):
    """A callback's body as Fennel forms, or the bash it could not translate."""
    scope = Scope(plan, scope_name, shared, params)
    forms = []
    # Every variable the function assigns is declared at its top, so one set
    # inside an if or a loop is still there after it, as in bash.
    for var in sorted((set(ASSIGNED.findall(body)) | set(LOCAL.findall(body))) - set(shared)):
        if (var in scope.locals or re.fullmatch(r"[A-Z][A-Z0-9_]*", var) or var.startswith("pkg_")
                or var.startswith("_clean_")):
            continue
        scope.locals[var] = _local(var)
        scope.declared.add(var)
        forms.append(f'(var {_local(var)} "")')
    unported = []
    statements = bashplan.statements(body)
    if statements and statements[-1][0] == "simple" and re.fullmatch(r"return(\s+(\$\?|\$\w+|\d+))?", statements[-1][2].strip()):
        last = statements[-1][2].strip()
        if last in ("return", "return 0", "return $?") or re.fullmatch(r"return \$\w+", last):
            statements = statements[:-1]
    for kind, _, stmt in statements:
        try:
            if scope.lost_cwd:
                raise Unported("after a cd or pushd that is not ported")
            if kind == "block":
                forms.extend(block(stmt, scope))
            elif kind == "function":
                raise Unported("nested function")
            else:
                forms.extend(statement(stmt, scope))
        except (Unported, ValueError, IndexError, StopIteration, bashplan.Unresolved) as e:
            if re.match(r"\s*(pushd|cd|popd)\b", stmt) or re.search(r"\b(pushd|cd)\b", stmt.split("\n")[0]):
                scope.lost_cwd = True
            unported.append((str(e), stmt.strip()))
            forms.append(";; UNPORTED (" + str(e).replace("\n", " ")[:60] + "):\n" +
                         "\n".join(";;   " + line for line in stmt.strip().splitlines()))
    return forms, unported


def indent(forms, by):
    pad = " " * by
    out = []
    for f in forms:
        out.append("\n".join(pad + line for line in f.splitlines()))
    return "\n".join(out)


ASSIGNED = re.compile(r"^\s*(?:export\s+)?([A-Za-z_][A-Za-z0-9_]*)\+?=", re.M)
LOCAL = re.compile(r"^\s*(?:local|declare)\s+(?:-\w+\s+)*([A-Za-z_][A-Za-z0-9_]*)", re.M)


def shared_variables(plan, functions):
    """Lowercase variables one function assigns without `local` and another reads."""
    assigned = {}
    for fn in functions:
        body = plan.functions[fn]
        local = set(LOCAL.findall(body))
        for var in ASSIGNED.findall(body):
            if (var not in local and not re.fullmatch(r"[A-Z][A-Z0-9_]*", var) and not var.startswith("pkg_")
                    and not var.startswith("_clean_")):
                assigned.setdefault(var, set()).add(fn)
    shared = set()
    for var, setters in assigned.items():
        pattern = re.compile(r"\$\{?" + re.escape(var) + r"\b")
        if any(pattern.search(plan.functions[fn]) for fn in functions if fn not in setters):
            shared.add(var)
    return sorted(shared)


def params_of(body):
    found = [int(n) for n in re.findall(r"\$\{?([1-9])\b", body)]
    return max(found, default=0)


def phase_text(forms):
    text = indent(forms, 10) if forms else "          nil"
    close = "\n          )" if forms and forms[-1].lstrip().startswith(";;") else ")"
    return text + close


def callbacks(plan, emitter):
    """The plan's phases as Fennel key-value lines, and the definitions before the plan."""
    name = plan.scalars.get("pkg_name", emitter.name)
    functions = [fn for fn in plan.functions if not fn.startswith("do_default")]
    shared = shared_variables(plan, functions)
    phases = {}
    for fn, phase in PHASE_OF.items():
        if fn in plan.functions:
            phases.setdefault(phase, {})["own"] = fn
    for fn, phase in FOLDED.items():
        if fn in plan.functions:
            where = "before" if phase in ("download", "prepare") else "after"
            phases.setdefault(phase, {}).setdefault(where, []).append(fn)
    dropped_clean = "do_clean" in plan.functions

    def translated(fn, params=0):
        f, unported = translate_function(fn, plan.functions[fn], plan, name, shared, params)
        for why, _ in unported:
            emitter.problems.append(f"{fn}: {why}")
        return f

    lines = []
    for phase in ORDER:
        entry = phases.get(phase)
        if not entry:
            continue
        forms = []
        for fn in entry.get("before", []):
            forms += [f";; From {fn}."] + translated(fn)
        if "own" in entry:
            forms += translated(entry["own"])
        else:
            forms.append(f"(b.default.{phase} b)")
        for fn in entry.get("after", []):
            forms += [f";; From {fn}."] + translated(fn)
        lines.append(f":{phase} (fn [b]\n{phase_text(forms)}")

    before_plan = [f'(var {_local(v)} "")' for v in shared]
    if dropped_clean:
        before_plan.insert(0, ";; The plan's do_clean is not ported: a build empties its source directory before\n"
                              ";; unpacking and starts with no state from an earlier one.")
    for fn in functions:
        if fn in PHASE_OF or fn in FOLDED or fn == "do_clean":
            continue
        if fn == "pkg_version":
            # A version function returns what it echoes; that is ported by hand.
            emitter.problems.append("pkg_version is a function")
            body = "\n".join(";;   " + line for line in plan.functions[fn].strip().splitlines())
            lines.insert(0, f";; UNPORTED (version function):\n{body}")
            continue
        params = params_of(plan.functions[fn])
        f = translated(fn, params)
        args = " ".join(["b"] + [f"a{i}" for i in range(1, params + 1)])
        close = "\n  )" if f and f[-1].lstrip().startswith(";;") else ")"
        before_plan.append(f"(fn {_local(fn)} [{args}]\n{indent(f, 2) if f else '  nil'}{close}")
    if "use-dependency-path" in plan.helpers:
        before_plan.insert(0, USE_DEPENDENCY_PATH)
    return lines, before_plan
