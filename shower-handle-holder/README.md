# Shower handle adapter

Printable replacement for the small plastic or brass adapter between a shower or tub valve cartridge stem and the handle. It has a round flange on the valve side and a 7-cornered boss that the handle's socket slides over. A double-D slot through the middle takes the stem, and a round bore at the top seats its end.

![preview](shower-handle-adapter.png)

> **Status: measured (2026-11-11).** Flange, boss outline, overall height, window height and depth, and the stem flats come from calipers on the original; the window span was marked on a render. Only the stem's round diameter (10.0) is estimated, from the worn bore.

## Shape

Bottom to top:
- **Stem slot** from the bottom up to the round top bore: the cartridge stem is a double-D (a round shaft about 10 across with two flats 6.44 apart) with a screw insert in its middle. The slot is the stem's own shape and grips it tight (the original wore round here, which is why this part is being redrawn), its long (round) axis pointing at the corner at the top of the right side wall (the first test print, with the flats square to the upper-right face, turned the handle about 28 degrees off). Bevelled entry from below. The top 2 mm of the hole is round instead, 6.54 across (`top_round_d` + fit, the same as the flats), so the stem's round ends stop on a flat ledge 12 above the flange bottom and the metal shaft seats against it.
- **Boss**: a symmetric 7-cornered outline (see **Boss outline**), corners rounded 0.6, top edge rounded 1.0 where it goes into the handle.
- **Window:** one side only, from 0.35 along the upper-right face, over the point, to 0.75 down the left side wall; each side wall of the window is square to its face at the top and leans in 12 degrees going up, so the opening is wider at the flange. Its floor is the flange top and it opens straight into the stem slot (its back wall is on the axis), with no wall left between them.

## Boss outline

A symmetric 7-cornered outline, point up, in the shape of the hand drawing (walls 6.0, closing slightly toward the flat bottom). The face lengths are solved so the part reads the caliper widths taken on the original; the drawing came from a warped photo and gave a part about 1 mm too small. The bore sits at the outline's area centre. Corners are rounded 0.6, so a caliper laid along a face reads its straight part, about 0.7 short of the corner-to-corner size.

| Edge | Corner to corner | Parameter | Drawn | Straight part on the print |
|---|---|---|---|---|
| Each upper face, point to wall top | 8.79 | `boss_top_side` | 8.5 | 8.05 |
| Each side wall | 6.0 | `boss_wall` | 6.0 | 5.50 |
| Each lower face | 5.93 | `boss_low_side` | 5.0 | 5.43 |
| Bottom flat | 7.37 | `boss_bottom` | 8.0 | 6.75 |
| Across the walls, top / bottom ends | 14.38 / 14.18 | `boss_width_top`, `boss_width_bottom` | 14.2 / 14.0 | |

| Caliper reading on the original | Measured | Model at `hex_fit` 0 (the print is 0.2 less) |
|---|---|---|
| Across the upper faces and across the lower faces | 15.04 to 15.10 | 15.06 |
| Across the walls | 14.38 | 14.37 |
| Point to bottom flat | 15.85 | 15.78 |

The print at the measured size (`hex_fit` 0) would not go into the handle, so `hex_fit` is -0.2: every face moves in 0.1. If it is still tight, go to -0.3 or -0.4; print `hex_gauge` to try a size quickly.

## Dimensions

All in mm. Each value is a parameter at the top of `shower-handle-adapter.scad`.

| Feature | Parameter | Value | Source |
|---|---|---|---|
| Flange diameter, thickness | `flange_d`, `flange_h` | 22.0, 3.9 | calipers |
| Boss outline, corner to corner (see **Boss outline**) | `boss_top_side`, `boss_wall`, `boss_low_side`, `boss_bottom`, `boss_width_top`, `boss_width_bottom` | 8.79, 6.0, 5.93, 7.37, 14.38, 14.18 | solved from caliper widths |
| Boss corner rounding, top-edge rounding | `boss_corner_r`, `boss_top_round` | 0.6, 1.0 | fit to sides; calipers |
| Overall height, flange bottom to boss top | `total_h` | 14.0 | calipers |
| Boss taper toward the top | `hex_taper` | 0 | none on the print |
| Window height from the flange top | `window_h` | 5.7 | calipers |
| Window span: along the upper-right face, down the left wall | `window_start_frac`, `window_end_frac` | 0.35, 0.75 | marked on a render |
| Window depth past the centre | `window_depth` | 2.0 | calipers |
| Window side wall lean | `window_flare` | 12 degrees | chosen for printing |
| Stem round diameter | `bottom_long` | 10.0 | **estimate** (worn bore is ~10 round) |
| Stem across the flats | `bottom_short` | 6.44 | calipers |
| Slot angle: long axis through the top corner of the right side wall | `bottom_rot` | 0 | test fit |
| Whole part turned so the slot long axis lies along Y | `part_angle` | 90 degrees | orientation only |
| Round top bore: diameter, height | `top_round_d`, `top_round_h` | 6.44, 2.0 | same as the flats |
| Bevel at the slot entry | `bottom_entry_chamfer` | 0.8 | |
| Print allowance on the slot and bore; on the boss | `hole_fit`, `hex_fit` | 0.1, -0.2 | boss: test fit |
| Stem length out of the cartridge (cross-check: the ledge is at 12) | | 11.58 | calipers |

The render prints a summary to check before slicing:

    ECHO: "Adapter: flange 22 x 3.9, boss 7 corners, r 0.6, top round 1, taper 0, height 10.1, total 14, stem slot 10.1 x 6.54, top bore 6.54 x 2, window 118 deg wide x 5.7, depth 2 past centre"

## Fit tests before the full part

Set `part` in the Customizer, or on the command line:

- `hex_gauge`: the top 4 mm of the boss, with the stem slot. It should slide into the handle with no wobble (adjust `hex_fit`) and grip the stem with no play (adjust `hole_fit`; the original wore loose here)
- `bottom_gauge`: the flange only, with the slot entry. It should push onto the stem snugly. Adjust `hole_fit` (or `bottom_long` / `bottom_short`)

```
openscad -o hex-gauge.stl -D 'part="hex_gauge"' shower-handle-adapter.scad
```

## Printing

Built to print lip down with no supports, from simple straight cuts. The stem slot runs up to the round top bore, and the window opens straight into the slot. Its side walls lean in 12 degrees going up (`window_flare`): the top edge is where it was, the opening widens toward the flange, so the boss steps out over the window at an angle instead of standing square over it. The flat ceilings are the strip over the window, a bridge about 12 long, and the ledge under the round top bore: two small crescents, at most 1.8 deep, at the slot's round ends.

Print flange down with no supports, because the window ceiling bridges. The original is molded plastic, so PETG or ABS/ASA at 100 % infill is a good match. PLA creeps when warm and wet.
