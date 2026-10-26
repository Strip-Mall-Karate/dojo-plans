"""Reads a plan.sh without running it.

A plan is assignments, functions and the odd top-level block. This module
splits a plan into those statements and expands the words in them the way
bash would, for the parameter expansions plans use. Nothing a plan says is
executed: a command substitution other than a `cat` heredoc is left as an
Unresolved marker for the caller to report.
"""

import re
from dataclasses import dataclass, field

NAME = re.compile(r"[A-Za-z_][A-Za-z0-9_]*")


class Unresolved(Exception):
    """A word that cannot be expanded without running code."""


@dataclass
class Plan:
    scalars: dict = field(default_factory=dict)
    arrays: dict = field(default_factory=dict)
    assocs: dict = field(default_factory=dict)
    functions: dict = field(default_factory=dict)
    # Top-level statements this module could not read, as text.
    unread: list = field(default_factory=list)
    # Assignments whose value needs code run to know, by name.
    unresolved: dict = field(default_factory=dict)
    # The order names were first assigned, for helpers that feed others.
    order: list = field(default_factory=list)
    # The plans this one sourced, by directory name, in order.
    sourced: list = field(default_factory=list)
    # Helpers the Fennel port of this plan needs, by name (translate.py).
    helpers: set = field(default_factory=set)
    # The plan's directory, and data files a callback sourced from it (translate.py).
    dir: str = ""
    data_files: list = field(default_factory=list)


# ---------------------------------------------------------------- splitting


def _skip_quoted(text, i):
    """The index after the quoted string or substitution starting at i."""
    c = text[i]
    if c == "'":
        j = text.index("'", i + 1)
        return j + 1
    if c == '"':
        j = i + 1
        while text[j] != '"':
            if text[j] == "\\":
                j += 2
                continue
            if text[j] == "$" and j + 1 < len(text) and text[j + 1] in "({":
                j = _skip_quoted(text, j)
                continue
            if text[j] == "`":
                j = text.index("`", j + 1) + 1
                continue
            j += 1
        return j + 1
    if c == "$" and text.startswith("$'", i):
        j = i + 2
        while text[j] != "'":
            j += 2 if text[j] == "\\" else 1
        return j + 1
    if c == "$" and text.startswith("$(", i):
        return _skip_balanced(text, i + 1, "(", ")")
    if c == "$" and text.startswith("${", i):
        return _skip_balanced(text, i + 1, "{", "}")
    if c == "`":
        return text.index("`", i + 1) + 1
    raise ValueError(f"not a quote at {i}")


def _skip_balanced(text, i, open_, close):
    """The index after the bracket closing the one at i, skipping quotes and heredocs."""
    depth = 0
    j = i
    while j < len(text):
        c = text[j]
        if c in "'\"`" or (c == "$" and j + 1 < len(text) and text[j + 1] in "('{"):
            if c == "$" and text[j + 1] == open_ and j != i - 1:
                j = _skip_quoted(text, j)
                continue
            if c != "$" or text[j + 1] in "('{":
                j = _skip_quoted(text, j)
                continue
        if c == "\\":
            j += 2
            continue
        if c == "#" and j > 0 and text[j - 1] in " \t\n;":
            nl = text.find("\n", j)
            j = len(text) if nl < 0 else nl
            continue
        if text.startswith("<<", j) and not text.startswith("<<<", j):
            j = _skip_heredoc(text, j)
            continue
        if c == open_:
            depth += 1
        elif c == close:
            depth -= 1
            if depth == 0:
                return j + 1
        j += 1
    raise ValueError("unbalanced")


HEREDOC = re.compile(r"<<-?\s*(['\"]?)([A-Za-z_][A-Za-z0-9_]*)\1")


def _skip_heredoc(text, i):
    """From `<<WORD` at i, the index after the heredoc's terminating line."""
    m = HEREDOC.match(text, i)
    if not m:
        return i + 2
    word = m.group(2)
    line_end = text.find("\n", m.end())
    if line_end < 0:
        return len(text)
    end = re.compile(r"^\s*" + re.escape(word) + r"\s*$", re.M).search(text, line_end + 1)
    if not end:
        raise ValueError(f"heredoc {word} is not closed")
    # Resume at the end of the line that opened it, then past the body.
    return end.end()


