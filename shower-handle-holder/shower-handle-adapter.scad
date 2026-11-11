// Shower / tub valve handle adapter (round flange + hex boss with a side window)
// Author: Denis Shatilov
// License: CC BY-NC 4.0
// https://creativecommons.org/licenses/by-nc/4.0/
//
// Hex, overall height, stem and worn bore measured with calipers 2026-11-11;
// the rest is still estimated from photos (README.md). Print flange-down, no supports.
//
// Section through the window (window points at -X, which is a hex CORNER):
//
//              top_round_d
//             |<------>|
//        _____|        |_____
//       |     |        |     |  <- round bore from the top, down to the window
//   ____|     |        |     |
//  |window               |___|  <- window: one side only, floor = flange top,
//  |_______    ______    |____     back wall window_back from the far face
//  |_______|  |      |   |____|  <- flange, obround socket from below
//            /________\          (long axis along the window), bevelled entry

/* [Flange] */
// Flange outer diameter. REFERENCE SIZE: the other estimates are scaled from this
flange_d = 20.0;
// Flange thickness (estimate)
flange_h = 3.8;
// Chamfer on flange top and bottom edges
flange_chamfer = 0.5;

/* [Hex boss] */
// Number of sides. The original is 7-sided: caliper width stays ~15.07 at any rotation
boss_sides = 7;
// Caliper width at the flange (odd sides: flat to opposite corner). Measured 15.04-15.10
hex_af = 15.09;
// Overall height, flange bottom to hex top. Measured
total_h = 14.05;
// Width lost toward the top. The original looks deliberately skewed to wedge in
hex_taper = 0;
// Small chamfer on the top hex edges (0 = sharp)
boss_top_chamfer = 0.4;

/* [Side window] */
// Window height, from the flange top up
window_h = 2.6;
// Window width where it breaks out at the hex corner
window_w_outer = 4.5;
// Window width at its inner end
window_w_inner = 3.8;
// Window back wall to the opposite outer face (the screw opening's depth). Measured
window_back = 11.09;
// Direction of the window, degrees. A boss corner always points here
window_angle = 180;

/* [Bottom socket] */
// Socket shape from below (the stem fits here). obround = elongated with rounded ends
bottom_shape = "obround"; // [obround, square]
// Long side (obround: end to end; square: across flats)
bottom_long = 8.8;
// Short side, across the straight sides
bottom_short = 5.2;
// Corner radius for the square shape
bottom_corner_r = 0.5;
// Bevel at the socket entry
bottom_entry_chamfer = 0.8;
// Socket depth from the bottom face. -1 = auto: up to the window ceiling
bottom_depth = -1;
// Rotation relative to the window, degrees. 0 = long axis points at the window
bottom_rot = 0;

/* [Top bore] */
// Round bore from the top: takes the stem tip. Stem measured 6.44; worn original 6.54 x 6.80
top_round_d = 6.44;
// Clearance on the stem bore only. Keep it tight: this is where the original wore
top_round_fit = 0.1;
// Bore depth from the top. -1 = auto: down to the window ceiling, so it meets the square
top_round_h = -1;

/* [Print fit] */
// Added to the hex size for printing (negative = smaller, so it slides into the handle)
hex_fit = -0.15;
// Added to the other hole sizes for printing (positive = looser)
hole_fit = 0.2;

/* [Output] */
// adapter = the real part. hex_gauge / bottom_gauge = thin, fast fit tests
part = "adapter"; // [adapter, hex_gauge, bottom_gauge]
// Cut away half along the window axis to see the inside (preview only)
cutaway = false;

$fn = 96;
eps = 0.01;

hex_af_p = hex_af + hex_fit;
// Corner radius for a caliper width w
function r_of(w) = boss_sides % 2 == 0 ? w / (2 * cos(180 / boss_sides))
                                      : w / (1 + cos(180 / boss_sides));
hex_r    = r_of(hex_af_p);
// Window end along its axis, past the centre (negative = short of it)
window_reach = (hex_af_p - (boss_sides % 2 == 0 ? hex_af_p / 2 : hex_r)) - window_back;
boss_h   = total_h - flange_h;
bot_depth = bottom_depth < 0 ? flange_h + window_h : bottom_depth;
bore_h   = top_round_h  < 0 ? boss_h - window_h  : top_round_h;

