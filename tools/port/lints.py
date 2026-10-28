"""Rewrites a plan so fennel-ls's lints pass, from fennel-ls's own report.

    python3 tools/port/lints.py <plan.fnl>...

port.py runs this on every plan it writes; run it by hand on a plan written by hand. Each rewrite
keeps what the plan does:

- `(: x :method ...)` is `(x:method ...)`, for a symbol `x`.
- A `..` nested in another `..` is spliced into it, and `(do x)` is `x`.
- A `var` never `set` is a `local`.
- A variable no code reads is removed, with every `set` of it, when each value it is given is pure (a
  literal, a symbol, or a `..` or vector of those): the translator declares every variable a bash function
  assigns, also those it ported as an argument or `b:env`, and keeps an assignment only the bash
  read, as `code=$?` before a `return $code`. A `set` that ended a function's body leaves `nil`
  there, unless the function is a phase, whose value doj-plan-build drops.
- A function parameter or loop binding no code reads takes a leading `_`, and an unread `let`
  binding to a pure value is removed (a `let` left with none is a `do`).

Any other unused definition is printed and left: a variable the bash set and the Fennel never reads
may be a porting mistake, so a person reads each before renaming or removing it. The exit status is
1 when one is left.
"""

import os
import re
import subprocess
import sys
import tempfile

WARNING = re.compile(r"^.*?:(\d+):(\d+): warning: (.*)$")
SYMBOL = re.compile(rb"[^\s()\[\]{}\"';,@`~]+")
# A value removing whose binding cannot change what the plan does.
LITERAL = re.compile(rb'(?:"(?:[^"\\]|\\.)*"|-?\d+(?:\.\d+)?|nil|true|false|\[\]|\{\}|:[^\s()\[\]{}"]+)')
OPENS = {ord("("): ord(")"), ord("["): ord("]"), ord("{"): ord("}")}


def report(text):
    """fennel-ls's warnings for `text` as (byte offset, message), with every lint on."""
    with tempfile.TemporaryDirectory() as tmp:
        with open(os.path.join(tmp, "flsproject.fnl"), "w", encoding="utf-8") as f:
            f.write("{:lints {}}\n")
        with open(os.path.join(tmp, "plan.fnl"), "wb") as f:
            f.write(text)
        # fennel-ls exits 1 when it warns; a line it prints that is not a warning is the failure.
        result = subprocess.run(["fennel-ls", "--lint", "plan.fnl"], cwd=tmp, capture_output=True, text=True,
                                check=False)
    starts = [0] + [m.end() for m in re.finditer(rb"\n", text)]
    found = []
    for line in result.stdout.splitlines():
        m = WARNING.match(line)
        if m:
            found.append((starts[int(m.group(1)) - 1] + int(m.group(2)), m.group(3)))
        elif line.strip():
            raise RuntimeError(f"fennel-ls: {line}")
    return found


def form_end(text, start):
    """The offset just past the form opening at `start`, skipping strings and comments."""
    depth = 0
    i = start
    while i < len(text):
        c = text[i]
        if c == ord('"'):
            i += 1
            while text[i] != ord('"'):
                i += 2 if text[i] == ord("\\") else 1
        elif c == ord(";"):
            while i < len(text) and text[i] != ord("\n"):
                i += 1
            continue
        elif c in OPENS:
            depth += 1
        elif c in (ord(")"), ord("]"), ord("}")):
            depth -= 1
            if depth == 0:
                return i + 1
        i += 1
    raise ValueError(f"unbalanced form at {start}")


def inner(text, start, head):
    """The contents of the form at `start` after its head `head`, stripped, ending clear of a comment."""
    body = text[start + 1 + len(head):form_end(text, start) - 1].strip()
    if b";" in body.rsplit(b"\n", 1)[-1] and not body.endswith((b")", b"]", b"}", b'"')):
        body += b"\n"
    return body


def enclosing(text, offset):
    """The offset of the innermost form opening before `offset` that contains it."""
    i = offset - 1
    while i >= 0:
        if text[i] in OPENS and form_end(text, i) > offset:
            return i
        i -= 1
    return None


def pure(value):
    """Whether evaluating the Fennel `value` can do nothing but give its value."""
    value = value.strip()
    if LITERAL.fullmatch(value) or SYMBOL.fullmatch(value):
        return True
    for head in (b"(..", b"["):
        if value.startswith(head) and form_end(value, 0) == len(value):
            return all(pure(item) for item in items(value[len(head):-1]))
    return False


def items(text):
    """The top-level forms of `text`."""
    found = []
    i = 0
    while i < len(text):
        c = text[i]
        if chr(c).isspace():
            i += 1
        elif c == ord(";"):
            newline = text.find(b"\n", i)
            i = len(text) if newline < 0 else newline
        elif c in OPENS or c == ord('"'):
            end = form_end(text, i) if c in OPENS else string_end(text, i)
            found.append(text[i:end])
            i = end
        else:
            m = SYMBOL.match(text, i)
            if not m:
                raise ValueError(f"no form at {i}: {text[i:i + 20]!r}")
            found.append(m.group(0))
            i = m.end()
    return found


