# Mounting notes: Sony a6300 rear cooling fan

Why screwing a shoe arm to the box is awkward, the 5 tool-free alternatives considered, and why Option #1 was chosen.

## Physical constraints

Once seated in the camera's `5.2 mm` deep screen recess (`X = 4..84 mm`), five of the box's six degrees of freedom are constrained by the body and screen:

- `-Y` (forward): magnesium back plate
- `+Z` (up): EVF eyepiece and top frame
- `±X` (left / right): recess side walls
- `-Z` (down): LCD hinge arm (when the screen is tilted up)

Only `+Y` (falling backward out of the recess) and `-Z` (when the screen is folded down) need retention. Because the tilted-up screen blocks pushing the box straight forward (`-Y`), the box enters from the side or with the screen lowered, whereas a hot-shoe foot must slide straight forward (`-Y`) into the Multi Interface Shoe. Screwing the arm to the box after seating requires tools on every install/removal, and a **one-piece slide-in** (arm built into the box, pushed `-Y` into the shoe as the box seats) is ruled out because the screen cannot clear `-Y` entry (a one-piece holder would need sideways entry, e.g. a dovetail).

## Five tool-free options

### 1. Tool-free pin-and-socket slide-on shoe arm (implemented)
- **Mechanism:** Seat the box in the recess first, then slide the shoe arm straight forward (`-Y`) into the hot shoe. The arm's `4 mm` drop-tab stays inside the `14.5 mm` screen-free top band (thickening to `8.2 mm` above the box top with a `3.0 mm` 45° bridge gusset) and carries a `6 × 6 mm` locating lug (`4.2 mm` long) with a flat horizontal load-bearing top shelf (`3.4 mm` bearing inside the socket + `0.6 mm` top/side tip lead-in chamfers) and a 45° bottom ramp. During the last ~4 mm of hot-shoe travel, it engages a `6.5 × 6.5 mm` pocket through the front plate backed by a **fused top bearing boss** (`2.6 mm` deep behind the `1.6 mm` plate = `4.2 mm` total bearing depth, `0.8 mm` past the flat lug shelf and `0.2 mm` past the lug tip, fused `2.55 mm` solid up into the top wall with no side or bottom collar walls). Tapered underside ribs on the ISO 518 foot engage the camera shoe's leaf spring for friction retention, while back-down printing puts continuous XY layers around the bridge-to-tab corner.
- **Pros:** Zero screws or heat-set inserts, 2-second attach/detach, positive 6-DOF lock in pure vertical shear (no backward wedging force) even when the screen moves, preserves a passive cold shoe on top and `313 mm²` of 100%-unblocked free-air exhaust (`337 mm²` standalone, plus `181 mm²` secondary right-side bottom-back bleed framed by a `1.6 mm` back rail; 6 top slots sit cleanly right of the `24 mm` eyecup above the lowered switch cradle, behind the fused top boss at `Y = 5.6..8.75`, and across the fan & right exhaust duct).
- **Cons:** Occupies the camera's electronic MI shoe (blocks MI-interface mics/flashes), 2 parts when packed.

### 2. Micro-suction / washable silicone pads + screen clamp (zero-hardware fallback)
- **Mechanism:** Keep a single-piece box and apply `~0.5 mm` micro-suction tape (e.g. Yupo Tako / Sewell AirStick) to the solid back rim against the magnesium plate, backed up by the tilted-up screen during shooting.
- **Pros:** Simplest single-part print, hot shoe and tripod socket remain 100% free, residue-free removal.
- **Cons:** Pad thickness (`0.5–0.8 mm`) eats into the `0.4–1.5 mm` front screen clearance (`air_gap` may need `-0.5 mm`), pads lose grip if dusty until wiped, weaker knock resistance with the screen closed.

### 3. Magnetic snap-on with thin steel shims
- **Mechanism:** Stick two `0.2–0.3 mm` steel shims inside the upper recess corners (clear of the closed hinge arm) on the non-magnetic magnesium plate, and embed small N52 magnets (e.g. `6 × 2 mm`) flush into the box's back rim.
- **Pros:** 1-second snap-on, positive retention regardless of screen angle, hot shoe stays free.
- **Cons:** Requires adhering permanent/semi-permanent metal strips to the camera recess and keeping them clear of the folding LCD arm; needs BOM magnets.

### 4. Elastic shock-cord / silicone band to camera strap lugs
- **Mechanism:** Add upper-corner cord notches on the box and stretch a thin elastic loop or `2 mm` shock cord to the camera's left and right strap lugs.
- **Pros:** Tolerant of dimensions, acts as a drop tether, keeps hot shoe and tripod socket free.
- **Cons:** On the a6300, a cord running from the box's right edge (`X = 84, Z ≈ 43`) to the right strap lug (`X = 120.5, Z = 55, Y = -16`) crosses directly over the `AF/MF-AEL` lever, `MOVIE` button, and thumb rest; competes with neck/wrist straps.

### 5. Bottom `1/4"-20` tripod plate with rear-left wrap-around clip
- **Mechanism:** Baseplate secured to the bottom `1/4"-20` socket with a tool-free D-ring screw (pass-through thread underneath) and a vertical wrap-around arm on the rear-left corner.
- **Pros:** Rigid mechanical mount leaving the hot shoe completely free.
- **Cons:** Fights the bottom LCD hinge arm, the bottom battery/dummy-battery door, the left terminal door, and our box's left-wall USB-C plug; bulky and slow to screw off (only worthwhile if built into a metal camera cage).

## Ranking

Scored out of 5 across **Physical Requirements** (orthogonal entry, 6-DOF lock, clearance, unobstructed ports/controls), **Practicality** (speed, tool-free daily use, shoe/ergonomics, durability), and **Ease of Execution** (CAD, support-free printability, BOM/tolerances):

| Rank | Option | Physical Req. | Practicality | Ease of Execution | Notes |
|---|---|---|---|---|---|
| **1** | **Tool-free Pin-and-Socket Shoe Arm** | **5 / 5** | **4.5 / 5** | **4 / 5** | Chosen primary mount (`sony-a6300-fan-arm.scad` + `sony-a6300-fan.scad`) |
| **2** | **Micro-Suction Pads + Screen Clamp** | **3.5 / 5** | **4.5 / 5** | **5 / 5** | Zero-hardware fallback (same box works without the arm) |
| **3** | **Magnetic Snap-On (Steel Shims)** | **4.5 / 5** | **4 / 5** | **3.5 / 5** | Best free-shoe alternative if sticking shims to the body is acceptable |
| **4** | **Strap-Lug Elastic Band** | **3 / 5** | **3 / 5** | **4.5 / 5** | Tripod-only compromise; crosses right thumb controls |
| **5** | **Bottom `1/4"-20` Wrap-Around Plate** | **2.5 / 5** | **2 / 5** | **2 / 5** | Interferes with hinge arm, battery door, terminal door, and USB-C |

> **CI note:** `.github/matrix/generate.py` renders an STL and PNG for every committed `.scad` outside `dev/`, so remove `sony-a6300-fan-arm.scad` before merging to `main` if the shoe arm is dropped in favor of a fallback.
