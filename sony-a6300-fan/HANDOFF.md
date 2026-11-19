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
- **Dual-hinge LCD linkage modelled in `dev/a6300-camera.scad` and checked in `dev/sony-a6300-fan-scene.scad`.**
  Fitted ±1–2 mm from the side/rear photos and cardboard test (`lcd_arm_len = 29.5`, stops at `54°`,
  `lcd_pivot_from_top = 12.0`). Automated scene checks pass: at `lcd_tilt = 65°` (`arm = 54°`), front
  clearance `+1.5 mm`, bevel clearance `+0.5 mm`, switch `+6.3 mm` above the LCD; at `90°`, front
  clearance `+0.4 mm`.
- **Unblocked exhaust and open grille in `sony-a6300-fan.scad`.** Fan shifted left (`fan_x = 42.1`) to open
  a `6 mm` right exhaust duct; left, top, and right walls keep a solid `5.6 mm` back rim inside the `5.2 mm`
  recess, while `495 mm²` of unblocked exhaust (`249 mm²` side/top at `Y = 5.6..11.4` + `246 mm²` bottom-back
  at `Y = 0..4.4` behind the hinge-arm baffle; `453 mm²` with `arm_mount = true`) matches the `503 mm²` fan
  free area. Single-ring open grille leaves the upper blade arc open; lower bay divider stops at `usb_zc`.
- **Front-scribed fit-test shell (`dev/sony-a6300-fan-fit-test.scad`).** Adds front-face 45° V-grooves for
  the `14.5 mm` screen-free band, switch slot outline, and fan grille circle alongside the side depth V-grooves.
- **Printability.** Box, arm and fit-test shell export manifold and print without supports. Checked with
  `tools/stl-check.py`.

## What is wrong or unproven, most serious first

1. **The screen covers the lower part of the box's front.** In the modelled dual-hinge shooting pose
   (`lcd_tilt = 65°`), `12.0 mm` of the `28 mm` grille sits completely above `lcd_tf` (`17.8 mm` above
   `lcd_tb`); at `90°`, `16.5 mm` / `22.9 mm` is clear above the screen. The rest draws through the
   open-sided wedge behind the screen, so airflow will be lower than the fan's rating by an unknown amount.
   Consequences:
   - **Switch.** Placed in the top band, left of the fan (`sw_from_top = 7`, `6.3 mm` above the screen at
     `65°`), about `7.5 mm` right of the rubber eyecup (`3.1 mm` proud of it). Check with the fit-test shell
     that a finger reaches it comfortably past the eyecup and diopter wheel.
2. **Exhaust blockage is fixed in CAD, but airflow/recirculation isn't tested on hardware.** Side and top
   outlets now sit past the `5.2 mm` recess (`Y = 5.6..11.4`) and the `10` bottom-back slots sit behind the
   solid bevel that baffles them from the front intake wedge; thermal performance and lack of warm-air
   recirculation remain to be measured on the camera.
3. **Holding it on the camera is not settled.**
   - **The screen limits how the box goes in.** In the photos the screen is tilted up as far as it goes, and
     that still doesn't leave room to push the box straight toward the plate. So the box goes in sideways
     or with the screen down. Once it's in, flip the screen up and it clamps the box.
   - **Current plan, no holder:** the tilted-up screen presses the box against the plate, and the recess
     walls and the eyepiece stop it moving sideways and up. You shoot with the screen up. The arm's screw
     bosses are off (`arm_mount = false`).
     - **Risk:** it falls out when the screen is moved.
     - **Cheap backup:** a thin micro-suction or removable adhesive pad on the box's back feet, or a cord
       to a strap lug.
   - **Option: screwed shoe arm** (`sony-a6300-fan-arm.scad`). The foot goes in the flash shoe, a bridge
     runs over the top, and a tab screws to the box's front in the top band. The arm file turns the
     bosses on, but they collide with the switch's new spot (the file warns). One of them must move first.
   - **Ruled out: a one-piece slide-in** (arm built into the box, pushed toward the lens so the foot enters
     the shoe as the box seats). The screen can't get far enough out of the way. A one-piece holder would
     need a sideways entry, e.g. a dovetail.
4. **Positions read from photos are ±1–2 mm.** Dual-hinge linkage (`lcd_arm_len ~29.5`, `lcd_arm_max ~54°`,
   `lcd_pivot_from_top ~12`), shoe centre (`~41 mm`), flash (`~62`), MENU (`~73`), AF/MF-AEL (`~88..99`),
   and recess right edge (`~87 mm`). Verify the linkage clearances with the fit-test shell; the shoe and
   button positions matter for the arm only.
5. **Fan noise and airflow aren't verified.**
   - The WINSINN 3007 hydraulic publishes no airflow or noise figure. A comparable fan family suggests
     ~28 dBA at full speed, ~21 dBA on Low.
   - Low mode (two diodes, ~3.4 V) may not start every fan. Fallback: one diode.
6. **The fan blows straight onto a 4.4 mm gap.** Fine on paper, but untested.
7. **CI side effect.** `.github/matrix/generate.py` renders an STL and PNG for every committed `.scad`
   outside `dev/`. Non-normally-printable files (`dev/sony-a6300-fan-scene.scad`, `dev/a6300-camera.scad`,
   `dev/sony-a6300-fan-fit-test.scad`, and `dev/scene-*.png`) now live in `dev/` and are skipped; remove
   `sony-a6300-fan-arm.scad` before merging to `main` if the shoe arm is dropped.

## Files

| File | Role |
|---|---|
| `sony-a6300-fan.scad` | Box. All parameters at the top. `orient = "print"` (front face down) or `"display"` |
| `sony-a6300-fan-arm.scad` | Optional screwed shoe arm. Includes the box file for shared numbers |
| `dev/sony-a6300-fan-fit-test.scad` | 1.2 mm shell with the box's outside shape, side depth V-grooves, and front scribe V-grooves. Print this before the box |
| `dev/sony-a6300-fan-scene.scad` | Display only: box, arm, parts and wires on the camera, plus LCD clearance checks. `-D cutaway=true` |
| `dev/a6300-camera.scad` | Display model: Sony's dimensions, caliper measurements, and photo-fitted dual-hinge LCD linkage |

Render with the CI image (see the repo's AGENTS.md). Preview mode (no `--render`) keeps the colours.

## Next steps

1. Print the fit-test shell (`dev/sony-a6300-fan-fit-test.scad`, ~15 min) and check it on the camera: recess fit,
   bottom-bevel clearance against the hinge arm, that the tilted screen clamps the box without crossing the
   front scribe line, switch reach beside the eyecup/diopter, and the photo-fitted linkage clearances.
2. Decide on holding: no holder plus a backup pad, or the screwed arm (move the switch or the bosses).
3. Order parts, print the box, wire it, and test: 4K, Auto Pwr OFF Temp = High, dummy battery. Log the time
   to the overheat warning with and without the fan, at the same room temperature.
