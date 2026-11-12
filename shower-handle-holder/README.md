# Shower handle adapter

Printable replacement for the small plastic or brass adapter between a shower or tub valve cartridge stem and the handle. It has a round flange on the valve side and a 7-cornered boss that the handle's socket slides over. An elongated socket with rounded ends underneath takes the stem.

![preview](shower-handle-adapter.png)

> **Status: mostly measured (2026-11-11).** Boss outline, flange, overall height, window depth and span, stem and the worn stem bore come from calipers on the original. Window height and the bottom socket are still estimated; measure them (checklist below) before the final print.

## Reference photos

| File | What it shows |
|---|---|
| `DTSHA_web.jpg` | White catalog part, three-quarter view. Flat hex top, with a small one-sided window on a hex corner just above the flange |
| `5_1__03938.webp` | Brass version. Left: round bore in the top. Right: elongated socket with rounded ends and a bevelled entry in the bottom |
| `need-help-locating-...webp` | Yellow original next to the handle. Its window is much larger than on the white part |

## Shape

Bottom to top:
- **Flange** with an **obround socket** (elongated, rounded ends) from below, long axis pointing at the window. The socket has a bevelled entry and goes up to the window ceiling.
- **Boss**: an irregular 7-cornered outline (see **Boss outline**), corners rounded 0.6, top edge rounded 1.0 where it goes into the handle. **Round bore** from the top, down to the window ceiling.
- **Window:** one side only, from 0.35 along the upper-right face, over the point, to 0.75 down the left side flat; each side wall is square to its face. Its floor is the flange top; its back wall is 11.09 from the far side, 3.06 from the centre, so it opens into the bottom socket but not the stem bore.

## Boss outline

Sides go clockwise from the point, looking down on the top; the window is on the last edge and wraps over the point. The outline matches the hand-drawn flat lengths (calipers on the original, corners rounded 0.6). The two side flats are not parallel: they spread about 4 degrees apart toward the flat bottom edge. `boss_pts` holds the sharp corners; the bore axis is the origin.

| Side | Flat drawn | Flat in model | Sharp edge | Width across, model | Width across, calipers |
|---|---|---|---|---|---|
| Point to upper right (window starts 0.35 along) | 7.7 | 7.68 | 8.35 | 15.97 | 15.04 to 15.10 |
| Right side | 5.5 | 5.46 | 5.96 | 14.42 | 14.38 |
| Lower right | 6.0 | 5.96 | 6.50 | 15.56 | 15.04 to 15.10 |
| Bottom (flat edge) | 8.0 | 7.96 | 8.68 | 16.02 | 15.85 (point to this flat) |
| Lower left | 5.5 | 5.46 | 5.97 | 15.02 | 15.04 to 15.10 |
| Left side (window ends 0.75 down) | 5.5 | 5.46 | 5.91 | 14.51 | 14.38 |
| Upper left to the point, window side | 8.0 | 7.97 | 8.72 | 15.49 | 15.04 to 15.10 |

The drawn flats win over the caliper widths: three widths come out 0.4 to 0.9 larger than read. If the part is loose in the handle, that is where to look. The printed part is 0.15 smaller across (`hex_fit`), so its flats read about 0.1 short of these.

## Measurement checklist

Calipers are best. Write down each number and put it into the matching parameter at the top of `shower-handle-adapter.scad`.

| # | Measure | Parameter | Estimate now |
|---|---|---|---|
| 1 | Flange outside diameter | `flange_d` | **22.0 measured** |
| 2 | Flange (lip) thickness | `flange_h` | **3.9 measured** |
| 3 | Boss outline: every flat, and widths across (see **Boss outline**). Corner rounding; top-edge rounding | `boss_pts`, `boss_corner_r`, `boss_top_round` | **drawn flats**, 0.6 fitted, **1.0 measured** |
| 4 | Overall height, flange bottom to boss top | `total_h` | **14.0 measured** |
| 4a | Boss width at the flange vs at the top. The original looks skewed on purpose, to wedge into the handle | `hex_taper` | 0 |
| 5 | Window height | `window_h` | 2.6 |
| 6 | Window span: start along the face past the point, end down the side flat; depth = back wall to the far side (caliper jaw inside the window) | `window_start_frac`, `window_end_frac`, `window_back` | **0.35, 0.75 drawn**, **11.09 measured** |
| 7 | Bottom socket length (end to end) and width (across the straight sides). Also measure the **stem** itself | `bottom_long`, `bottom_short` | 8.8, 5.2 |
| 8 | Socket depth. Are the ends true half-circles? Take a photo straight into it | `bottom_depth`, `bottom_shape` | auto, obround |
| 9 | Socket angle relative to the window (long axis pointing at it, or across it) | `bottom_rot` | 0 |
| 10 | Bevel size at the socket entry | `bottom_entry_chamfer` | 0.8 |
| 11 | Top bore: takes the stem tip, so it must be tight. Stem 6.44; worn original bore 6.54 x 6.80 (worn oval) | `top_round_d`, `top_round_fit`, `top_round_h` | **6.44 + 0.1 measured**, auto |
| 12 | Stem length out of the cartridge, as a cross-check | (check) | 11.58 measured |
| 13 | Anything not drawn here | (tell me) | |

Helpful photos: one straight at the window, one straight at the side opposite it, one straight down on top, one straight up from the bottom, and one into the handle's socket. A ruler in each shot helps.

The render prints a summary to check before slicing:

    ECHO: "Adapter: flange 22 x 3.9, boss 7 corners, r 0.6, top round 1, taper 0, height 10.1, total 14, stem bore 6.54, window 110 deg wide x 2.6, back wall 3.06 from centre"

## Fit tests before the full part

Set `part` in the Customizer, or on the command line:

- `hex_gauge`: the top 4 mm of the boss, with the stem bore. It should slide into the handle with no wobble (adjust `hex_fit`) and grip the stem tip with no play (adjust `top_round_fit`; the original wore loose here)
- `bottom_gauge`: the flange only, with the bottom socket. It should push onto the stem snugly. Adjust `hole_fit` (or `bottom_long` / `bottom_short`)

```
openscad -o hex-gauge.stl -D 'part="hex_gauge"' shower-handle-adapter.scad
```

## Printing

Print flange down with no supports, because the window ceiling bridges. The original is molded plastic, so PETG or ABS/ASA at 100 % infill is a good match. PLA creeps when warm and wet. Only the small ledge inside, where the round bore meets the bottom socket, is unsupported.
