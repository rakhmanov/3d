# fan-duct-reducer

Parametric reducer / adapter between any two round ducts, pipes or hoses. Each end can slide **over** or **into** what it connects to.

## Ready-made versions

| File | Sizes | Ends | Height |
|---|---|---|---|
| `fan-duct-reducer` | 6" to 5" | both slide over | 100 mm |
| `fan-duct-reducer-short` | 6" to 5" | both slide over | 60 mm |
| `fan-duct-reducer-4to5` | 5" to 4" | 5" slides over, 4" slides into the pipe | 52 mm |

### 6" to 5"

![preview](fan-duct-reducer.png)

### 6" to 5" short

![preview](fan-duct-reducer-short.png)

### 5" to 4", short, for a sheet-metal roaster exhaust

The 4" end plugs into a thin folded sheet-metal exhaust pipe. It's the shortest version that still prints without supports.

![preview](fan-duct-reducer-4to5.png)

## Changing the parameters

Every `.scad` file in this folder has its settings at the top. `fan-duct-reducer.scad` holds the actual model, and the other files are presets that reuse it with their own values. Pick the file closest to what you need and change its values. You can do that in any of three ways.

**1. OpenSCAD Customizer (easiest).** Open the file in [OpenSCAD](https://openscad.org) and turn on **Window > Customizer**. Change the values in the panel, press **F6** to render, then **F7** to export the STL.

**2. Edit the file.** Change the numbers at the top of the file in any text editor, for example:

    small_size = 4;
    small_fit = "into";

**3. Command line / Docker (no GUI).** Override any parameter with `-D` (strings need inner quotes):

    openscad -o reducer.stl -D large_size=5 -D small_size=4 -D 'small_fit="into"' fan-duct-reducer.scad

    docker run --rm -v "$PWD":/openscad -w /openscad openscad/openscad:latest \
      openscad -o reducer.stl -D 'small_fit="into"' fan-duct-reducer-4to5.scad

Each render prints a summary line like this:

    ECHO: "Inner: 127.5 -> 95.1 mm, outer: 133.5 -> 101.1 mm, height: 52 mm, taper: 43.6 deg from vertical"

Check it before printing. You get a `WARNING` if the taper is too steep to print without supports, and an error if the small end can't be made with the chosen wall.

### Parameters

| Parameter | Example | What it does |
|---|---|---|
| `units` | `"inch"` | Units for the two sizes: `"inch"` or `"mm"`. Everything else is always mm |
| `large_size` | `5` | Diameter of the large end's pipe or duct, measured as explained under `large_fit` |
| `small_size` | `4` | Same for the small end |
| `large_fit` | `"over"` | How the large end attaches, `"over"` or `"into"` (see below) |
| `small_fit` | `"into"` | How the small end attaches |
| `clearance` | `0.5` | Slip-fit gap on the diameter, mm. Increase it if fits come out too tight |
| `wall` | `3` | Wall thickness, mm |
| `taper_height` | `60` | Length of the cone between the two ends, mm. Shorter makes it steeper |
| `large_lip` | `20` | Length of the straight collar on the large end, mm |
| `small_lip` | `20` | Length of the straight collar on the small end, mm |

### `over` or `into`?

- **`over`**: the reducer slides over the outside of the pipe. Set the size to the pipe's **outer** diameter.
- **`into`**: the reducer slides into the pipe or hose. Set the size to its **inner** diameter.

| | `over` | `into` |
|---|---|---|
| Airflow | Smooth: the bore never shrinks | Wall + clearance (~3.5 mm per side) forms a small ledge inside |
| Hot exhaust | Plastic only touches the outside of the pipe | Plastic sits in the gas stream |
| Thin sheet-metal pipe | Too-small print won't fit at all | Forgiving: flare the pipe end if tight, hose-clamp it if loose |
| Flexible hose | Hose would need to stretch inside | Best: hose slides over and gets clamped |

For rigid, accurately sized pipe, use `over`. For thin sheet metal, flex hose, or a pipe you couldn't measure precisely, use `into`.

### Measuring

Wrap a tape measure **around** the pipe and divide the circumference by π (3.1416). An error of 1 mm in circumference is only 0.3 mm in diameter, which is far more accurate than measuring across. For thin sheet metal, the inner diameter is about 1 mm less than the outer one. You can enter sizes in mm directly with `units = "mm"`.

### How short can it be?

The model is printed large end down. The cone's inner wall then overhangs, and most printers handle about 45° from vertical without supports. The shortest support-free taper is about:

    taper_height ≈ (large inner diameter - small inner diameter) / 2

Use the diameters from the render summary. For the 5" to 4" preset that's (127.5 - 95.1) / 2 = 16.2, so it uses 17. For collars, allow about 15 mm where tape is enough and about 20 mm where a hose clamp (about 13 mm wide) has to fit.

### Material

The plastic has to handle the air temperature. PLA softens around 55–60 °C and PETG around 75–80 °C. For warm air, such as roaster or dryer exhaust, use ASA or ABS (about 95–100 °C) or PC. Check that the pipe is cool enough to hold where the reducer sits.

## Adding your own preset

Copy `fan-duct-reducer-4to5.scad` to a new name in this folder, for example `fan-duct-reducer-3to4.scad`, then change its values. When pushed to `main`, CI renders the STL and preview automatically. It also re-renders all presets whenever `fan-duct-reducer.scad` changes.
