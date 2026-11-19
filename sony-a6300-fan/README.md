# Sony a6300 rear cooling fan (DRAFT)

A small box that sits in the screen recess on the camera's back, under the eyepiece, with the screen
tilted out, and blows air onto the magnesium back plate for long 4K takes. It runs from USB-C on the
cable side and has a thumbnail slide switch: Low / Off / High. A second part, a tool-free shoe arm,
slides into the flash shoe after the box is seated and locks it in place with zero screws or inserts.
The box size comes from a cardboard test on the real camera; the shoe and button positions from caliper
readings and photos (±2 mm). **Not printed yet.**

**Status and known problems: see [HANDOFF.md](HANDOFF.md).** The camera's dual-hinge screen linkage is now modelled and checked in the scene, the exhaust outlets sit outside the 5.2 mm recess (`467 mm²` unblocked vs `503 mm²` fan free area), and Option #1 from [dev/MOUNTING-NOTES.md](dev/MOUNTING-NOTES.md) (tool-free pin-and-socket slide-on shoe arm, with micro-suction + screen clamp as a zero-hardware fallback) is implemented.

| On the camera | Inside (front cut away) | Side | Arm and shoe |
|---|---|---|---|
| ![](dev/scene-iso.png) | ![](dev/scene-cutaway.png) | ![](dev/scene-side.png) | ![](dev/scene-mount.png) |

| File | What |
|---|---|
| [sony-a6300-fan.scad](sony-a6300-fan.scad) | The printable box ([preview](sony-a6300-fan.png)). Parameters at the top |
| [sony-a6300-fan-arm.scad](sony-a6300-fan-arm.scad) | Second printable part: tool-free pin-and-socket slide-on shoe arm ([preview](sony-a6300-fan-arm.png)). Locating lug engages the box's front pocket on `-Y` slide-in (zero screws/inserts). `top_mount = "shoe"`, `"quarter"` or `"none"` |
| [dev/sony-a6300-fan-fit-test.scad](dev/sony-a6300-fan-fit-test.scad) | Thin shell with the box's outside shape and front-face V-groove scribe marks (`14.5 mm` band, switch slot, arm pocket, fan grille), to try on the camera first |
| [dev/sony-a6300-fan-scene.scad](dev/sony-a6300-fan-scene.scad) | Display only: the box and arm on the camera with the fan, switch, diodes, USB-C board, wires and cable. `-D cutaway=true` |
| [dev/a6300-camera.scad](dev/a6300-camera.scad) | Display model of the a6300 from Sony's dimensions plus measurements of a real body and a photo-fitted dual-hinge LCD linkage (arm stops at `~54°`, ±1–2 mm) |
| [dev/MOUNTING-NOTES.md](dev/MOUNTING-NOTES.md) | Five brainstormed tool-free mounting options, physical constraints, and 3-criterion ranking |

## Parts

| Part | Exact item | Size used in the model | Notes |
|---|---|---|---|
| Fan | **WINSINN 3007 5V, hydraulic bearing**, XH2.54 plug, 300 mm leads (Amazon) | 30 × 30 × 7, holes on 24 × 24, M3 self-tapping | 8500 rpm. Hydraulic bearings are quieter than ball bearings and fine with the axis horizontal. WINSINN publishes no airflow or noise figure. The Sofasco table below suggests ~28 dBA at full speed, so plan on quiet mode |
| Fan, ball-bearing alternative | GDSTIME 3007 5V dual ball (Amazon) | 30 × 30 × 7 | 9000 rpm, 4.1 CFM, "25 dBA ±10 %", 0.15 A. Longest life, but more bearing tick and hum |
| Fan, best (if you find it) | Sunon MF30060V2-1000U-A99 | 30 × 30 × 6.5, fits the same box | 3.7 CFM at 15.7 dB(A). Distributors only (DigiKey, Mouser), often out of stock |
| USB-C | **Adafruit 4090**, "USB Type C Breakout Board – Downstream Connection" | PCB 20.32 × 13.97 × 1.6, connector centred on the long edge, 2 × Ø2.5 holes 15.24 apart, 2.54 in from the connector edge | Numbers from Adafruit's Eagle board file. 5.1 kΩ on CC1 and CC2 (R1, R2), so C-to-C chargers give 5 V. Solder the wires to VBUS/GND, no header |
| Switch | **SS13D07 mini slide switch, 1P3T** (3 positions, "L4" = 4 mm knob), e.g. XKB SS13D07L4B | Body 12.7 × 4.5 × 4.7, knob 4 mm, 2 mm per step | Sits in a printed cradle behind the front face, in the top band left of the arm tab & socket, and slides sideways; the knob pokes ~2.4 mm out. L and H engraved beside the slot |
| Low-speed diodes | 2 × 1N4001 (or 1N4007) | DO-41, 5 × 2.7 mm | ~0.8 V drop each, nearly independent of current, so the fan still starts on Low |
| Fixing | 2 printed pins through the board holes (heat-staked), or M2.5 screws into the posts | | |