def statements(text):
    """Top-level statements of a plan, each as its source text."""
    out = []
    i = 0
    n = len(text)
    while i < n:
        # Skip blank space and comments between statements.
        while i < n and text[i] in " \t\n;":
            i += 1
        if i >= n:
            break
        if text[i] == "#":
            i = text.find("\n", i)
            i = n if i < 0 else i
            continue
        start = i
        fm = re.match(r"(function\s+)?([A-Za-z_][A-Za-z0-9_-]*)\s*\(\s*\)\s*", text[i:])
        if fm:
            j = i + fm.end()
            while j < n and text[j] in " \t\n":
                j += 1
            if j < n and text[j] == "{":
                end = _skip_balanced(text, j, "{", "}")
                out.append(("function", fm.group(2), text[j + 1:end - 1]))
                i = end
                continue
        kw = re.match(r"(if|for|while|until|case)\b", text[i:])
        if kw:
            closer = {"if": "fi", "for": "done", "while": "done", "until": "done", "case": "esac"}[kw.group(1)]
            end = _block_end(text, i, kw.group(1), closer)
            out.append(("block", kw.group(1), text[start:end]))
            i = end
            continue
        end = _statement_end(text, i)
        # A loop or if after a pipe (`find ... | while read f; do ... done`) is
        # part of this statement: it runs to its done, fi or esac.
        while end < n and _unbalanced(text[start:end]):
            end = _statement_end(text, end + 1)
        out.append(("simple", None, text[start:end]))
        i = end
    return out


def _block_end(text, i, opener, closer):
    openers = {"if": r"\bif\b", "for": r"\b(for|while|until)\b", "while": r"\b(for|while|until)\b",
               "until": r"\b(for|while|until)\b", "case": r"\bcase\b"}[opener]
    depth = 0
    j = i
    n = len(text)
    while j < n:
        c = text[j]
        if c in "'\"`" or text.startswith("$(", j) or text.startswith("${", j) or text.startswith("$'", j):
            j = _skip_quoted(text, j)
            continue
        if c == "\\":
            j += 2
            continue
        if c == "#" and (j == 0 or text[j - 1] in " \t\n;"):
            j = text.find("\n", j)
            j = n if j < 0 else j
            continue
        if text.startswith("<<", j) and not text.startswith("<<<", j):
            j = _skip_heredoc(text, j)
            continue
        if (j == 0 or not (text[j - 1].isalnum() or text[j - 1] == "_")):
            if re.match(openers, text[j:]) and (j + 1 >= n or True):
                m = re.match(openers, text[j:])
                depth += 1
                j += m.end()
                continue
            if re.match(r"\b" + closer + r"\b", text[j:]):
                depth -= 1
                j += len(closer)
                if depth == 0:
                    return j
                continue
        j += 1
    raise ValueError(f"{opener} block is not closed")


def _masked(text):
    """`text` with quoted strings, substitutions and comments blanked out."""
    out = []
    i = 0
    n = len(text)
    while i < n:
        c = text[i]
        if c in "'\"`" or text.startswith("$(", i) or text.startswith("${", i) or text.startswith("$'", i):
            try:
                j = _skip_quoted(text, i)
            except (ValueError, IndexError):
                j = n
            out.append(" " * (j - i))
            i = j
        elif c == "#" and (i == 0 or text[i - 1] in " \t\n;"):
            j = text.find("\n", i)
            j = n if j < 0 else j
            out.append(" " * (j - i))
            i = j
        else:
            out.append(c)
            i += 1
    return "".join(out)


def _unbalanced(statement):
    """Whether a statement opens a do, then or case it does not close."""
    words = re.findall(r"(?<![\w-])(while|until|for|select|done|if|fi|case|esac)(?![\w-])", _masked(statement))
    depth = {"loop": 0, "if": 0, "case": 0}
    for w in words:
        if w in ("while", "until", "for", "select"):
            depth["loop"] += 1
        elif w in ("if", "case"):
            depth[w] += 1
        else:
            depth[{"done": "loop", "fi": "if", "esac": "case"}[w]] -= 1
    return any(v > 0 for v in depth.values())


