// Parametric duct reducer / adapter
// Author: Denis Shatilov
// License: CC BY-NC 4.0
// https://creativecommons.org/licenses/by-nc/4.0/
//
// Open in OpenSCAD and use Window > Customizer, or call duct_reducer(...) from another file:
//   use <fan-duct-reducer.scad>
//   duct_reducer(large_size=4, small_size=3, small_fit="outside");

/* [Sizes] */
// Units for large_size / small_size (everything else is mm)
units = "inch"; // [inch, mm]
// Nominal diameter of the large duct
large_size = 6;
// Nominal diameter of the small duct
small_size = 5;

/* [Fit] */
// inside: duct slides into the reducer (sized by duct OD). outside: hose slides over the reducer (sized by hose ID)
large_fit = "inside"; // [inside, outside]
small_fit = "inside"; // [inside, outside]
// Diametral slip-fit clearance, mm
clearance = 0.5;

/* [Shape] */
// Wall thickness, mm
wall = 3;
// Length of the tapered section, mm
taper_height = 60;
// Length of the straight collar on each end, mm
lip_length = 20;

/* [Hidden] */
$fn = 128;
eps = 0.01;

function to_mm(size, units) = units == "mm" ? size : size * 25.4;

// [inner, outer] diameters of one end
function end_diameters(d, fit, clearance, wall) =
    fit == "inside"
        ? [d + clearance, d + clearance + 2*wall]
        : [d - clearance - 2*wall, d - clearance];

module duct_reducer(large_size = large_size, small_size = small_size, units = units,
                    large_fit = large_fit, small_fit = small_fit, clearance = clearance,
                    wall = wall, taper_height = taper_height, lip_length = lip_length) {
    L = end_diameters(to_mm(large_size, units), large_fit, clearance, wall);
    S = end_diameters(to_mm(small_size, units), small_fit, clearance, wall);
    total = 2*lip_length + taper_height;

    // Slope of the steeper (outer) surface, for printability with the large end down
    angle = atan((L[1] - S[1]) / 2 / taper_height);
    echo(str("Inner: ", L[0], " -> ", S[0], " mm, outer: ", L[1], " -> ", S[1],
             " mm, height: ", total, " mm, taper: ", angle, " deg from vertical"));
    if (angle > 45) echo("WARNING: taper steeper than 45 deg, increase taper_height or print with supports");
    assert(S[0] > 0, "small end too small for this wall/fit");

    // Large collar, taper and small collar as one profile
    module body(dl, ds, extra) {
        translate([0, 0, -extra])
            cylinder(d = dl, h = lip_length + 2*extra);
        translate([0, 0, lip_length])
            cylinder(d1 = dl, d2 = ds, h = taper_height);
        translate([0, 0, lip_length + taper_height - extra])
            cylinder(d = ds, h = lip_length + 2*extra);
    }

    difference() {
        body(L[1], S[1], 0);
        body(L[0], S[0], eps);
    }
}

duct_reducer();
