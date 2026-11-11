# Surface Go window frame

![preview](surface-go-window-frame.png)

Slide-in frame for a 1st-gen Surface Go (245 x 175 x 8.3 mm) used as a shop-window display. The flat front face is taped to the inside of the glass all the way round, screen facing out. The tablet slides in from the open top edge and rests on the bottom wall; felt strips on the back rim's chamfer stop it rattling. The charger plugs in through a slot.

| Part | One piece | Two halves (256 mm bed) | Notes |
|---|---|---|---|
| Landscape frame | [surface-go-window-frame.stl](surface-go-window-frame.stl) | [left](surface-go-window-frame-left.stl) + [right](surface-go-window-frame-right.stl) | opens on the long top edge, charger slot bottom right (seen from outside) |
| Portrait frame | [surface-go-window-frame-portrait.stl](portrait/surface-go-window-frame-portrait.stl) | [bottom](portrait/surface-go-window-frame-portrait-bottom.stl) + [top](portrait/surface-go-window-frame-portrait-top.stl) | opens on the short top edge, charger slot at the bottom |
| Butterfly key (halves only) | | [surface-go-window-frame-key.stl](surface-go-window-frame-key.stl) | locks the seam from the back: 1 for landscape, 2 for portrait |

Each frame is 254 x 184 x 17 mm, about 70 g of PETG. That's too tight for a 256 mm bed (Bambu A1/P1/X1): the slicer won't place it once a brim or the purge area is involved. So each frame also comes as two halves, about 133 x 184 mm each, printed one at a time. A dovetail in the front lip above and below the screen locks them together, and you glue them. The tape is permanent, so print the frame for the orientation you want; a second frame is needed to switch.

## Print

- Front face down on the bed: that's the face that gets taped, so it comes out flat and clean.
- No supports. The underside of the back rim is a 45 degree chamfer straight off the pocket wall (no flat overhang to droop), and there is no rim along the open edge. The only bridges are over the charger slot (60 mm) and, on the portrait frame only, the power/volume button cutout (44 mm). Both are short, 4.5 mm wide strips anchored at each end; turn bridge settings on.
- Matte black PETG, or ASA on an enclosed printer. Avoid PLA in a sunny window.
- 4 walls (perimeters) and 30% gyroid infill for strength.
- The fit is deliberately loose (1 mm each side, 1 mm front to back), so it fits without a test print.
- Halves: turn on elephant-foot compensation (about 0.15 mm; Bambu Studio has it under Quality). The dovetails sit in the first 2 mm, where the first layer spreads, and `dt_fit` leaves only 0.05 mm per side.

## Assemble (two halves)

1. Dry-fit: the dovetails should drop into their sockets without force (`dt_fit` sets the gap), and the butterfly key should drop into its pocket without spreading the seam (`key_clear` shrinks the key; raise it if it is still tight).
2. Glue the seam faces and dovetails (CA glue, or epoxy for PETG/ASA). Press the halves together front face down on a flat surface (glass or the build plate) and let it cure.
3. While the glue is still wet, put glue in the bow-tie pocket on the back rim and press a butterfly key into each one: landscape has one (bottom wall), portrait has two (both long walls). The key locks the back of the seam, the lip dovetails lock the front, so the frame can't fold at the seam.
4. Lightly sand the front face across the seam so the VHB tape sits flat. The tape spanning the seam adds strength once the frame is on the glass.

## Mount

1. Clean the glass with isopropyl alcohol.
2. Run 12 mm VHB tape (e.g. 3M 5952, black) round the front face. The flat strip is 16 mm wide, all four sides.
3. Use a level, press the frame onto the glass hard for 30 s, and wait 24 h before loading the tablet.
4. Stick 1 mm self-adhesive felt on the back rim's 45 degree chamfer, along both side walls and the bottom wall, pushed down against the pocket wall. The chamfer only touches the tablet at its rounded back edge, so felt on the tablet's flat back would miss it. Felt on the chamfer takes up the slack so the tablet doesn't rattle. If it still rattles, use 2 mm felt or foam.
5. Slide the tablet in from the top, screen towards the glass, and plug in the charger through the slot.

## Hardware

- 1 mm self-adhesive felt, about 0.6 m (cut into 4 mm strips).
- 12 mm VHB tape, about 0.9 m.

## Check before printing

All dimensions are parameters at the top of [surface-go-window-frame.scad](surface-go-window-frame.scad); the portrait and half files reuse them.

- `cable_y`: Surface Connect slot position (an estimate, near the bottom of the right edge seen from outside). Measure your tablet.
- Coordinates in the SCAD are as seen from the room (the tablet's back), so the charger edge is the left wall there.
- `btn_x`: power/volume buttons, only cut in the portrait frame (in landscape they are at the open top).
- `clear`, `play_t`: side and front-back clearance.
- `tab_r`: keep at or below the tablet's corner radius.
