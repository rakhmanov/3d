# Running OpenSCAD using Docker

Ensure that [Docker](https://docker.com) is installed.

We use a dated OpenSCAD dev build (`openscad/openscad:dev.2026-10-20`) with the Manifold geometry engine
(`--backend=manifold`). It is multithreaded and renders in seconds what the old `latest`
image (OpenSCAD 2021.01, single-threaded CGAL) takes minutes for. Use the same image tag as
[the workflow](.github/workflows/flow.yaml) so local and CI output match.

## Generating STL

Binary STL is several times smaller than the default text STL and every slicer reads it.

    docker run --rm -v "$PWD":/openscad -w /openscad openscad/openscad:dev.2026-10-20 \
      openscad --backend=manifold --export-format binstl -o bellows/bellows.stl bellows/bellows.scad

## Generating PNG preview

    docker run --rm --init -v "$PWD":/openscad -w /openscad openscad/openscad:dev.2026-10-20 \
      openscad --backend=manifold -o bellows/bellows.png --imgsize=800,600 --render --viewall bellows/bellows.scad
