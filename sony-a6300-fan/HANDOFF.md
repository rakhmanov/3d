# Handoff: Sony a6300 rear cooling fan (2026-11-18)

State of the design, what is known, what is wrong, and what to do next. Nothing has been printed.
The README has the parts, BOM, wiring and the measurement table.

## Goal

Keep an a6300 recording 4K for long takes (the 30-min cap is removed with OpenMemories: Tweak) by blowing
air onto the magnesium back plate. The box sits in the recess the screen leaves when it is tilted up.
It needs 5 V from USB-C and has Low / Off / High.

## What is solid

- **Space on the camera, from a cardboard test on the real body.** A block 80 mm wide, 35 mm tall against
  the plate and 32.5–33 mm at the outside face fits under the eyepiece with the screen tilted up. The bottom
  is bevelled straight from the plate so it clears the screen's hinge arm. About 14 mm of depth is free
  before the screen touches. The top 14.5–15 mm under the eyepiece is free at any depth.
- **Camera facts** (calipers, ±0.3). Screen recess 5.2 deep (5.19–5.51). Screen 6.3–6.4 thick. Eyepiece
  sticks out 9.92 from the plate. Shoe open end 5.88 in from the back edge, with a small hump in between.
- **Bought parts at real sizes.**
  - Adafruit 4090 USB-C board, from its Eagle file.
  - 3007 fan, 30 × 30 × 7, holes on 24 × 24.
  - SS13D07 1P3T slide switch, 12.7 × 4.5 × 4.7.
  - 2 × 1N4001 diodes for Low.
- **Printability.** Box, arm and fit-test shell export manifold and print without supports. Checked with
  `tools/stl-check.py`.

## What is wrong or unproven, most serious first

1. **The screen covers the lower part of the box's front.** In the shooting position the screen's top edge
   rests on the front face about 15 mm below the top. Below that line there is a wedge of space under the
   screen, open at both sides. The renders don't show this: `a6300-camera.scad` draws the screen flipped flat
   because its linkage isn't modelled.
   Consequences:
   - **Switch.** It sits low on the front next to the fan (`sw_zc = 11`), where the screen hides it. It must
     move: to the left side (cable side), or into the top band.
     - The left side is out with the current USB-C board: the Adafruit 4090 is 20.3 mm tall and the
       switch needs about 15 mm more.
     - So the left side needs a smaller board with the connector on its short edge and 5.1 kΩ on CC1/CC2.
   - **Fan intake.** Only the top ~13 mm of the grille is in free air. The rest draws through the wedge under
     the screen. Airflow will be lower than the fan's rating, by an unknown amount. Keep the grille above
     the line where the screen rests.
2. **Exhaust is mostly blocked.** The outlet slots run along the back edge of every wall, within 4.4 mm of
   the plate (`air_gap`). The recess is 5.2 mm deep, so the side slots face the recess walls and the top
   slots face the eyepiece and the camera frame. Only the bottom is really open. Outlets have to sit further
   than 5.2 mm from the plate: on the right end and along the bottom. Keep them away from the wedge under
   the screen so the fan doesn't pull its own warm air back in.
3. **Holding it on the camera is not settled.**
   - **Current plan, no holder:** the tilted-up screen presses the box against the plate, and the recess
     walls and the eyepiece stop it moving sideways and up. That means shooting with the screen up.
     - **Risk:** it falls out when the screen is moved.
     - **Cheap backup:** a thin micro-suction or removable adhesive pad on the box's back feet, or a cord
       to a strap lug.
   - **Option: screwed shoe arm** (`sony-a6300-fan-arm.scad`). The foot goes in the flash shoe, a bridge
     runs over the top, and a tab screws to the box's front in the top band (2 × M3 into heat-set inserts).
     It works, but it's two parts and screws.
   - **Option, not built yet: one-piece slide-in.** The arm is part of the box: the front plate continues
     up as a flat strip, then a bridge and a foot.
     - **How it goes on:** the shoe and the recess are entered in the same direction. Push the whole thing
       toward the lens; the foot slides into the shoe as the box seats on the plate, and the plate is the
       stop.
     - **Printing:** front face down, arm flat on the bed, bridge rising as a column. The foot needs a 45°
       lead-in. The bridge's layers run across its load, so make it thick (about 12 × 6).
     - **Needs checking:** that the screen can be held out of the way while sliding it in.
4. **Positions read from photos are ±2 mm.** Shoe centre ~41 mm from the eyepiece-side end, flash and MENU
   buttons ~62 and ~73 mm, recess right edge ~87 mm. They matter for the arm only.
5. **Fan noise and airflow aren't verified.**
   - The WINSINN 3007 hydraulic publishes no airflow or noise figure. A comparable fan family suggests
     ~28 dBA at full speed, ~21 dBA on Low.
   - Low mode (two diodes, ~3.4 V) may not start every fan. Fallback: one diode.
6. **The fan blows straight onto a 4.4 mm gap.** Fine on paper, but untested.
7. **CI side effect.** `.github/matrix/generate.py` renders an STL and PNG for every committed `.scad`.
   Merging this folder to `main` would also make STLs of the display-only files: `-scene`, `a6300-camera`,
   `-fit-test`, and the arm if it's dropped. Exclude them before merging.

## Files

| File | Role |
|---|---|
| `sony-a6300-fan.scad` | Box. All parameters at the top. `orient = "print"` (front face down) or `"display"` |
| `sony-a6300-fan-arm.scad` | Optional screwed shoe arm. Includes the box file for shared numbers |
| `sony-a6300-fan-fit-test.scad` | 0.8 mm shell with the box's outside shape and depth marks. Print this before the box |
| `sony-a6300-fan-scene.scad` | Display only: box, arm, parts and wires on the camera. `-D cutaway=true` |
| `a6300-camera.scad` | Display model: Sony's dimensions plus the measurements above. Screen linkage not modelled |

Render with the CI image (see the repo's AGENTS.md). Preview mode (no `--render`) keeps the colours.

## Next steps

1. Model the screen in its shooting position: a keep-out solid from the cardboard test, or the real linkage
   (hinge positions and arm length, 5 caliper numbers). Make the scene check that nothing sits behind it.
2. Move the outlets out of the recess and keep the grille above the screen line. Then move the switch:
   left side with a smaller USB-C board, or the top band.
3. Print the fit-test shell; check the fit and that the screen holds it.
4. Decide on holding: no holder plus a backup pad, the screwed arm, or the one-piece slide-in.
5. Print the box, wire it, and test: 4K, Auto Pwr OFF Temp = High, dummy battery. Log the time to the overheat
   warning with and without the fan, at the same room temperature.