def _statement_end(text, i):
    """The end of the simple statement at i: an unquoted newline or `;`."""
    j = i
    n = len(text)
    while j < n:
        c = text[j]
        if c in "'\"`" or text.startswith("$(", j) or text.startswith("${", j) or text.startswith("$'", j):
            j = _skip_quoted(text, j)
            continue
        if c == "\\" and j + 1 < n:
            j += 2
            continue
        if c == "(":
            j = _skip_balanced(text, j, "(", ")")
            continue
        if text.startswith("<<", j) and not text.startswith("<<<", j):
            j = _skip_heredoc(text, j)
            continue
        if c == "#" and (j == i or text[j - 1] in " \t"):
            nl = text.find("\n", j)
            return n if nl < 0 else nl
        if c in "\n;":
            return j
        j += 1
    return n


# ---------------------------------------------------------------- words


def split_words(text):
    """Splits a command or array body into words, keeping each word's quoting."""
    words = []
    i = 0
    n = len(text)
    while i < n:
        while i < n and text[i] in " \t\n":
            i += 1
        if i >= n:
            break
        if text[i] == "\\" and i + 1 < n and text[i + 1] == "\n":
            i += 2
            continue
        if text[i] == "#":
            nl = text.find("\n", i)
            i = n if nl < 0 else nl
            continue
        start = i
        while i < n and text[i] not in " \t\n":
            c = text[i]
            if c in "'\"`" or text.startswith("$(", i) or text.startswith("${", i) or text.startswith("$'", i):
                i = _skip_quoted(text, i)
            elif c == "\\":
                i += 2
            else:
                i += 1
        words.append(text[start:i])
    return words


CAT_HEREDOC = re.compile(r"\$\(\s*cat\s*<<-?\s*(['\"]?)([A-Za-z_]+)\1\s*\n(.*?)\n\s*\2\s*\n?\s*\)", re.S)


def expand(word, env):
    """The value of a bash word, expanding the parameters plans use."""
    out = []
    i = 0
    n = len(word)
    while i < n:
        c = word[i]
        if c == "'":
            j = word.index("'", i + 1)
            out.append(word[i + 1:j])
            i = j + 1
        elif c == '"':
            j = _skip_quoted(word, i)
            out.append(_expand_dquoted(word[i + 1:j - 1], env))
            i = j
        elif word.startswith("$'", i):
            j = _skip_quoted(word, i)
            out.append(bytes(word[i + 2:j - 1], "utf-8").decode("unicode_escape"))
            i = j
        elif c == "\\" and i + 1 < n:
            if word[i + 1] != "\n":
                out.append(word[i + 1])
            i += 2
        elif c == "$":
            value, i = _parameter(word, i, env)
            out.append(value)
        elif c == "`":
            raise Unresolved(word)
        else:
            out.append(c)
            i += 1
    return "".join(out)


def _expand_dquoted(body, env):
    out = []
    i = 0
    n = len(body)
    while i < n:
        c = body[i]
        if c == "\\" and i + 1 < n:
            nxt = body[i + 1]
            if nxt in '$`"\\':
                out.append(nxt)
            elif nxt == "\n":
                pass
            else:
                out.append(c + nxt)
            i += 2
        elif c == "$":
            value, i = _parameter(body, i, env)
            out.append(value)
        elif c == "`":
            raise Unresolved(body)
        else:
            out.append(c)
            i += 1
    return "".join(out)


def _parameter(text, i, env):
    """Expands the parameter or substitution starting at text[i] == '$'."""
    if text.startswith("$(", i):
        j = _skip_balanced(text, i + 1, "(", ")")
        m = CAT_HEREDOC.fullmatch(text[i:j])
        if m:
            body = m.group(3)
            return (body if m.group(1) else _expand_dquoted(body, env)), j
        return _text_pipeline(text[i + 2:j - 1].strip(), env, text[i:j]), j
    if text.startswith("${", i):
        j = _skip_balanced(text, i + 1, "{", "}")
        return _braced(text[i + 2:j - 1], env), j
    m = NAME.match(text, i + 1)
    if m:
        return _lookup(m.group(0), env), m.end()
    if i + 1 < len(text) and text[i + 1] in "0123456789@*#?$!":
        raise Unresolved(text[i:i + 2])
    return "$", i + 1


