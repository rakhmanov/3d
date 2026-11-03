// Parametric duct reducer / adapter
// Author: Denis Shatilov
// License: CC BY-NC 4.0
// https://creativecommons.org/licenses/by-nc/4.0/
//
// Open in OpenSCAD and use Window > Customizer, or call duct_reducer(...) from another file:
//   use <fan-duct-reducer.scad>
//   duct_reducer(large_size=4, small_size=3, small_fit="into");

/* [Sizes] */
// Units for large_size / small_size (everything else is mm)
units = "inch"; // [inch, mm]
// Nominal diameter of the large duct
large_size = 6;
// Nominal diameter of the small duct
small_size = 5;

/* [Fit] */
// over: reducer slides OVER the pipe (size = pipe outer diameter). into: reducer slides INTO the pipe/hose (size = its inner diameter)
large_fit = "over"; // [over, into]
small_fit = "over"; // [over, into]
// Diametral slip-fit clearance, mm
clearance = 0.5;

/* [Shape] */
// Wall thickness, mm
wall = 3;
// Length of the tapered section, mm
taper_height = 60;
// Length of the straight collar on the large end, mm
large_lip = 20;
// Length of the straight collar on the small end, mm
small_lip = 20;

/* [Hidden] */
$fn = 128;
eps = 0.01;

function to_mm(size, units) = units == "mm" ? size : size * 25.4;

// [inner, outer] diameters of one end
function end_diameters(d, fit, clearance, wall) =
    assert(fit == "over" || fit == "into", str("fit must be \"over\" or \"into\", got ", fit))
    fit == "over"
        ? [d + clearance, d + clearance + 2*wall]
        : [d - clearance - 2*wall, d - clearance];

module duct_reducer(large_size = large_size, small_size = small_size, units = units,
                    large_fit = large_fit, small_fit = small_fit, clearance = clearance,
                    wall = wall, taper_height = taper_height, large_lip = large_lip, small_lip = small_lip) {
    L = end_diameters(to_mm(large_size, units), large_fit, clearance, wall);
    S = end_diameters(to_mm(small_size, units), small_fit, clearance, wall);
    total = large_lip + taper_height + small_lip;

    // Slope of the steeper of the inner/outer taper surfaces, for printability with the large end down
    angle = max(atan((L[0] - S[0]) / 2 / taper_height), atan((L[1] - S[1]) / 2 / taper_height));
    echo(str("Inner: ", L[0], " -> ", S[0], " mm, outer: ", L[1], " -> ", S[1],
             " mm, height: ", total, " mm, taper: ", angle, " deg from vertical"));
    if (angle > 45) echo("WARNING: taper steeper than 45 deg, increase taper_height or print with supports");
    assert(S[0] > 0, "small end too small for this wall/fit");

    // Large collar, taper and small collar as one profile
    module body(dl, ds, extra) {
        translate([0, 0, -extra])
            cylinder(d = dl, h = large_lip + 2*extra);
        translate([0, 0, large_lip])
            cylinder(d1 = dl, d2 = ds, h = taper_height);
        translate([0, 0, large_lip + taper_height - extra])
            cylinder(d = ds, h = small_lip + 2*extra);
    }

    difference() {
        body(L[1], S[1], 0);
        body(L[0], S[0], eps);
    }
}

duct_reducer();
