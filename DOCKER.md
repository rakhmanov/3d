# Runnin OpenSCAD using Docker

Ensure that [Docker](https://docker.com) is intalled.   
In case of teminal only usage (without Display) you will need xvfb.

## Generating STL 

    docker run --rm --init -v "$PWD":/openscad -w /openscad openscad/openscad:latest openscad -o "bellow.stl" bellow/bellow.scad

## Terminal Without Display:   
Ensure that you have xvfb installed.

    xvfb-run -a docker run --rm --init -v "$PWD":/openscad -w /openscad openscad/openscad:latest openscad -o "bellow.stl" bellow/bellow.scad

## Generating PNG preview.
    docker run --rm --init -v "$PWD":/openscad -w /openscad openscad/openscad:latest xvfb-run -a openscad -o "bellow.png" --imgsize 800,600 --render --viewall bellow/bellow.scad