## Bill of materials

Prices are rough Amazon / Adafruit figures in USD. Check the listings.

| Qty | Item | Exact part / spec | Approx. |
|---|---|---|---|
| 1 | Fan | WINSINN 3007 5V **hydraulic**, XH2.54 plug, 300 mm leads (usually a 2-pack, so one spare) | $10 / 2 |
| 1 | USB-C socket board | Adafruit 4090 USB Type C Breakout – Downstream Connection | $3 |
| 1 | Switch | SS13D07 slide switch, 1P3T, 4 mm knob (Amazon packs are often labelled "SS13D07 3 position") | $6 / 20 |
| 2 | Diodes (Low speed) | 1N4001 or 1N4007, DO-41 | $5 / 100 |
| 4 | Fan screws | M3 × 8 self-tapping (front face 1.6 + fan frame 7) | from a kit |
| 1 | Top insert (optional) | 1/4"-20 heat-set insert, for `top_mount = "quarter"` and a metal cold-shoe adapter | $8 / 10 |
| 2 | Board screws (optional) | M2.5 × 6, if you don't heat-stake the printed pins | from a kit |
| ~30 cm | Wire | 26 AWG silicone, red + black | $8 / spool set |
| a few | Heat-shrink | 2–3 mm | from a kit |
| 4 | Pads | small self-adhesive rubber or felt, or printed TPU, under the four corner feet | $5 / sheet |
| ~15 g | Filament | PETG or ASA | – |
| 1 | Cable | USB-C to USB-C, **right-angle** plug (keeps the cable tight to the side) | $10 |
| 1 | Power | Any USB-C charger or power bank (5 V, 0.2 A is plenty) | have |

Tools: soldering iron, calipers, M3 tap or screwdriver.

## The box

    front (operator side)
      ┌──────┬──────────┬──────────┬───┐
      │      │ L◦H  [ ] │          │   │   switch left of arm socket in top band; 6 mm right duct
    ▭─┤ bay  │ chamber  │  ( fan ) │   │   USB-C out of the left wall; fan blows onto the plate
      └──────┴──────────┴──────────┴───┘   bottom bevelled from 0 at the plate to 3 mm at the front
    solid back rim on left/top/right inside the 5.2 mm recess; exhaust windows outside the recess + bottom-back ribs

**80 × 35 × 13 mm**, unblocked exhaust 467 mm² (side/top 221 + bottom-back 246) vs 503 mm² fan free area.

- **Size, from the cardboard test on the camera:** 35 mm tall against the plate (36 just squeezes in) and 32.5 mm at the
  front in the test; the box goes to 32 (`slant_rise = 3`, about the most before the bevel reaches the fan). The
  bottom is bevelled straight from the plate to clear the screen's hinge arm, and the inside floor follows it.
  The top wall is 1.2 mm so the fan sits as high as possible. The screen leaves about 14 mm of depth, so the box is 13.0 (1.6 front + 7 fan + 4.4 gap). The
  recess is about 84 mm wide; the box is 80, placed 1 mm from its left edge.
- **Layout:** the electronics bay is on the left (cable side) with a lower divider stopping at the USB-C centre (`usb_zc`) so
  the upper bay stays open for wiring and upper-left exhaust; the fan sits at `X = 42.1..72.1` leaving a 6 mm exhaust duct along the
  right wall; the open chamber between bay and fan makes the air sweep the plate. The grille uses a single slim mid-radius ring and 3 × 1.4 mm spokes so the uncovered upper blade arc stays open.
- **Noise is mostly speed.** Sofasco's datasheet for its 3007 family (same size, sleeve bearing) shows it clearly:
  12000 rpm 35 dBA, 10000 rpm 31, 8000 rpm 26, 6000 rpm 22 (1.6 CFM). The bearing type adds tick or hum on top of that.
  So a hydraulic bearing plus a lower speed is the quiet combination.
