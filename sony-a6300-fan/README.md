# Sony a6300 rear cooling fan (DRAFT)

A small box that sits in the screen recess on the camera's back, under the eyepiece, with the screen
tilted out, and blows air onto the magnesium back plate for long 4K takes. It runs from USB-C on the
cable side and has a thumbnail slide switch: Low / Off / High. A second part, an arm from the flash
shoe, holds it. The box size comes from a cardboard test on the real camera; the arm position from
caliper readings and photos (±2 mm). **Not printed yet.**

**Status and known problems: see [HANDOFF.md](HANDOFF.md).** In short: the tilted screen covers the lower front
(the switch is currently placed there and has to move), the exhaust slots mostly face the recess walls, and how
the box is held is open (current plan: the screen pressing it in place).

| On the camera | Inside (front cut away) | Side | Arm and shoe |
|---|---|---|---|
| ![](scene-iso.png) | ![](scene-cutaway.png) | ![](scene-side.png) | ![](scene-mount.png) |

| File | What |
|---|---|
| [sony-a6300-fan.scad](sony-a6300-fan.scad) | The printable box ([preview](sony-a6300-fan.png)). Parameters at the top |
| [sony-a6300-fan-arm.scad](sony-a6300-fan-arm.scad) | Second printable part: the shoe arm ([preview](sony-a6300-fan-arm.png)). Screws to the box's front face. `top_mount = "shoe"`, `"quarter"` or `"none"` |
| [sony-a6300-fan-fit-test.scad](sony-a6300-fan-fit-test.scad) | Thin shell with the box's outside shape, to try on the camera first |
| [sony-a6300-fan-scene.scad](sony-a6300-fan-scene.scad) | Display only: the box and arm on the camera with the fan, switch, diodes, USB-C board, wires and cable. `-D cutaway=true` |
| [a6300-camera.scad](a6300-camera.scad) | Display model of the a6300 from Sony's dimensions plus measurements of a real body. The screen's tilt linkage is not modelled (drawn flipped flat) |

## Parts

| Part | Exact item | Size used in the model | Notes |
|---|---|---|---|
| Fan | **WINSINN 3007 5V, hydraulic bearing**, XH2.54 plug, 300 mm leads (Amazon) | 30 × 30 × 7, holes on 24 × 24, M3 self-tapping | 8500 rpm. Hydraulic bearings are quieter than ball bearings and fine with the axis horizontal. WINSINN publishes no airflow or noise figure. The Sofasco table below suggests ~28 dBA at full speed, so plan on quiet mode |
| Fan, ball-bearing alternative | GDSTIME 3007 5V dual ball (Amazon) | 30 × 30 × 7 | 9000 rpm, 4.1 CFM, "25 dBA ±10 %", 0.15 A. Longest life, but more bearing tick and hum |
| Fan, best (if you find it) | Sunon MF30060V2-1000U-A99 | 30 × 30 × 6.5, fits the same box | 3.7 CFM at 15.7 dB(A). Distributors only (DigiKey, Mouser), often out of stock |
| USB-C | **Adafruit 4090**, "USB Type C Breakout Board – Downstream Connection" | PCB 20.32 × 13.97 × 1.6, connector centred on the long edge, 2 × Ø2.5 holes 15.24 apart, 2.54 in from the connector edge | Numbers from Adafruit's Eagle board file. 5.1 kΩ on CC1 and CC2 (R1, R2), so C-to-C chargers give 5 V. Solder the wires to VBUS/GND, no header |
| Switch | **SS13D07 mini slide switch, 1P3T** (3 positions, "L4" = 4 mm knob), e.g. XKB SS13D07L4B | Body 12.7 × 4.5 × 4.7, knob 4 mm, 2 mm per step | Sits in a printed cradle behind the front face, low and just left of the fan, and slides sideways; the knob pokes ~2.4 mm out. L and H engraved beside the slot |
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
| 2 | Arm screws + inserts | M3 × 6 pan head + M3 × 4 heat-set inserts (box front) | kit |
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
      ┌──────┬────────────┬───────────┐
      │      │     ◉ ◉ ←arm tab        │   arm screws in the top band
    ▭─┤ bay  │  chamber   │  ( fan )  │   USB-C out of the left wall; fan top right, blowing onto the plate
      │      │      L◦H   │           │   switch low, next to the fan (away from the eyepiece)
      └──────┴────────────┴───────────┘   bottom bevelled from 0 at the plate to 3 mm at the front
    back edge of all 4 walls: ribbed exhaust band, as tall as the fan-to-plate gap

**80 × 35 × 13 mm**, exhaust 715 mm² vs 503 mm² fan opening.