def string_end(text, start):
    """The offset just past the string opening at `start`."""
    i = start + 1
    while text[i] != ord('"'):
        i += 2 if text[i] == ord("\\") else 1
    return i + 1


def gives_value(text, start, end):
    """Whether the form at `start`..`end` ends a body whose value a caller may read: any but a phase's,
    whose value doj-plan-build drops."""
    m = re.compile(rb"(?:\s|;[^\n]*)*[)\]}]").match(text, end)
    if not m or text[m.end() - 1] != ord(")"):
        return False
    body = enclosing(text, start)
    return not (re.match(rb"\(fn\s+\[", text[body:body + 8])
                and re.search(rb"(^|\s|\{):[a-z_]+\s+$", text[max(0, body - 40):body]))


def removal(text, start, end, keep_value):
    """The edit removing the form at `start`..`end`, with its line when it is all of the line."""
    if keep_value and gives_value(text, start, end):
        return start, end, b"nil"
    line_start = text.rfind(b"\n", 0, start) + 1
    if not text[line_start:start].strip() and text[end:end + 1] == b"\n":
        return line_start, end + 1, b""
    return start, end, b""


def binding_form(text, name_at):
    """For a name bound by `(var name ...)` or `(local name ...)`: (form start, head)."""
    m = re.search(rb"\((var|local)\s+$", text[max(0, name_at - 40):name_at])
    if not m:
        return None, None
    return name_at - (len(m.group(0))), m.group(1)


def rewrite(text, offset, message):
    """The (start, end, replacement) fixing one warning, a list of them, or None when none is safe."""
    if message.startswith("unnecessary : call"):
        m = re.compile(rb"\(:\s+(" + SYMBOL.pattern + rb")\s+:(" + SYMBOL.pattern + rb")").match(text, offset)
        return (offset, m.end(), b"(" + m.group(1) + b":" + m.group(2)) if m else None
    if message.startswith("nested .. can be collapsed"):
        end = form_end(text, offset)
        return offset, end, inner(text, offset, b"..") or b'""'
    if message.startswith("use do instead of let with no bindings"):
        # fennel-ls points at the empty vector.
        head = re.search(rb"\(let\s*$", text[max(0, offset - 20):offset])
        empty = re.compile(rb"\[\s*\]").match(text, offset)
        return (offset - len(head.group(0)), empty.end(), b"(do") if head and empty else None
    if message.startswith("unnecessary unary do"):
        return offset, form_end(text, offset), inner(text, offset, b"do")
    symbol = SYMBOL.match(text, offset)
    name = symbol.group(0) if symbol else b""
    if message.startswith("var is never set"):
        start, head = binding_form(text, offset)
        return (start + 1, start + 4, b"local") if head == b"var" else None
    if message.startswith("unused definition"):
        start, head = binding_form(text, offset)
        if head is not None:
            end = form_end(text, start)
            # Its sets are those after it in the body that holds it, where its name is in scope.
            scope = enclosing(text, start)
            scope_end = len(text) if scope is None else form_end(text, scope)
            setter = re.compile(rb"\(set\s+" + re.escape(name) + rb"(?=[\s)])")
            sets = [(m.start(), form_end(text, m.start())) for m in setter.finditer(text, end, scope_end)]
            values = [text[offset + len(name):end - 1]] + [text[s + 1:e - 1].split(None, 2)[2] for s, e in sets]
            if all(pure(v) for v in values):
                return [removal(text, start, end, False)] + [removal(text, s, e, True) for s, e in sets]
        else:
            vector = enclosing(text, offset)
            form = enclosing(text, vector) if vector is not None and text[vector] == ord("[") else None
            head = text[form:vector + 1] if form is not None else b""
            if re.match(rb"\((fn\s+[^\s\[]*\s*|each\s+|for\s+)\[", head):
                return offset, offset + len(name), b"_" + name
            if head.startswith(b"(let") and SYMBOL.fullmatch(name):
                # A let binding: the name and its value, when the value is pure.
                after = items(text[offset + len(name):form_end(text, vector) - 1])
                if after and pure(after[0]):
                    value_at = text.index(after[0], offset + len(name))
                    return offset, value_at + len(after[0]), b""
    return None


def clean(text):
    """`text` with every warning it can fix fixed, and the warnings left as (line, message)."""
    for _ in range(20):
        left = []
        edits = []
        for offset, message in report(text):
            edit = rewrite(text, offset, message)
            if edit is None:
                left.append((offset, message))
            group = edit if isinstance(edit, list) else [edit] if edit else []
            if not any(s < e2 and s2 < e for s, e, _ in edits for s2, e2, _ in group):
                edits.extend(group)
        if not edits:
            return text, [(text.count(b"\n", 0, o) + 1, m) for o, m in left]
        for start, end, replacement in sorted(edits, reverse=True):
            text = text[:start] + replacement + text[end:]
    raise RuntimeError("the lint fixes do not settle")


def main(argv):
    status = 0
    for plan in argv:
        with open(plan, "rb") as f:
            text, left = clean(f.read())
        with open(plan, "wb") as f:
            f.write(text)
        for line, message in left:
            print(f"{plan}:{line}: {message}")
            status = 1
    return status


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