- **Two speeds:** the switch is Low (left) / Off (middle) / High (right). Low feeds the fan through two diodes, about 3.4 V, roughly
  5500 rpm and ~21 dBA by the table above. This covers whatever fan Amazon delivers: if it's loud, record on Low.
  If it won't start on Low, use one diode (~4.2 V) or a Schottky 1N5819 pair (~4.2 V, 0.4 V each).
  Diodes beat a resistor here: a resistor drops more voltage when the fan pulls its higher starting current.
  Mount the fan with the label side (the outlet) toward the camera.
- **Airflow:** blowing onto the plate cools better than sucking air off it. Because the camera's recess is 5.2 mm deep, the left,
  top, and right walls keep a solid 5.6 mm back rim inside the recess; unblocked exhaust windows sit outside the recess (`Y = 5.6..11.4`
  from the plate) on the right wall (4 × 5.85 mm slots), top wall left of the fan (the socket collar stops 1.15 mm below the top wall, so the upper-left window stays completely open),
  and left wall above the USB-C board. Ten ribbed slots along the bottom-back edge (`Y = 0..4.4`) vent behind the solid bottom bevel and
  screen hinge arm, baffled from the intake wedge.
- **USB-C:** the board stands parallel to the front face on two posts from the front wall. Outside, the left wall is
  counterbored down to 0.6 mm around the opening so the plug's overmold sits in it and the plug reaches full depth.
- **Switch:** in the front face left of the arm tab & socket (`sw_xc = 23.65`, `X_cam ≈ 27.7`), in the top band the tilted screen never covers, 7 mm
  below the top (`~7.3 mm` below the rubber eyecup, `3.1 mm` proud at the front face / `~5.5 mm` at the knob tip).
- **Eye sensor:** it sits on the eyepiece, right above the box. Set *FINDER/MONITOR → Monitor (manual)*.
- **Mounting: tool-free pin-and-socket slide-on shoe arm** ([sony-a6300-fan-arm.scad](sony-a6300-fan-arm.scad), [close-up](dev/scene-mount.png), [dev/MOUNTING-NOTES.md](dev/MOUNTING-NOTES.md)).
  After sliding the box into the screen recess, slide the arm `-Y` into the camera's flash shoe:
  - Its ISO 518 foot (`18.4 × 16 × 1.9 mm` footprint, 45° rear taper leaving `~10.1 mm` full-width rail / `13.25 mm` total lip/floor engagement) has `0.8 mm` 45° front-entry corner chamfers and two `0.2 mm` tapered underside friction ribs engaging the shoe floor spring;
  - A `10 × 4 mm` drop-tab stays inside the top `14.5 mm` screen-free band (`13.15 mm` clear of the flash button, `2.5 mm` above the 65° LCD / `7.0 mm` at 90°), carrying a `6.0 × 6.0 × 4.2 mm` locating lug with a **flat horizontal load-bearing top shelf** (`3.4 mm` flat bearing inside the socket + `0.6 mm` top/side tip lead-in chamfers) and a **45° bottom ramp**;
  - During the final ~4 mm of shoe travel, the lug seats into the `6.5 × 6.5 × 4.6 mm` open-backed front socket on the box, taking gravity in pure vertical shear (zero backward wedging force) and locking all 6 DOF with zero screws or inserts (the same box also works standalone with micro-suction pads + tilted screen clamp as a zero-hardware fallback).
  - A printed cold shoe on top keeps the shoe usable for a light mic; `top_mount = "quarter"` gives a 1/4"-20 insert for a metal shoe adapter.
- **Material:** PETG or ASA, not PLA.

## Printing

Both STLs are exported in print orientation (`orient` / `arm_orient = "print"`; `"display"` shows them as fitted).
Both are manifold and print **without supports** (checked with `tools/stl-check.py`).

| Part | On the bed | Watch |
|---|---|---|
| Box | Front face (grille) down, open back up | Short horizontal bridges only: 4.9–7.3 mm over the side/top exhaust windows (bridged by the solid back rim), 6–8 mm over the USB-C opening. Bottom-back ribs are open to the top. The open-backed pin socket collar, posts, switch cradle and lower bay divider grow straight up from the front plate with zero bridges or overhangs |
| Arm | Lying flat on its back (`+Y` tab/bridge/top-block face down, `-Y` up) | Zero faces flatter than 45° (`tools/stl-check.py`): continuous XY perimeters wrap the bridge-to-tab corner for bending strength, the flat-top / 45°-bottom-ramped lug grows straight up support-free off the tab, and the 45° rear foot taper eliminates the old `3.2 mm` foot flange overhangs and `18.8 mm` cold-shoe ceiling bridge (only a small front-stop bridge remains on the top cold shoe) |

