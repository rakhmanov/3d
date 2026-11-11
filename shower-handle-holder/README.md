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
- **Window:** one side only, a 93 degree wedge from the point to three quarters down the next parallel flat. Its floor is the flange top; its back wall is 11.09 from the far side, 3.43 from the centre, so it opens into the bottom socket but not the stem bore.

## Boss outline

Sides go clockwise from the point, looking down on the top. The window side is the last two rows. Calipers on rounded corners read each flat short, so the outline is a least-squares fit (sharp corners plus 0.6 mm rounding) to every reading at once; `boss_pts` holds its corners.

| Side | Flat measured | Flat in model | Sharp edge | Width across, measured | Width across, model |
|---|---|---|---|---|---|
| Point to upper right | 7.7 | 7.82 | 8.53 | 15.04 to 15.10 | 15.21 |
| Right (parallel pair) | 5.5 | 5.21 | 5.70 | 14.38 | 14.30 |
| Lower right | 6.0 | 5.73 | 6.26 | 15.04 to 15.10 | 15.15 |
| Bottom | 8.0 | 7.51 | 8.18 | 15.85 (point to this flat) | 15.71 |
| Lower left | 5.5 | 5.20 | 5.69 | 15.04 to 15.10 | 15.14 |
| Left (parallel pair), window ends 3/4 down | 5.5 | 5.18 | 5.66 | 14.38 | 14.30 |
| Upper left to the point, window side | 8.0 | 8.11 | 8.84 | 15.04 to 15.10 | 15.19 |

The side lengths alone would give a part only 13.3 to 15.4 across, which the width readings rule out; rounded corners reconcile them. Fit residuals are up to 0.5 mm on flats (the bottom one) and 0.15 mm on widths. The bore sits at the average of the corners; if the real part's bore is off-centre, shift `boss_pts`.

`cutaway = true` shows the section.

## Measurement checklist

Calipers are best. Write down each number and put it into the matching parameter at the top of `shower-handle-adapter.scad`.

| # | Measure | Parameter | Estimate now |
|---|---|---|---|
| 1 | Flange outside diameter | `flange_d` | **22.0 measured** |
| 2 | Flange (lip) thickness | `flange_h` | **3.9 measured** |
| 3 | Boss outline: every flat, and widths across (see **Boss outline**). Corner rounding; top-edge rounding | `boss_pts`, `boss_corner_r`, `boss_top_round` | **fitted**, 0.6 fitted, **1.0 measured** |
| 4 | Overall height, flange bottom to boss top | `total_h` | **14.0 measured** |
| 4a | Boss width at the flange vs at the top. The original looks skewed on purpose, to wedge into the handle | `hex_taper` | 0 |
| 5 | Window height | `window_h` | 2.6 |
| 6 | Window span (from the point to how far down the next parallel flat); depth = back wall to the far side (caliper jaw inside the window) | `window_end_frac`, `window_back` | **0.75 marked**, **11.09 measured** |
| 7 | Bottom socket length (end to end) and width (across the straight sides). Also measure the **stem** itself | `bottom_long`, `bottom_short` | 8.8, 5.2 |
| 8 | Socket depth. Are the ends true half-circles? Take a photo straight into it | `bottom_depth`, `bottom_shape` | auto, obround |
| 9 | Socket angle relative to the window (long axis pointing at it, or across it) | `bottom_rot` | 0 |
| 10 | Bevel size at the socket entry | `bottom_entry_chamfer` | 0.8 |
| 11 | Top bore: takes the stem tip, so it must be tight. Stem 6.44; worn original bore 6.54 x 6.80 (worn oval) | `top_round_d`, `top_round_fit`, `top_round_h` | **6.44 + 0.1 measured**, auto |
| 12 | Stem length out of the cartridge, as a cross-check | (check) | 11.58 measured |
| 13 | Anything not drawn here | (tell me) | |

Helpful photos: one straight at the window, one straight at the side opposite it, one straight down on top, one straight up from the bottom, and one into the handle's socket. A ruler in each shot helps.

The render prints a summary to check before slicing:

    ECHO: "Adapter: flange 22 x 3.9, boss 7 corners, r 0.6, top round 1, taper 0, height 10.1, total 14, stem bore 6.54, window 93 deg wide x 2.6, back wall 3.43 from centre"

## Fit tests before the full part

Set `part` in the Customizer, or on the command line:

- `hex_gauge`: the top 4 mm of the boss, with the stem bore. It should slide into the handle with no wobble (adjust `hex_fit`) and grip the stem tip with no play (adjust `top_round_fit`; the original wore loose here)
- `bottom_gauge`: the flange only, with the bottom socket. It should push onto the stem snugly. Adjust `hole_fit` (or `bottom_long` / `bottom_short`)

```
openscad -o hex-gauge.stl -D 'part="hex_gauge"' shower-handle-adapter.scad
```

## Printing

Print flange down with no supports, because the window ceiling bridges. The original is molded plastic, so PETG or ABS/ASA at 100 % infill is a good match. PLA creeps when warm and wet. Only the small ledge inside, where the round bore meets the bottom socket, is unsupported.
