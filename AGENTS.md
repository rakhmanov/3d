# Agent notes

OpenSCAD models, one folder per design: `<name>.scad`, generated `<name>.stl` + `.png`, `README.md`.
CI re-renders changed `.scad` files on push to `main`.

## Render

From the repo root, with the CI image:

    IMG=openscad/openscad:dev.2026-10-20
    docker run --rm -v "$PWD":/openscad -w /openscad $IMG \
      openscad --backend=manifold --export-format binstl -o dir/name.stl dir/name.scad
    docker run --rm --init -v "$PWD":/openscad -w /openscad $IMG \
      openscad --backend=manifold -o dir/name.png --imgsize=800,600 --render --viewall dir/name.scad

- Read stderr for `echo()` and `assert()` output.
- To check committed STLs are current, render to a scratch dir and `cmp`.

- On WSL, Docker Desktop must be running; Windows `.exe`s (including a local OpenSCAD) cannot be run from WSL here.

## Concept drafts

Sketch new ideas as an OpenSCAD draft in the design's folder, not as SVGs or generated images,
so the draft grows into the real model.

- Header says `DRAFT` and which dimensions are placeholders; README holds the plan and a `Measure` list.
- Keep the printable part in `<name>.scad`. Put the display in `<name>-scene.scad`: it `include`s the part,
  sets `show_part = false`, and adds the host device (its own `.scad`, e.g. `a6300-camera.scad`) and bought parts
  (fans, switches, boards) at their datasheet sizes, in real colors. Name the part numbers in the README.
- Render previews **without** `--render` (preview mode keeps colors) to `scene-*.png`, with
  `--camera=...` views and `-D` overrides for variants (size, `cutaway`). Look at every PNG before reporting it.
- No STL and no root README entry until the dimensions are measured.

## Check

    python3 tools/stl-check.py dir/name.stl

Reports size, manifold, bridges and faces under 45 degrees. Bed is 256 mm; split larger parts.

## Conventions

- Parameters at the top of the main `.scad`; variants `use <>` it.
- Keep the README and `.scad` header in sync with the geometry.
- Binary STL. Licence CC BY-NC 4.0.
- Add new designs to the root [README.md](README.md).
