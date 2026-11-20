# Fit test reports

Box coordinates: `X` from the shell's left (cable / eyepiece) end, `Y` from the back plate toward the operator, `Z` up from the bottom.

## Report #1: initial shell on camera (2026-11-19)

Tested the initial `80 × 35 × 13 mm` (`slant_rise = 3.0`) open-backed shell ([sony-a6300-fan-fit-test.scad](sony-a6300-fan-fit-test.scad)) on the Sony a6300 without the shoe arm.

### Measurements captured

| Feature | Concrete measurement / finding | Model change applied |
|---|---|---|
| Recess left end & seated X | Left end of recess is **open** (no `5.2 mm` wall; `2 / 4 / 5.3 mm` left ticks all in open air); shell sits at `box_x ≈ 4–5 mm` (`~3–4 mm` spare on right to Fn column) | Opened `recess` left end in [a6300-camera.scad](a6300-camera.scad) (`[0, 88, 2, 47.5]`) |
| Eyecup overhang & right edge | Eyecup overhangs `~2.5–3 mm` past left edge of shell; right edge lands at `box X ≈ 22–23.5 mm` | Matches `top_l` starting at `X = 22.5` |
| Front feature X alignment | Front switch `≈ 23.6`, arm pocket `≈ 37.0`, fan `≈ 57.0`, screw pitch `24.0 mm` (all within `±0.5 mm`) | Confirmed (`arm_xc = 37`, `fan = 57.1`) |
| Hot shoe vs. arm pocket | Unprojected straight-on: `box X ≈ 36–37` (raw `+1.9 mm` was parallax); top-angle check: `~36 mm` raw | Kept `arm_xc = 37` (verify X & Z with arm) |
| Uncovered top band | `14.5 mm` band stays clear (`~1 mm` above screen at pull-out tilt; clear even with lower arm folded) | Confirmed (`tab_band = 14.5`) |
| Dual-hinge arm stop & max tilt | Lower tilt arm stops at **`57–58°` from vertical** (`32–33°` above horiz); max upward LCD tilt is **`~66–68°` from vertical** (cannot tilt further back) | `lcd_arm_max = 58` in [a6300-camera.scad](a6300-camera.scad) |
| Tightest front clearances | At max tilt, arm clears bottom-front corner by **`~0.9 mm`**; screen top-back corner clears front face by **`~0.4 mm`** at `Z ≈ 9.6` | Kept front height `32.0 mm` |
| Bottom rear carrier profile | Hinge pivot ear sits `~39 mm` below top at `Y = 0`; inner bracket slopes `~28°`, leaving `~4 mm` unused at the back | Raised `box_h = 37.5`, `slant_rise = 5.5` (`22.2°` bevel) |
| Bottom bracket & flex ribbon | Ribbon at `box X ≈ 14–23 mm`; bracket step at **`box X ≈ 36.7 mm`**, wide cut-back running to `~78.2` | Shifted `bot_x0` to `36.5`; widened camera notch |
| Right exhaust clearance | `7.8 mm` of `13 mm` wall sits proud of `5.2 mm` recess; slots (`Y = 5.6..11.4`) 100% clear | Confirmed |
| Screen latch pin | `box X ≈ 40` (`~1.5–2.5 mm` right of shoe center), width `~5 mm`, **`~1 mm` from plate**, **`~2–3 mm` thick** (`Y ≈ 1..3.8`), hang `~1.2 mm` | Added open hook channel (`X ≥ 34`, `Y ≤ 4.1`, `2 mm` drop) |

### Takeaways & changes applied

- **Open left recess:** nothing on the body stops `-X` slide-out, so lateral retention relies on the shoe arm; the right end slides in first over the hinge-bracket screws using safe leading radii (`lead_r = 1.2`, `lead_r_back = 0.8` on box / `0.5` on fit test).
- **Latch hook channel (no push/snap):** an open top-back channel (`X ≥ 34`, `Y ≤ 4.1`, `latch_drop = 2.0`) glides straight underneath the latch pin and hooks its front face at `Y = 4.1` against `+Y` wobble without stressing the tab or fighting the shoe arm's X alignment.
- **Taller back + steeper bevel:** `box_h = 37.5`, `slant_rise = 5.5` (`22.2°`) uses the `~4 mm` spare height at `Y = 0` to match the opened screen carrier while preserving the `32.0 mm` front height and anchoring the arm pocket from the top (`pin_from_top = 10.0`).
- **Bottom bleed alignment:** `bot_x0 = 36.5` puts all 4 bottom-back slots inside the tilt bracket's open cut-back.
- **Left-wall Off/On switch:** dropped the front 3-speed `SS13D07` + `1N4001` diodes in favor of a full-5 V `SS12D00G4` Off/On slide switch above USB-C on the open left wall (no front switch cradle, single-speed max airflow).
- **Print note:** slight elephant's foot appeared along the bed-face perimeter (watch pocket/slot mouths on the final box print).

