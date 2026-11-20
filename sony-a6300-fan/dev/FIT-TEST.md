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

## Fit Test 2 measurement sheet

[sony-a6300-fan-fit-test.scad](sony-a6300-fan-fit-test.scad) is updated for Fit Test 2 with the real arm pocket + fused top
bearing boss, beveled left-wall Off/On switch cutout above USB-C, staggered `1 / 2 / 3 / 4 / 5.3 mm` side depth grooves,
`5 / 10 mm` X-rulers (top-front and bottom-back), and `+2 / +4 mm` left bottom-front Z-ticks. Fill in the `Measured` column
after printing it alongside [sony-a6300-fan-arm.scad](../sony-a6300-fan-arm.scad):

| Item | Model value | How to measure on Fit Test 2 | Measured |
|---|---|---|---|
| Shoe arm lug X & Z alignment | `arm_xc = 37`, `pin_from_top = 10.0` | Slide printed arm into real Fit Test 2 pocket + boss; read any X offset off the top `5 / 10 mm` X-ruler | |
| Shoe arm `-X` slide hold & friction | `foot_rib_h = 0.2 mm` | With arm seated, pull shell gently left (`-X`); note shoe friction and any lateral play | |
| Latch pin exact `Y0..Y1` & hang | `Y = 1.0..3.8`, hang `~1.2`, channel `Y = 0..4.1` | Check `Y = 4.1` rim hooks pin cleanly with zero bind; read pin depth off `1 / 2 / 3 / 4 / 5.3` side ticks and whether `+Y` wobble stops | |
| `37.5 / 5.5` bevel clearance | `box_h = 37.5`, `slant_rise = 5.5` (`22.2°`) | Tilt screen through full travel; check back hinge ear & front clearance using `+2 / +4 mm` left Z-ticks | |
| Bottom bracket step & ribbon | `bot_x0 = 36.5` (`X = 36.5..76.8`) | Take a bottom photo; read exact ribbon edges & bracket step against the bottom-back `5 / 10 mm` X-ruler | |
| Left-wall Off/On switch & USB-C exit | `sw_yc = 7.05`, `sw_zc = 32.0` (`Y = 5.0..9.1`) | Feel thumb reach to the left-wall switch cutout above USB-C; check right-angle USB-C plug clearance past HDMI/MULTI door & switch knob | |