PETG or ASA, 0.2 mm layers, 3 perimeters. Print the fit-test shell and the arm first: check the shell on the camera and the foot in the shoe.

## Wiring

    USB-C VBUS ── switch common
                  switch H  ─────────────────────── fan red (+)   High, 5 V
                  switch L  ──|>|──|>|── fan red (+)              Low, ~3.4 V  (2 × 1N4001, band toward the fan)
    USB-C GND  ─────────────────────────── fan black (−)
    CC1, CC2   ── 5.1 kΩ ── GND   (already on the Adafruit board)

## Facts gathered

| Item | Value | Source |
|---|---|---|
| a6300 body (W×H×D) | 120.0 × 66.9 × 48.8 mm (grip to monitor), 404 g | Sony spec / apotelyt |
| LCD | 3.0" 16:9, tilts ~90° up, ~45° down | apotelyt |
| Sony 4K limit | ~29 min at 20–30 °C, ~20 min at 40 °C, with *Auto Pwr OFF Temp = High* | Sony help guide ILCE-6300 |
| What helps (reported) | LCD pulled away from body, metal cage + thermal pads, external power | DPReview, 4kshooters, diyphotography |
| 30-min cap | Removed by OpenMemories: Tweak (PMCA app, at your own risk) | github ma1co/OpenMemories-Tweak |
| USB power | Micro-USB runs the camera with a battery inside, but Sony warns it adds heat. An NP-FW50 dummy battery on 5 V/2–3 A moves the battery heat outside | Sony help guide, dummy-battery listings |

## Copper (idea, later)

The fan comes first. Afterwards, small stick-on finned heatsinks (≤ 3 mm tall with a 4 mm gap) or flat copper
on **thermal tape** under the fan may add a little. Plain double-sided tape insulates.

## Measured so far (2026-11-18, calipers + photos)

| What | Value | Model before |
|---|---|---|
| Clear height on the back: eyepiece underside → tilted screen's top edge (photo angle) | 38.46 | box 38.0 |
| Eyepiece underside above the base (from photo scale, ±1.5) | ~47.5 | 44 |
| Of that, fully free depth from the eyepiece down | 17.47; below it the tilted screen's top gets in the way | – |
| Eyepiece protrusion from the magnesium back plate | 9.92 | 19 |
| Screen's top edge behind the back plate (photo 7 angle) | 22.61 | 6 |
| Screen recess depth (screen flipped out) | 5.19–5.51 | none |
| Screen thickness (closed: outer face → plate); sits ~1–1.5 proud of the frame, body not perfectly flat | 6.3–6.4 | 7 |
| Shoe: open end → back edge, over a small hump | 5.88 | 4 |
| Cardboard test block that fits: height against the plate / outside face (bottom bevelled straight from the plate) | 35 / 32.5–33 | box 38, small front slant |
| Depth the screen allows: block ~11 + 3 mm extra piece (30 tall) before it touches the screen | ~14 | 12.6 → 13.0 |
| Top band under the eyepiece where the screen never reaches, at any depth | 14.5–15 | – |
| Recess right edge from the eyepiece-side end (photo, ruler) | ~87 | 77 |
| Shoe centre from the eyepiece-side end (from photo scale, ±1.5) | ~41 | 52 |
| Dual-hinge LCD linkage (side photo + cardboard fit, ±1–2) | lower arm ~29.5 mm, mechanical stop ~54° from vertical, upper pivot ~12 mm below LCD top | single bottom hinge |

## Steps

1. Print the fit-test shell ([dev/sony-a6300-fan-fit-test.scad](dev/sony-a6300-fan-fit-test.scad), ~15 min) and the arm ([sony-a6300-fan-arm.scad](sony-a6300-fan-arm.scad)) first: verify recess fit, hinge bevel clearance, shoe friction retention, lug-to-socket alignment against the front pocket scribe marks, and thumb reach to the switch under the eyecup.
2. Check that the screen still tilts up far enough to see from above without crossing the `14.5 mm` scribe line.
3. Order the parts above, plus a short right-angle C-to-C cable (no M3 arm screws or inserts needed).
4. Print the box, wire it, fit it.
5. Test with 4K, Auto Pwr OFF Temp = High, the 30-min cap removed, and a dummy battery. Log the time to the
   overheat warning with and without the fan, at the same room temperature.