- **Size, from the cardboard test on the camera:** 35 mm tall against the plate (36 just squeezes in) and 32.5 mm at the
  front in the test; the box goes to 32 (`slant_rise = 3`, about the most before the bevel reaches the fan). The
  bottom is bevelled straight from the plate to clear the screen's hinge arm, and the inside floor follows it.
  The top wall is 1.2 mm so the fan sits as high as possible. The screen leaves about 14 mm of depth, so the box is 13.0 (1.6 front + 7 fan + 4.4 gap). The
  recess is about 84 mm wide; the box is 80, placed 1 mm from its left edge.
- **Layout:** the electronics bay is on the left (cable side), the fan in the top right corner (room for the bevel
  below it), and the closed chamber between them makes the air sweep the plate before it leaves through the ribs.
- **Noise is mostly speed.** Sofasco's datasheet for its 3007 family (same size, sleeve bearing) shows it clearly:
  12000 rpm 35 dBA, 10000 rpm 31, 8000 rpm 26, 6000 rpm 22 (1.6 CFM). The bearing type adds tick or hum on top of that.
  So a hydraulic bearing plus a lower speed is the quiet combination.
- **Two speeds:** the switch is Low (left) / Off (middle) / High (right). Low feeds the fan through two diodes, about 3.4 V, roughly
  5500 rpm and ~21 dBA by the table above. This covers whatever fan Amazon delivers: if it's loud, record on Low.
  If it won't start on Low, use one diode (~4.2 V) or a Schottky 1N5819 pair (~4.2 V, 0.4 V each).
  Diodes beat a resistor here: a resistor drops more voltage when the fan pulls its higher starting current.
  Mount the fan with the label side (the outlet) toward the camera.
- **Airflow:** blowing onto the plate cools better than sucking air off it. The air spreads along the plate
  and leaves at the perimeter, so the exits are a band along the back edge of every wall, with solid
  corners as feet. Higher openings are useless because the fan frame blocks them. Warm air leaves up under the eyecup, down over
  the screen back, to the right toward the buttons, and left through the bay. None of it goes back into the intake.
- **USB-C:** the board stands parallel to the front face on two posts from the front wall. Outside, the left wall is
  counterbored down to 0.6 mm around the opening so the plug's overmold sits in it and the plug reaches full depth.
- **Switch:** in the front face just left of the fan, low down, so your finger stays away from the eyepiece and its
  rubber cup, and below the arm's screws. The knob sticks out ~2.4 mm.
- **Eye sensor:** it sits on the eyepiece, right above the box. Set *FINDER/MONITOR → Monitor (manual)*.
- **Mounting: shoe arm** ([sony-a6300-fan-arm.scad](sony-a6300-fan-arm.scad), [close-up](scene-mount.png)).
  A foot (ISO 518, 18.4 × 16 × 1.9 mm) slides into the camera's shoe from the back, a bridge crosses the top
  edge and the hump behind the shoe, and a 12 × 4 mm tab drops in front of the box. It screws to the box's
  front face with 2 × M3 × 6 into M3 × 4 heat-set inserts, inside the top 14.5 mm band the tilting screen never
  reaches, left of the fan. The tab clears the flash button by about 12 mm. A printed cold shoe on top keeps the
  shoe usable for a light mic; `top_mount = "quarter"` gives a 1/4"-20 insert for a metal shoe adapter.
- **Material:** PETG or ASA, not PLA.

## Printing

Both STLs are exported in print orientation (`orient` / `arm_orient = "print"`; `"display"` shows them as fitted).
Both are manifold and print **without supports** (checked with `tools/stl-check.py`).

| Part | On the bed | Watch |
|---|---|---|
| Box | Front face (grille) down, open back up | Short bridges only: 4 mm over the insert holes, 6–8 mm over the USB-C opening. The posts, insert bosses and switch cradle grow straight up from the front plate |
| Arm | Upside down, on the top shoe block | 18.8 mm bridge over the top shoe's slot. The foot's flanges overhang the neck by 3.2 mm: print slowly with full cooling, and sand lightly if they droop (that face slides under the camera shoe's lips). The tab grows straight up |

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

## Steps

1. Print the fit-test shell (15 min) and check it on the camera: sits flat on the plate under the eyepiece, the
   screen still tilts up far enough to see from above.
2. Print the arm and check the foot in the shoe, and that the tab lines up with the box's top band.
3. Order the parts above, plus a short right-angle C-to-C cable.
4. Print the box, set the two inserts, wire it, fit it.
5. Test with 4K, Auto Pwr OFF Temp = High, the 30-min cap removed, and a dummy battery. Log the time to the
   overheat warning with and without the fan, at the same room temperature.
