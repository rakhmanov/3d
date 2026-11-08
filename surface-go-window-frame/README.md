# Surface Go window frame

![preview](surface-go-window-frame.png)

Slide-in frame for a 1st-gen Surface Go (245 x 175 x 8.3 mm) used as a shop-window display. The flat front face is taped to the inside of the glass all the way round, screen facing out. The tablet slides in from the open top edge and rests on the bottom wall; a thin felt strip on its back stops it rattling. The charger plugs in through a slot.

| Part | File | Notes |
|---|---|---|
| Landscape frame | [surface-go-window-frame.stl](surface-go-window-frame.stl) | opens on the long top edge, charger slot bottom right (seen from outside) |
| Portrait frame | [surface-go-window-frame-portrait.stl](surface-go-window-frame-portrait.stl) | opens on the short top edge, charger slot at the bottom |

Each frame is 254 x 184 x 19 mm, about 80 g of PETG, so it fits a 256 mm bed (Bambu P1/X1/A1) in one piece. The tape is permanent, so print the frame for the orientation you want; a second frame is needed to switch.

## Print

- Front face down on the bed: that's the face that gets taped, so it comes out flat and clean.
- No supports. The back rim overhangs 2.5 mm flat, then slopes at 45 degrees, and there is no rim along the open edge. The only bridge is over the charger slot (60 mm).
- Matte black PETG, or ASA on an enclosed printer. Avoid PLA in a sunny window.
- 4 walls (perimeters) and 30% gyroid infill for strength.
- The fit is deliberately loose (1 mm each side, 1 mm front to back), so it fits without a test print.

## Mount

1. Clean the glass with isopropyl alcohol.
2. Run 12 mm VHB tape (e.g. 3M 5952, black) round the front face. The flat strip is 16 mm wide, all four sides.
3. Use a level, press the frame onto the glass hard for 30 s, and wait 24 h before loading the tablet.
4. Stick a strip of 1 mm self-adhesive felt along the back of the tablet's two side edges and bottom edge, within 6 mm of the edge (that's where the back rim overlaps it). It takes up the slack so the tablet doesn't rattle.
5. Slide the tablet in from the top, screen towards the glass, and plug in the charger through the slot.

## Hardware

- 1 mm self-adhesive felt, about 0.5 m (cut into 5 mm strips).
- 12 mm VHB tape, about 0.9 m.

## Check before printing

All dimensions are parameters at the top of [surface-go-window-frame.scad](surface-go-window-frame.scad); the portrait file reuses them.

- `cable_y`: Surface Connect slot position (an estimate, near the bottom of the right edge seen from outside). Measure your tablet.
- Coordinates in the SCAD are as seen from the room (the tablet's back), so the charger edge is the left wall there.
- `btn_x`: power/volume buttons, only cut in the portrait frame (in landscape they are at the open top).
- `clear`, `play_t`: side and front-back clearance.
- `tab_r`: keep at or below the tablet's corner radius.
