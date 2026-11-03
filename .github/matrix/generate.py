import os
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


# Pick every SCAD whose STL or PNG is missing or was last committed before the SCAD changed.
# Unlike diffing only HEAD, this catches pushes with several commits and runs that failed earlier.
scad_files = subprocess.check_output(['git', 'ls-files', '*.scad']).decode().splitlines()

entries = []
for path in scad_files:
    base = os.path.splitext(path)[0]
    scad_commit = last_commit(path)
    stale = False
    for ext in ('.stl', '.png'):
        output_commit = last_commit(base + ext)
        if not output_commit or not is_ancestor(scad_commit, output_commit):
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