TEXT_SOURCE = re.compile(r"""(?:printf\s+(?:"%s"\s+|'%s'\s+)?|echo\s+)("[^"]*"|\S+)\s*\|\s*(.+)""", re.S)


def _text_pipeline(command, env, whole):
    """A text-only pipeline of echo or printf into tr or cut, worked out without running it."""
    m = TEXT_SOURCE.fullmatch(command)
    if not m:
        raise Unresolved(whole)
    value = expand(m.group(1), env)
    for stage in m.group(2).split("|"):
        words = split_words(stage.strip())
        if len(words) == 3 and words[0] == "tr":
            a, b = expand(words[1], env), expand(words[2], env)
            if len(a) != len(b):
                raise Unresolved(whole)
            value = value.translate(str.maketrans(a, b))
            continue
        cut = re.fullmatch(r"cut\s+-d\s*(?:'(.)'|\"(.)\"|(.))\s+-f\s*(\d+)(?:-(\d+))?", stage.strip())
        if cut:
            delim = cut.group(1) or cut.group(2) or cut.group(3)
            lo, hi = int(cut.group(4)), int(cut.group(5) or cut.group(4))
            value = delim.join(value.split(delim)[lo - 1:hi])
            continue
        raise Unresolved(whole)
    return value


def _lookup(name, env):
    if name not in env:
        raise Unresolved("$" + name)
    value = env[name]
    if isinstance(value, list):
        return value[0] if value else ""
    return value


def _glob_to_re(pattern, greedy):
    out = []
    for c in pattern:
        if c == "*":
            out.append(".*" if greedy else ".*?")
        elif c == "?":
            out.append(".")
        else:
            out.append(re.escape(c))
    return "".join(out)


def _braced(inner, env):
    if inner.startswith("#") and NAME.fullmatch(inner[1:]):
        value = env.get(inner[1:])
        if value is None:
            raise Unresolved("${" + inner + "}")
        return str(len(value))
    m = NAME.match(inner)
    if not m:
        raise Unresolved("${" + inner + "}")
    name = m.group(0)
    rest = inner[m.end():]
    if rest.startswith("[") and rest.endswith("]"):
        index = rest[1:-1]
        value = env.get(name)
        if not isinstance(value, list):
            raise Unresolved("${" + inner + "}")
        if index in ("@", "*"):
            return " ".join(value)
        return value[int(index)] if index.isdigit() and int(index) < len(value) else ""
    if rest.startswith(":-") or rest.startswith("-"):
        default = rest[2:] if rest.startswith(":-") else rest[1:]
        value = env.get(name)
        if value in (None, "") if rest.startswith(":-") else value is None:
            return expand(default, env)
        return _lookup(name, env)
    value = _lookup(name, env)
    if rest == "":
        return value
    for op, greedy, suffix in (("%%", True, True), ("%", False, True), ("##", True, False), ("#", False, False)):
        if rest.startswith(op):
            pat = _glob_to_re(expand(rest[len(op):], env), greedy)
            if suffix:
                # Shortest or longest match anchored at the end.
                best = None
                for k in range(len(value) + 1):
                    if re.fullmatch(pat, value[k:], re.S):
                        if greedy:
                            return value[:k]
                        best = k
                return value if best is None else value[:best]
            for k in (range(len(value), -1, -1) if greedy else range(len(value) + 1)):
                if re.fullmatch(pat, value[:k], re.S):
                    return value[k:]
            return value
    if rest.startswith("//") or rest.startswith("/"):
        every = rest.startswith("//")
        body = rest[2:] if every else rest[1:]
        parts = body.split("/", 1)
        find = expand(parts[0], env)
        repl = expand(parts[1], env) if len(parts) > 1 else ""
        pat = _glob_to_re(find, True)
        return re.sub(pat, lambda _: repl, value, count=0 if every else 1)
    if rest.startswith(":"):
        m2 = re.fullmatch(r":\s*(-?\d+)(?::\s*(\d+))?", rest)
        if m2:
            off = int(m2.group(1))
            if m2.group(2) is None:
                return value[off:]
            return value[off:off + int(m2.group(2))]
    if rest == ",,":
        return value.lower()
    if rest == "^^":
        return value.upper()
    raise Unresolved("${" + inner + "}")


# ---------------------------------------------------------------- reading


