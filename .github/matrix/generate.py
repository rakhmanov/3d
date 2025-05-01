import os
import json
import subprocess

# Get changed files from the current commit
changed_files = subprocess.check_output(
    ['git', 'diff-tree', '--no-commit-id', '--name-only', '--diff-filter=ACMR', '-r', 'HEAD']
).decode().splitlines()

entries = []
for path in changed_files:
    if path.endswith('.scad'):
        splitName = os.path.splitext(os.path.basename(path))
        folder = os.path.dirname(path)
        name = splitName[0]
        extension = splitName[1]
        entries.append({"folder": folder, "name": name})

if entries:
    matrix = {"include": entries}
    with open(os.environ['GITHUB_OUTPUT'], 'a') as f:
        f.write(f"matrix={json.dumps(matrix)}\n")
else:
    print("No valid entries; skipping matrix.")