## Report #2: Fit Test 2 shell on camera (2026-11-20)

Tested the `80 × 37.5 × 13 mm` (`slant_rise = 5.5`, `22.2°` single bevel) shell. **It fit well.** Two photos came back: a
side view from the cable end with the screen pulled out, and a view from straight below. The findings are about the
bottom: how much room there is under the shell, and where the screen's tilt bracket covers it.

### Measurements

Read off the two photos against the shell's own marks (the `5 mm` bottom ruler, the `13 mm` depth and the `+2 / +4 mm`
corner ticks), so each is good to about **`± 0.5 mm`** and angles to **`± 2°`**. Coordinates are the box's, as above, with
`Z = 0` at the shell's bottom plane (its back-bottom corner sat at `Z = 0.2`). To place them on the camera model:
camera `x` = box `X + 4`, camera `z` = box `Z + 9.7`.

| ID | What | Value (box coordinates) | Photo |
|---|---|---|---|
| M1 | Lower hinge pivot centre | `Y = 2.0`, `Z = −3.0` (`3.2` below the shell's back-bottom corner) | side |
| M2 | Hinge knuckles | radius `≈ 2.05`, top at `Z ≈ −0.95` (report #1 put it nearer `−1.5`). Left knuckle at `X ≈ −3.3 .. −1.7`, just outside the shell's left end; right knuckle at `X ≈ 78 .. 80`, under its right end | side, bottom |
| M3 | Bracket plate's box-facing face | `1.15` off the pivot axis, on the box side. The plate is the part against the camera when the screen is closed; the side flanges point away from the box | side |
| M4 | Bracket angle at its stop | `30°` above horizontal (`60°` from vertical); single readings ran `28.7 .. 31.6°`. Report #1 read `57–58°` from vertical | side |
| M5 | Side flange width | `≈ 3.9` | side |
| M6 | Bracket span | flanges at `X ≈ −2.5` and `X ≈ 76.8 .. 78.2` | bottom |
| M7 | Cut-back window, in `X` | `X = 36.2 .. 76.8`: from the step in the plate (corner radius `≈ 2`) to the right flange. Report #1 had `36.7 .. 78.2` | bottom |
| M8 | Cut-back window, in `Y` | the plate's edge is `6.7` from the back plate, and its shadow starts at `≈ 6.0`. Nearer the plate than that, the shell's bottom is in plain view from below | bottom |
| M9 | Left relief | quarter-round cut at the plate's lower-left corner, `X ≈ 2.4 .. 9.5`, up to `Y ≈ 6.6` at its left side | bottom |
| M10 | Left section | for `X ≈ 9.5 .. 36.2` the plate reaches the pivot line (`Y ≈ 1.4`) and covers the whole bottom. Flex cover panel on its LCD side at `X ≈ 9.5 .. 22.3`; flex ribbon at the pivot line, `X ≈ 11 .. 20` | bottom |
| M11 | Camera's bottom-back edge | at `Y ≈ −0.4`: there is no frame lip under the screen, so the recess is open at the bottom as well as at the left | bottom |
| M12 | Gap, shell to bracket | `≈ 1.0` vertical (`≈ 0.9` square to the bracket) under the front-bottom corner, growing to `≈ 2.3` at `Y = 5`, because the `22.2°` bevel is shallower than the bracket (M4) | side |

Checks on the readings: the bottom ruler's ticks land at `15.6 px/mm` from `X = 5` to `X = 75` with no drift, and the ribs
between the fake bottom slots read `X ≈ 46 / 56 / 66` against `46.3 / 56.6 / 67.0` in the model.

### Where each one is used

| Measurement | Parameter | File |
|---|---|---|
| M1, M2, M3, M5, M6 | `lcd_hinge1`, `lcd_knuckle_r`, `lcd_arm_top`, `lcd_arm_flange`, `lcd_arm_x` | [a6300-camera.scad](a6300-camera.scad) |
| M4 | `lcd_arm_max = 60` | [a6300-camera.scad](a6300-camera.scad) |
| M4 | `slant_a = 30` | [sony-a6300-fan.scad](../sony-a6300-fan.scad) |
| M7, M8 | `lcd_arm_cut` | [a6300-camera.scad](a6300-camera.scad) |
| M7, M8 | `bot_win = [36.2, 76.8, 6.7]` | [sony-a6300-fan.scad](../sony-a6300-fan.scad) |
| M9, M10, M11 | `lcd_arm_relief`, `lcd_arm_cover`, `recess` | [a6300-camera.scad](a6300-camera.scad) |
| M1–M4, M7, M8 | asserts on the bevel gap, the heel above the knuckles, and the bottom slots staying inside the window | [sony-a6300-fan-scene.scad](sony-a6300-fan-scene.scad) |

The scene now reports a `0.8 mm` gap under the bevel against the `≈ 1.0 mm` read in the photo (M12); the difference is
inside the tolerance of M1, M3 and M4.

### Takeaways & changes applied

- **The space under the shell is small.** The bracket's plate lies right under the bevel, so the room is a wedge: `≈ 1 mm`
  at the front, `≈ 2.3 mm` at mid-depth (M12). At the plate the knuckles sit `≈ 1 mm` under the back-bottom corner (M2),
  and the whole box passes over the left one as it slides in, so the back edge cannot drop.
- **Bottom parallel to the bracket:** the bevel is now `slant_a = 30°` (M4), turned about the same front-bottom corner
  that fit in both tests, behind a flat heel from the plate to `Y = 3.47`. It is up to `1.4 mm` lower at the knee than
  the old bevel and leaves the same gap to the bracket along its whole length: the seat for a `0.5–1 mm` felt pad, so
  the box rests on the bracket on purpose instead of nearly touching it at one corner.
- **Bottom slots inside the window:** `X = 37.0 .. 76.0` (`0.8 mm` inside M7 at each end; the old `76.8` end was level with
  the right flange) and `Y = 1.6 .. 6.0` (inside M8). With nothing under them, they now count as free-air exhaust:
  `424 mm²` in total (right `158` + top `110` + bottom `156`), up from `267 mm²`.
- **Camera model:** the tilt bracket is redrawn from M1–M11. The pivot had been `2.2 mm` too low relative to the box, and
  the bracket was drawn `64 mm` wide with a solid bar instead of a plate with flanges.

Not reported for this test, and still open: the shoe arm's lug fit and hold, the latch hook channel, and the reach to
the switch.

## Fit Test 2 measurement sheet

The Fit Test 2 shell had the real arm pocket + fused top
bearing boss, beveled left-wall Off/On switch cutout above USB-C, staggered `1 / 2 / 3 / 4 / 5.3 mm` side depth grooves,
`5 / 10 mm` X-rulers (top-front and bottom-back), and `+2 / +4 mm` left bottom-front Z-ticks. Fill in the `Measured` column
is filled in from report #2; the empty rows carry over to Fit Test 3:

| Item | Model value | How to measure on Fit Test 2 | Measured |
|---|---|---|---|
| Shoe arm lug X & Z alignment | `arm_xc = 37`, `pin_from_top = 10.0` | Slide printed arm into real Fit Test 2 pocket + boss; read any X offset off the top `5 / 10 mm` X-ruler | |
| Shoe arm `-X` slide hold & friction | `foot_rib_h = 0.2 mm` | With arm seated, pull shell gently left (`-X`); note shoe friction and any lateral play | |
| Latch pin exact `Y0..Y1` & hang | `Y = 1.0..3.8`, hang `~1.2`, channel `Y = 0..4.1` | Check `Y = 4.1` rim hooks pin cleanly with zero bind; read pin depth off `1 / 2 / 3 / 4 / 5.3` side ticks and whether `+Y` wobble stops | |
| `37.5 / 5.5` bevel clearance | `box_h = 37.5`, `slant_rise = 5.5` (`22.2°`) | Tilt screen through full travel; check back hinge ear & front clearance using `+2 / +4 mm` left Z-ticks | Fits. `≈ 1.0 mm` under the front-bottom corner, knuckle top `≈ 1.15 mm` under the back-bottom corner (M2, M12) |
| Bottom bracket step & ribbon | `bot_x0 = 36.5` (`X = 36.5..76.8`) | Take a bottom photo; read exact ribbon edges & bracket step against the bottom-back `5 / 10 mm` X-ruler | Step at `X = 36.2`, right flange at `76.8`, plate edge at `Y = 6.7`; ribbon at `X ≈ 11 .. 20` (M7, M8, M10) |
| Left-wall Off/On switch & USB-C exit | `sw_yc = 7.05`, `sw_zc = 32.0` (`Y = 5.0..9.1`) | Feel thumb reach to the left-wall switch cutout above USB-C; check right-angle USB-C plug clearance past HDMI/MULTI door & switch knob | |

## Report #3: Fit Test 3 shell and the first shoe arm (2026-11-20)

Tested the Fit Test 3 shell (flat heel + `30°` bevel) with the first print of the shoe arm. Three photos came back: from
the cable side, a close-up of the pocket from the front-left, and from the grip side. **The shell sits well; the arm
does not seat: its drop-tab hangs too low.**

What blocks it: the thickened part of the tab, which should end `0.8 mm` above the box top, ends about `2 mm` below it and
butts against the top of the box's front face. That holds the tab `≈ 4 mm` off the face, with the lug's tip at the bottom
edge of the pocket instead of inside it.

### Measurements

Read off the photos against the printed parts' own sizes (`4 mm` and `8.2 mm` tab thickness, the `14.5 mm` band groove,
the `13 mm` shell depth). Same coordinates and IDs as report #2.

| ID | What | Value | Photo |
|---|---|---|---|
| M13 | Shoe arm against the shell, vertically | the arm hangs **`2.8–3.4 mm` lower** than modelled: `2.8` in the front-left close-up, `3.1` from the grip side, `3.4` from the cable side (the least reliable: the arm is `32 mm` behind the shell's left wall there, so its position is corrected for perspective). So the top deck that carries the hot shoe is `≈ 63.8 mm` above the base, not Sony's overall `66.9 mm`, which includes the dials | all three |
| M14 | Gap under the `30°` bevel | the bevel runs parallel to the bracket along its whole length (`slant_a = 30` holds), `≈ 0.3–0.5 mm` above it. The model has `0.8`, and report #2 read `≈ 1.0` under the old shell's front corner | cable side |

Caveat on both: they are relative to the shell as it sat. The rubber eyecup's underside is `≈ 1.5 mm` above the shell's
top in the cable-side photo, so the eyecup is not what stops the shell; whether the shell was pushed fully up against
the recess's top edge is not known. If it was sitting low, M13 is larger and M14 smaller by the same amount.

Reported by hand, not measured:

- **X alignment is right.** With the shell pushed fully to the right, the arm's tab lines up with the pocket; only its
  length stopped it going in.
- **The shell sits well without the arm.** The one free direction is the sideways slide toward the open left end, and
  an indentation in the magnesium body limits that somewhat. Where that indentation is and how far the shell can
  still slide have not been recorded.

### Where each one is used

| Measurement | Parameter | File |
|---|---|---|
| M13 | `top_z = body[1] - 2.9` (the shoe floor; the arm's drop follows it) | [a6300-camera.scad](a6300-camera.scad) |
| M13 | `sock_drop = 0.8` (room under the lug in the pocket) | [sony-a6300-fan.scad](../sony-a6300-fan.scad) |
| M14 | pad thickness in the README; no parameter changed | [README.md](../README.md) |

### Takeaways & changes applied

- **Arm `2.9 mm` shorter:** the drop from the bridge to the tab's end goes from `39.3` to `36.4 mm`. `2.9` is the low end of
  M13 on purpose: an arm that is slightly too long still seats, one that is too short lifts the lug into the pocket's
  ceiling.
- **Pocket `0.8 mm` taller, downward** (`6.5 × 7.3 mm`), in the box and the shell, so the lug seats anywhere in the M13
  range: from `0.15 mm` high (inside the `0.25 mm` clearance) to `0.5 mm` low.
- **Bevel confirmed, pads thinner:** the `30°` bottom is parallel to the bracket. With `≈ 0.3–0.5 mm` under it, the pad for
  the bevel is thin felt or tape of that thickness, not `1 mm`.
- **Is the arm needed? Open.** The empty shell stays put without it. The real box is heavier, vibrates, and has a
  USB-C cable on its left wall that pulls it toward the open left end, the one direction nothing blocks. The arm
  stays in the design until the wired box has been tried without it (`arm_mount = false` is the arm-less box).
- **Screen:** the tab's end nearly touched the tilted screen's top edge in the grip-side photo. That was the `3 mm` of
  extra length; the model's `2.9 mm` clearance at `65°` applies once the arm is the right length.

## Fit Test 3 measurement sheet

The Fit Test 3 shell had the box's new bottom: the flat heel, the `30°` bevel
and the bottom slot marks at `X = 37.0 .. 76.0`. Everything else is as in Fit Test 2, including the measuring marks the real
box will not have (side depth grooves, rulers, corner ticks). It was printed with the first shoe arm; `Measured`
is filled in from report #3:

| Item | Model value | How to measure on Fit Test 3 | Measured |
|---|---|---|---|
| Slide-in past the bracket | bevel `≈ 0.8–1.0 mm` above the plate from `Y = 3.5` to the front | With the screen pulled fully out, slide the shell in from the left. It must not drag on the bracket plate. This is the main risk: at mid-depth the old bevel had `≈ 2.3 mm` here, and anything standing up from the plate now has `≈ 1 mm` | Seated in all three photos; no drag reported |
| Gap under the bevel, front and back | even, `0.8–1.0 mm` (M4, M12) | Side photo as in report #2, or slip card or felt of known thickness under the front edge and at mid-depth. An uneven gap corrects `slant_a` | Parallel to the bracket front to back; `≈ 0.3–0.5 mm` (M14) |
| Heel over the knuckles | `0.95 mm` above the knuckle top (M2) | Check the right end over the right knuckle, and the left knuckle as the shell slides over it | Clear of the left knuckle by `≈ 1.5 mm` in the side photo; right end not shown |
| Pad seat | `0.5–1 mm` felt on the bevel, `Y ≈ 7.5 .. 12.5` | Stick two felt pads on the bevel near `X ≈ 15` and `X ≈ 65`; the screen must still reach its stop, and the shell should stop rattling | Not tested. With M14, a `1 mm` pad will not fit |
| Bottom slot marks in the window | `X = 37.0 .. 76.0`, `Y = 1.6 .. 6.0` (M7, M8) | Photo from straight below: all four marks fully visible, clear of the step, the plate edge and the right flange | No photo from below |
| Shoe arm lug X & Z alignment | `arm_xc = 37`, `pin_from_top = 10.0` | Carried over from Fit Test 2 | **Z: arm `2.8–3.4 mm` too low, does not seat (M13).** X: in line with the pocket when the shell is pushed fully right (reported by hand) |
| Shoe arm `-X` slide hold & friction | `foot_rib_h = 0.2 mm` | Carried over from Fit Test 2 | Not testable until the arm seats |
| Latch pin `Y0..Y1` & hang | channel `Y = 0..4.1` | Carried over from Fit Test 2: read the pin's depth off the `1 / 2 / 3 / 4 / 5.3` side grooves; check the `Y = 4.1` rim hooks it with zero bind and stops `+Y` wobble | Not reported |
| Left-wall Off/On switch & USB-C exit | `sw_zc = 32.0`; the USB-C port is `0.27 mm` lower than in Fit Test 2 | Carried over from Fit Test 2 | Not reported |

## Fit Test 4 measurement sheet

[sony-a6300-fan-arm.scad](../sony-a6300-fan-arm.scad) is `2.9 mm` shorter, and the pocket in
[sony-a6300-fan-fit-test.scad](sony-a6300-fan-fit-test.scad) is `0.8 mm` taller. The shell is otherwise the Fit Test 3
one, so the arm can be tried against the Fit Test 3 shell first: only the pocket's extra room is missing.

| Item | Model value | How to measure on Fit Test 4 | Measured |
|---|---|---|---|
| Arm seats fully | tab `0.2 mm` from the front face; thick part ends `0.8 mm` above the box top | Slide the arm into the shoe to its stop. If it stops early, note what touches: the thick part on the box top (arm still too long), the lug on the pocket's ceiling (too short), or the foot at the end of the shoe | |
| Lug height in the pocket | lug top `0.25 mm` under the pocket's ceiling, `1.05 mm` spare below | Look into the pocket from the front-left as in report #3, or measure the box top to the underside of the arm's bridge: `20.4 mm` in the model | |
| Lug X alignment | `arm_xc = 37` | Read any sideways offset off the top `5 / 10 mm` ruler | |
| Shoe hold and `-X` slide | `foot_rib_h = 0.2 mm` | With the arm seated, pull the shell gently left; note shoe friction and any play | |
| Tab above the tilted screen | `2.9 mm` at `65°` | Tilt the screen up fully; the tab's end must stay clear | |
| Thin pad on the bevel | `0.3–0.5 mm` (M14) | Stick tape or thin felt on the bevel near `X ≈ 15` and `X ≈ 65`; the screen must still reach its stop | |
| Bottom slot marks in the window | `X = 37.0 .. 76.0`, `Y = 1.6 .. 6.0` (M7, M8) | Photo from straight below | |
| Latch pin `Y0..Y1` & hang | channel `Y = 0..4.1` | Read the pin's depth off the side grooves; check the `Y = 4.1` rim hooks it with zero bind | |
| Left-wall Off/On switch & USB-C exit | `sw_zc = 32.0` | Thumb reach to the switch mark; right-angle USB-C plug past the HDMI/MULTI door | |