ASSIGN = re.compile(r"([A-Za-z_][A-Za-z0-9_]*)(\+?)=")


SOURCE = re.compile(r"(?:source|\.)\s+(.+)")
OWN_DIR = re.compile(r'\$\(\s*dirname\s+"?\$\{?BASH_SOURCE(\[0\])?\}?"?\s*\)')


def read(text, env, plan_dir=None, plan=None):
    """Reads a plan's top level with `env` as the variables already known.

    `plan_dir` is the plan's directory, for a plan that sources another;
    the other plan's statements are read into the same Plan, as bash would.
    """
    plan = plan if plan is not None else Plan()
    env = dict(env)
    _read_into(plan, text, env, plan_dir)
    return plan


def _read_into(plan, text, env, plan_dir):
    import os

    for kind, name, body in statements(text):
        if kind == "function":
            plan.functions[name] = body
            continue
        if kind == "block":
            if "STUDIO_TYPE" in body.split("\n", 1)[0]:
                continue  # The stage1 Studio's bootstrap; Dojo's stage 0 is nixpkgs.
            plan.unread.append(body)
            continue
        stmt = body.strip()
        if stmt.startswith("export -f ") or stmt.startswith("set ") or stmt.startswith("shopt "):
            continue
        if stmt.startswith("unset "):
            words = stmt.split()[1:]
            functions = words[:1] == ["-f"]
            for w in words[1:] if functions or words[:1] == ["-v"] else words:
                if functions:
                    plan.functions.pop(w, None)
                else:
                    for table in (plan.scalars, plan.arrays, plan.assocs):
                        table.pop(w, None)
                    env.pop(w, None)
            continue
        sm = SOURCE.fullmatch(stmt)
        if sm and plan_dir is not None:
            target_text = OWN_DIR.sub(plan_dir.replace("\\", "/"), sm.group(1).strip())
            try:
                target = expand(split_words(target_text)[0], {**env, "PLANDIR": plan_dir})
            except Unresolved:
                plan.unread.append(body)
                continue
            path = os.path.normpath(os.path.join(plan_dir, target))
            if not os.path.isfile(path):
                plan.unread.append(body)
                continue
            plan.sourced.append(os.path.basename(os.path.dirname(path)))
            with open(path, encoding="utf-8") as f:
                _read_into(plan, f.read(), env, os.path.dirname(path))
            continue
        for prefix in ("export ", "readonly ", "declare -A ", "declare -a ", "declare -g ", "local "):
            if stmt.startswith(prefix):
                stmt = stmt[len(prefix):]
        m = ASSIGN.match(stmt)
        if not m:
            plan.unread.append(body)
            continue
        var, append = m.group(1), m.group(2) == "+"
        value_text = stmt[m.end():]
        if var not in plan.order:
            plan.order.append(var)
        try:
            if value_text.startswith("("):
                inner = value_text[1:_skip_balanced(value_text, 0, "(", ")") - 1]
                words = split_words(inner)
                if words and all(re.match(r"\[[^]]+\]=", w) for w in words):
                    assoc = {} if not append else dict(plan.assocs.get(var, {}))
                    for w in words:
                        key, val = w[1:].split("]=", 1)
                        assoc[expand(key, env)] = expand(val, env)
                    plan.assocs[var] = assoc
                    env[var] = assoc
                else:
                    items = []
                    for w in words:
                        whole = re.fullmatch(r'"?\$\{([A-Za-z_][A-Za-z0-9_]*)\[[@*]\]\}"?', w)
                        if whole:
                            value = env.get(whole.group(1), [])
                            items.extend(value if isinstance(value, list) else value.split())
                        elif "'" not in w and '"' not in w and "$" in w:
                            items.extend(expand(w, env).split())
                        else:
                            items.append(expand(w, env))
                    if append:
                        items = list(plan.arrays.get(var, [])) + items
                    plan.arrays[var] = items
                    env[var] = items
            else:
                words = split_words(value_text)
                value = expand(words[0], env) if words else ""
                if append:
                    value = plan.scalars.get(var, "") + value
                plan.scalars[var] = value
                env[var] = value
                plan.unresolved.pop(var, None)
        except Unresolved as e:
            plan.unresolved[var] = str(e)
            env.pop(var, None)
