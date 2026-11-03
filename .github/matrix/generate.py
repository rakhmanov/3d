import os
import re
import json
import subprocess


def last_commit(path):
    return subprocess.check_output(
        ['git', 'log', '-1', '--format=%H', '--', path]
    ).decode().strip()


def is_ancestor(older, newer):
    return subprocess.run(
        ['git', 'merge-base', '--is-ancestor', older, newer]
    ).returncode == 0


def sources(path, seen=None):
    """The SCAD file plus every local file it pulls in with use<> / include<>."""
    seen = seen if seen is not None else set()
    if path in seen or not os.path.isfile(path):
        return seen
    seen.add(path)
    with open(path) as f:
        for dep in re.findall(r'\b(?:use|include)\s*<([^>]+)>', f.read()):
            sources(os.path.normpath(os.path.join(os.path.dirname(path), dep)), seen)
    return seen


# Pick every SCAD whose STL or PNG is missing or was last committed before the SCAD (or a dependency) changed.
# Unlike diffing only HEAD, this catches pushes with several commits and runs that failed earlier.
scad_files = subprocess.check_output(['git', 'ls-files', '*.scad']).decode().splitlines()

entries = []
for path in scad_files:
    base = os.path.splitext(path)[0]
    source_commits = [c for c in map(last_commit, sources(path)) if c]
    stale = False
    for ext in ('.stl', '.png'):
        output_commit = last_commit(base + ext)
        if not output_commit or not all(is_ancestor(c, output_commit) for c in source_commits):
            stale = True
    if stale:
        entries.append({"folder": os.path.dirname(path), "name": os.path.basename(base)})

if entries:
    matrix = {"include": entries}
    print(json.dumps(matrix, indent=2))
    with open(os.environ['GITHUB_OUTPUT'], 'a') as f:
        f.write(f"matrix={json.dumps(matrix)}\n")
else:
    print("No valid entries; skipping matrix.")
