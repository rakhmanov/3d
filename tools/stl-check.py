#!/usr/bin/env python3
"""Printability check for binary STLs, printed face down as exported (z up).

Reports bounding box, open/non-manifold edges, flat downward faces above the
bed (bridges / unsupported ceilings) and faces steeper than 45 degrees.
Pure standard library, no numpy.

    python3 tools/stl-check.py part.stl [more.stl ...]
    python3 tools/stl-check.py --max-angle 50 part.stl
"""
import argparse, collections, math, struct


def triangles(path):
    data = open(path, 'rb').read()
    if data[:5] == b'solid' and b'facet' in data[:300]:
        raise SystemExit(f'{path}: ASCII STL, export with --export-format binstl')
    n = struct.unpack('<I', data[80:84])[0]
    for i in range(n):
        v = struct.unpack('<12f', data[84 + 50 * i:84 + 50 * i + 48])
        yield v[3:6], v[6:9], v[9:12]


def check(path, max_angle):
    tris = list(triangles(path))
    pts = [p for t in tris for p in t]
    lo = [min(p[k] for p in pts) for k in range(3)]
    hi = [max(p[k] for p in pts) for k in range(3)]
    edges = collections.Counter()
    flat = collections.defaultdict(lambda: [0.0, [1e9, -1e9, 1e9, -1e9]])
    steep = []
    # a face at phi from horizontal has normal z = -cos(phi); flag phi < 90 - max_angle (0.5 deg slack)
    limit = -math.cos(math.radians(90 - max_angle - 0.5))
    for a, b, c in tris:
        for e in ((a, b), (b, c), (c, a)):
            edges[tuple(sorted((tuple(round(x, 4) for x in e[0]), tuple(round(x, 4) for x in e[1]))))] += 1
        u = [b[k] - a[k] for k in range(3)]
        w = [c[k] - a[k] for k in range(3)]
        n = (u[1] * w[2] - u[2] * w[1], u[2] * w[0] - u[0] * w[2], u[0] * w[1] - u[1] * w[0])
        L = math.sqrt(sum(x * x for x in n))
        if not L:
            continue
        nz, area, z = n[2] / L, L / 2, min(a[2], b[2], c[2])
        if z <= lo[2] + 0.01:
            continue                                 # on the bed
        if nz < -0.999:
            g = flat[round(z, 2)]
            g[0] += area
            for p in (a, b, c):
                g[1][0] = min(g[1][0], p[0]); g[1][1] = max(g[1][1], p[0])
                g[1][2] = min(g[1][2], p[1]); g[1][3] = max(g[1][3], p[1])
        elif nz < limit:
            steep.append((math.degrees(math.acos(-nz)), area, (a, b, c)))

    bad = sum(1 for k in edges.values() if k != 2)
    print(f'{path}: {len(tris)} triangles, size {hi[0]-lo[0]:.1f} x {hi[1]-lo[1]:.1f} x {hi[2]-lo[2]:.1f} mm'
          f', {"manifold" if not bad else f"{bad} open/non-manifold edges"}')
    for z, (area, bb) in sorted(flat.items()):
        dx, dy = bb[1] - bb[0], bb[3] - bb[2]
        print(f'  flat ceiling z={z}: {area:.1f} mm2, x[{bb[0]:.1f}, {bb[1]:.1f}] y[{bb[2]:.1f}, {bb[3]:.1f}]'
              f' -> bridge span ~{max(dx, dy):.1f} mm (if supported at both ends of the long side)')
    if steep:
        worst = min(s[0] for s in steep)
        tot = sum(s[1] for s in steep)
        print(f'  flatter than {90 - max_angle:g} deg from horizontal: {tot:.1f} mm2, worst {worst:.1f} deg')
        for ang, area, t in sorted(steep)[:5]:
            print(f'    {ang:4.1f} deg {area:5.2f} mm2 at', tuple(round(x, 1) for x in t[0]))
    if not flat and not steep:
        print('  no overhangs')


ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
ap.add_argument('stl', nargs='+')
ap.add_argument('--max-angle', type=float, default=45, help='overhang limit, degrees from vertical (default 45)')
args = ap.parse_args()
for f in args.stl:
    check(f, args.max_angle)
