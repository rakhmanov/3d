# Surface Go window frame

![preview](surface-go-window-frame.png)

Frame for a 1st-gen Surface Go (245 x 175 x 8.3 mm) used as a shop-window display. It sticks to the inside of the glass with the screen facing out. It works in landscape and portrait: the 3M Dual Lock pads sit at the same four spots in both orientations, so you pull the frame off and snap it back rotated, with no re-taping.

| Part | File | Qty |
|---|---|---|
| Frame | [surface-go-window-frame.stl](surface-go-window-frame.stl) | 1 |
| Back bar | [surface-go-back-bar.stl](surface-go-back-bar.stl) | 2 |
| Fit test corner | [surface-go-fit-test.stl](surface-go-fit-test.stl) | 1 (print first) |

Frame is 252 x 182 x 20.6 mm, so it fits a 256 mm bed (Bambu P1/X1/A1) in one piece.

## Print

- Orientation as exported: room side down, glass side up.
- Supports under the front lip only (that face sits against the tablet bezel, so marks are hidden).
- Matte black PETG, or ASA on an enclosed printer. Avoid PLA in a sunny window.
- Print the fit test corner first: check the tablet corner, the lip and a bar in the groove.

## Mount

1. Stick four 12 x 12 mm Dual Lock pads into the square recesses on the lip, and snap the matching pads onto them.
2. Peel the outer liners and press the whole frame onto clean glass, so the glass pads land in exactly the right spots.
3. Wait 24 h, then drop the tablet in from the room side and snap the two bars into the grooves.
4. Landscape: cable slot on the right. Portrait: rotate so the cable slot is at the bottom.

## Check before printing

All dimensions are parameters at the top of [surface-go-window-frame.scad](surface-go-window-frame.scad); the bar and fit-test files reuse them.

- `cable_y`, `btn_x`: Surface Connect and power/volume button positions are estimates. Measure your tablet.
- `dl_mated`: thickness of a mated Dual Lock pair including both adhesives (5.7 mm assumed). The skirt height follows from it.
- `tab_r`: keep at or below the tablet's corner radius.
