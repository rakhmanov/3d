# Shower handle adapter

Printable replacement for the small plastic or brass adapter between a shower or tub valve cartridge stem and the handle. It has a round flange on the valve side and a hex boss that the handle's hex socket slides over. An elongated socket with rounded ends underneath takes the stem.

![preview](shower-handle-adapter.png)

> **Status: partly measured (2026-11-11).** Hex, overall height, stem and the worn stem bore come from calipers on the original. Flange, window and bottom socket are still scaled from photos; measure them (checklist below) before the final print.

## Reference photos

| File | What it shows |
|---|---|
| `DTSHA_web.jpg` | White catalog part, three-quarter view. Flat hex top, with a small one-sided window on a hex corner just above the flange |
| `5_1__03938.webp` | Brass version. Left: round bore in the top. Right: elongated socket with rounded ends and a bevelled entry in the bottom |
| `need-help-locating-...webp` | Yellow original next to the handle. Its window is much larger than on the white part |

## Shape

Bottom to top:
- **Flange** with an **obround socket** (elongated, rounded ends) from below, long axis pointing at the window. The socket has a bevelled entry and goes up to the window ceiling.
- **Boss**: a hexagon squeezed to 14.38 across one pair of flats (15.09 across the other two), with the corner opposite the point cut flat, so 7 corners. **Round bore** from the top, down to the window ceiling.
- **Window:** one side only, on the slanted face from the point to the end of a 14.38 flat. Its floor is the flange top; its back wall is 11.09 from the parallel face opposite, 3.55 short of the centre, so it opens into the bottom socket but not the stem bore.

`cutaway = true` shows the section.

## Measurement checklist

Calipers are best. Write down each number and put it into the matching parameter at the top of `shower-handle-adapter.scad`.

| # | Measure | Parameter | Estimate now |
|---|---|---|---|
| 1 | Flange outside diameter | `flange_d` | 20.0 |
| 2 | Flange thickness | `flange_h` | 3.8 |
| 3 | Boss: a hexagon with one corner cut flat (7 corners). Short parallel flats; the other two pairs; point to the cut flat opposite | `boss_flats`, `hex_af`, `boss_point_to_flat` | **14.38, 15.09, 15.85 measured** |
| 4 | Overall height, flange bottom to hex top | `total_h` | **14.05 measured** |
| 4a | Hex AF at the flange vs at the top. The original looks skewed on purpose, to wedge into the handle | `hex_taper` | 0 |
| 5 | Window height | `window_h` | 2.6 |
| 6 | Window width at the face and at its back wall; depth = back wall to the opposite outer face (caliper jaw inside the window) | `window_w_outer`, `window_w_inner`, `window_back` | 6.5, 6.5, **11.09 measured** |
| 7 | Bottom socket length (end to end) and width (across the straight sides). Also measure the **stem** itself | `bottom_long`, `bottom_short` | 8.8, 5.2 |
| 8 | Socket depth. Are the ends true half-circles? Take a photo straight into it | `bottom_depth`, `bottom_shape` | auto, obround |
| 9 | Socket angle relative to the window (long axis pointing at it, or across it) | `bottom_rot` | 0 |
| 10 | Bevel size at the socket entry | `bottom_entry_chamfer` | 0.8 |
| 11 | Top bore: takes the stem tip, so it must be tight. Stem 6.44; worn original bore 6.54 x 6.80 (worn oval) | `top_round_d`, `top_round_fit`, `top_round_h` | **6.44 + 0.1 measured**, auto |
| 12 | Stem length out of the cartridge, as a cross-check | (check) | 11.58 measured |
| 13 | Anything not drawn here | (tell me) | |

Helpful photos: one straight at the window, one straight at the side opposite it, one straight down on top, one straight up from the bottom, and one into the handle's socket. A ruler in each shot helps.

The render prints a summary to check before slicing:

    ECHO: "Adapter: flange 20 x 3.8, boss 14.23 / 14.94 flats, point to flat 15.7, taper 0, x 10.25, total 14.05, stem bore 6.54, window 6.5->6.5 x 2.6 at 180 deg, back wall 3.55 short of centre"

## Fit tests before the full part

Set `part` in the Customizer, or on the command line:

- `hex_gauge`: the top 4 mm of the hex, with the stem bore. It should slide into the handle with no wobble (adjust `hex_fit`) and grip the stem tip with no play (adjust `top_round_fit`; the original wore loose here)
- `bottom_gauge`: the flange only, with the bottom socket. It should push onto the stem snugly. Adjust `hole_fit` (or `bottom_long` / `bottom_short`)

```
openscad -o hex-gauge.stl -D 'part="hex_gauge"' shower-handle-adapter.scad
```

## Printing

Print flange down with no supports, because the window ceiling bridges. The original is molded plastic, so PETG or ABS/ASA at 100 % infill is a good match. PLA creeps when warm and wet. Only the small ledge inside, where the round bore meets the bottom socket, is unsupported.