assert(hex_r * 2 < flange_d, "Boss corners overhang the flange");
assert(bore_h + window_h >= boss_h - eps || bore_h + window_h < boss_h - 1, "Top bore stops less than 1 mm short of the window");
assert(bottom_long + 2 * bottom_entry_chamfer < hex_af_p - 1, "Bottom socket leaves a too-thin wall under the hex");

echo(str("Adapter: flange ", flange_d, " x ", flange_h, ", ", boss_sides, "-sided boss ", hex_af_p, " wide (",
         round(hex_r * 200) / 100, " across corners, taper ", hex_taper, ") x ", boss_h, ", total ", total_h,
         ", stem bore ", top_round_d + top_round_fit,
         ", window ", window_w_outer, "->", window_w_inner, " x ", window_h,
         " at ", window_angle, " deg (corner), back wall ", round(-window_reach * 100) / 100, " short of centre"));

module chamfered_disc(d, h, c) {
    hull() {
        translate([0, 0, c]) cylinder(h = h - 2 * c, d = d);
        cylinder(h = h, d = d - 2 * c);
    }
}

// Boss prism with a corner pointing at the window
module hex_prism(r, h) { rotate([0, 0, window_angle]) cylinder(h = h, r = r, $fn = boss_sides); }

module hex_boss(h) {
    c = boss_top_chamfer;
    r_top = r_of(hex_af_p - hex_taper);
    hull() {
        hex_prism(hex_r, eps);
        translate([0, 0, h - c - eps]) hex_prism(r_top, eps);
        if (c > 0) translate([0, 0, h - eps]) hex_prism(r_top - c / cos(180 / boss_sides), eps);
    }
}

module rounded_square(af, r) {
    offset(r = r) square(af - 2 * r, center = true);
}

// Bottom socket outline, grown by g on every side
module bottom_profile(g) {
    f = hole_fit;
    if (bottom_shape == "square")
        offset(delta = g) rounded_square(bottom_long + f, bottom_corner_r);
    else
        obround(bottom_long + f + 2 * g, bottom_short + f + 2 * g);
}

module obround(l, w) {
    hull() for (s = [-1, 1]) translate([s * (l - w) / 2, 0]) circle(d = w);
}

module body() {
    chamfered_disc(flange_d, flange_h, flange_chamfer);
    translate([0, 0, flange_h - eps]) hex_boss(boss_h + eps);
}

module cuts() {
    f = hole_fit;
    rotate([0, 0, window_angle]) {
        // Side window: from the +X corner (rotated to window_angle) in past the axis
        translate([0, 0, flange_h])
            linear_extrude(window_h)
                polygon([
                    [-window_reach,     -(window_w_inner + f) / 2],
                    [hex_r + 1,         -(window_w_outer + f) / 2],
                    [hex_r + 1,          (window_w_outer + f) / 2],
                    [-window_reach,      (window_w_inner + f) / 2]
                ]);
        // Bottom socket with a bevelled entry
        rotate([0, 0, bottom_rot]) {
            translate([0, 0, -eps])
                linear_extrude(bot_depth + eps)
                    bottom_profile(0);
            c = bottom_entry_chamfer;
            if (c > 0)
                hull() {
                    translate([0, 0, -eps]) linear_extrude(eps) bottom_profile(c);
                    translate([0, 0, c]) linear_extrude(eps) bottom_profile(0);
                }
        }
    }
    // Top bore
    translate([0, 0, total_h - bore_h])
        cylinder(h = bore_h + 1, d = top_round_d + top_round_fit);
}

module shower_handle_adapter() {
    difference() { body(); cuts(); }
}

// Hex gauge: the top 4 mm of the boss, to test-fit into the handle's hex socket
module hex_gauge() {
    translate([0, 0, -(total_h - 4)])
        intersection() {
            shower_handle_adapter();
            translate([0, 0, total_h - 4]) cylinder(h = 5, d = flange_d + 1);
        }
}

// Bottom gauge: the flange only (pocket + square), to test-fit on the stem
module bottom_gauge() {
    intersection() {
        shower_handle_adapter();
        translate([0, 0, -1]) cylinder(h = flange_h + 1, d = flange_d + 1);
    }
}

module output() {
    if (part == "hex_gauge") hex_gauge();
    else if (part == "bottom_gauge") bottom_gauge();
    else shower_handle_adapter();
}

if (cutaway)
    difference() {
        output();
        rotate([0, 0, window_angle])
            translate([-flange_d, 0, -1]) cube([2 * flange_d, flange_d, total_h + 2]);
    }
else
    output();
