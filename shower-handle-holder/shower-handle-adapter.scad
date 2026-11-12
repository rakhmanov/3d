// Shower / tub valve handle adapter (round flange + 7-cornered boss with a side window)
// Author: Denis Shatilov
// License: CC BY-NC 4.0
// https://creativecommons.org/licenses/by-nc/4.0/
//
// Measured with calipers 2026-11-11, except the stem's round diameter (estimated from the
// worn bore) and the window span (marked on a render). Print flange-down, no supports.
//
// Top 2 mm of the hole is round (the flats' width): the stem end seats on its ledge.
//
// Section through the window (window points at -X, on a slanted boss face):
//
//        _____          _____
//       |     |        |     |  <- stem slot: the stem's double-D shape, up to the round top bore
//   ____|     |        |     |
//  |window               |___|  <- window: one side only, floor = flange top,
//  |_______              |____     opens into the slot so the screw reaches the bar
//  |_______|  |      |   |____|  <- flange
//            /________\          bevelled entry from below

/* [Flange] */
// Flange outer diameter. Measured
flange_d = 22.0;
// Flange (lip) thickness. Measured
flange_h = 3.9;
// Chamfer on flange top and bottom edges
flange_chamfer = 0.5;

/* [Boss] */
// Symmetric 7-cornered outline, point up: drawn shape, face lengths solved from the caliper widths.
// The bore sits at the outline's area centre.
// The window is on the upper-left face and wraps over the point.
// Each upper face, point to wall top
boss_top_side = 8.79;
// Each lower face, wall bottom to the bottom flat
boss_low_side = 5.93;
// Bottom flat
boss_bottom = 7.37;
// Across the side walls at their top and bottom ends; they close in slightly toward the bottom
boss_width_top = 14.38;
boss_width_bottom = 14.18;
// Side wall length. Measured
boss_wall = 6.0;
// Rounding on the vertical corners (fit to the side lengths)
boss_corner_r = 0.6;
// Rounding on the top edge, the end that goes into the handle. Measured
boss_top_round = 1.0;
// Overall height, flange bottom to boss top. Measured
total_h = 14.0;
// Width lost toward the top. The original looks deliberately skewed to wedge in
hex_taper = 0;

/* [Side window] */
// Window height, from the flange top up. Measured
window_h = 5.7;
// Opening starts this fraction along the first edge, past the point
window_start_frac = 0.35;
// and ends this fraction down the side wall on the other side. Side walls are square to their faces
window_end_frac = 0.75;
// How far the window cuts past the centre, into and across the stem slot
window_depth = 2.0;
// Side walls lean in going up, degrees from vertical, so the boss overhangs them at an angle
// instead of standing square over the opening. The top edge stays put; the window widens at the flange
window_flare = 12;
// Direction the window faces, degrees
window_angle = 180;

/* [Bottom socket] */
// Stem slot, up to the round top bore: the stem is a double-D, a round shaft with two flats
bottom_shape = "double_d"; // [double_d, rect, obround]
// Round diameter of the stem. Estimate: the worn hole turned round at ~10
bottom_long = 10.0;
// Across the flats. Measured on the stem; this slot must be tight, the original wore here
bottom_short = 6.44;
// Corner radius for the rect shape; the bar's corners are only slightly rounded
bottom_corner_r = 1.0;
// Bevel at the socket entry
bottom_entry_chamfer = 0.8;
// Top of the hole: round for this height, so the stem end sits on the ledge where the slot steps in
top_round_h = 2.0;
// Round top bore diameter. Equal to the flats, so only the round ends of the stem stop on the ledge
top_round_d = 6.44;
// Slot angle, degrees. 0 = the stem's long (round) axis points at the top corner of the right side wall.
// Test fit 2026-11-11: the old angle (square to the upper-right face) left the handle ~28 degrees off
bottom_rot = 0;

/* [Print fit] */
// Added to the boss size for printing (across any two faces). At 0 the first print would not go into the handle
hex_fit = -0.2;
// Added to the stem slot for printing. Small: the slot must grip the bar
hole_fit = 0.1;

/* [Output] */
// adapter = the real part. hex_gauge / bottom_gauge = thin, fast fit tests
part = "adapter"; // [adapter, hex_gauge, bottom_gauge]
// Cut away half along the window axis to see the inside (preview only)
cutaway = false;

$fn = 96;
eps = 0.01;

function unit(a) = [cos(a), sin(a)];
function edge_dist(a, b) = abs(cross(b - a, -a)) / norm(b - a);
// Sharp corners clockwise from the point
function boss_raw() =
    let(xu = boss_width_top / 2, xl = boss_width_bottom / 2, xb = boss_bottom / 2,
        yu = sqrt(pow(boss_wall, 2) - pow(xu - xl, 2)),
        yb = -sqrt(pow(boss_low_side, 2) - pow(xl - xb, 2)),
        yp = yu + sqrt(pow(boss_top_side, 2) - pow(xu, 2)))
    [[0, yp], [xu, yu], [xl, 0], [xb, yb], [-xb, yb], [-xl, 0], [-xu, yu]];
// Area centroid height of a polygon: the bore goes here, so the faces sit evenly round it
function centroid_y(q) =
    let(n = len(q), c = [for (i = [0 : n - 1]) q[i][0] * q[(i + 1) % n][1] - q[(i + 1) % n][0] * q[i][1]])
    sum([for (i = [0 : n - 1]) (q[i][1] + q[(i + 1) % n][1]) * c[i]]) / (3 * sum(c));
function sum(v) = len(v) == 0 ? 0 : v[0] + sum([for (i = [1 : 1 : len(v) - 1]) v[i]]);
function boss_corners() = let(q = boss_raw(), cy = centroid_y(q)) [for (p = q) [p[0], p[1] - cy]];
boss_pts = boss_corners();
n_pts    = len(boss_pts);
hex_r    = max([for (p = boss_pts) norm(p)]);
boss_inr = min([for (i = [0 : n_pts - 1]) edge_dist(boss_pts[i], boss_pts[(i + 1) % n_pts])]);
// Window in the outline's frame: from window_start_frac along the first edge, round past the
// point, to window_end_frac down the side wall; each side wall is square to its face.
win_start = boss_pts[0] + window_start_frac * (boss_pts[1] - boss_pts[0]);
win_end  = boss_pts[n_pts - 1] + window_end_frac * (boss_pts[n_pts - 2] - boss_pts[n_pts - 1]);
win_a0   = atan2(win_start[1], win_start[0]);
win_a1r  = atan2(win_end[1], win_end[0]);
win_a1   = win_a1r < win_a0 ? win_a1r + 360 : win_a1r;
win_mid  = (win_a0 + win_a1) / 2;
// Back wall square to the opening's centre line, window_depth past the centre
win_wall = -window_depth;
frame_rot = window_angle - win_mid;
// Stem slot long axis in the outline frame: through the corner at the top of the right side wall
slot_axis = atan2(boss_pts[1][1], boss_pts[1][0]);
boss_h   = total_h - flange_h;

assert(hex_r * 2 < flange_d, "Boss corners overhang the flange");
assert(top_round_h < total_h - flange_h - window_h, "Round top bore runs into the window");
assert(bottom_long + 2 * bottom_entry_chamfer < 2 * boss_inr - 1, "Bottom socket leaves a too-thin wall under the hex");

echo(str("Adapter: flange ", flange_d, " x ", flange_h, ", boss ", n_pts, " corners, r ", boss_corner_r,
         ", top round ", boss_top_round, ", taper ", hex_taper, ", height ", boss_h, ", total ", total_h,
         ", stem slot ", bottom_long + hole_fit, " x ", bottom_short + hole_fit,
         ", top bore ", top_round_d + hole_fit, " x ", top_round_h, ", window ", round(win_a1 - win_a0), " deg wide x ", window_h,
         ", depth ", window_depth, " past centre"));

module chamfered_disc(d, h, c) {
    hull() {
        translate([0, 0, c]) cylinder(h = h - 2 * c, d = d);
        cylinder(h = h, d = d - 2 * c);
    }
}

// Boss outline grown by g, turned so the window faces window_angle
module boss_profile(g) {
    rc = boss_corner_r;
    rotate(frame_rot) offset(r = rc) offset(delta = g + hex_fit / 2 - rc) polygon(boss_pts);
}

module boss_slice(g, z) { translate([0, 0, z]) linear_extrude(eps) boss_profile(g); }

module hex_boss(h) {
    r = boss_top_round;
    t = -hex_taper / 2;
    hull() {
        boss_slice(0, 0);
        for (a = [0 : 15 : 90])
            boss_slice(t - r * (1 - cos(a)), h - r + r * sin(a) - (a == 90 ? eps : 0));
    }
}

// Window wedge in the outline frame, cut back to its wall
// Half-plane of points p with (p - q) . n >= 0
module half_plane(q, n) {
    big = 2 * flange_d;
    translate(q) rotate(atan2(n[1], n[0])) translate([0, -big]) square([big, 2 * big]);
}


// Window outline, its two side walls moved in by d
module window_2d(d) {
    n0 = boss_pts[0] - boss_pts[1];
    n1 = boss_pts[n_pts - 1] - boss_pts[n_pts - 2];
    intersection() {
        half_plane(win_start + d * n0 / norm(n0), n0);
        half_plane(win_end + d * n1 / norm(n1), n1);
        half_plane(win_wall * unit(win_mid), unit(win_mid));
    }
}

// Bottom socket outline, grown by g on every side
module bottom_profile(g) {
    f = hole_fit;
    if (bottom_shape == "double_d")
        intersection() {
            circle(d = bottom_long + f + 2 * g);
            square([bottom_long + f + 2 * g, bottom_short + f + 2 * g], center = true);
        }
    else if (bottom_shape == "rect")
        offset(delta = g) offset(r = bottom_corner_r) square([bottom_long + f, bottom_short + f] - 2 * [1, 1] * bottom_corner_r, center = true);
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
    rotate(frame_rot) translate([0, 0, flange_h]) hull() {
        linear_extrude(eps) window_2d(-window_h * tan(window_flare));
        translate([0, 0, window_h - eps]) linear_extrude(eps) window_2d(0);
    }
    // Round top bore; the stem seats against its ledge
    translate([0, 0, total_h - top_round_h - eps]) cylinder(h = top_round_h + 1, d = top_round_d + f);
    // Stem slot up to the round top bore, the bar's own shape, with a bevelled entry
    rotate([0, 0, frame_rot + slot_axis + bottom_rot]) {
            translate([0, 0, -eps]) linear_extrude(total_h - top_round_h + eps) bottom_profile(0);
            c = bottom_entry_chamfer;
            if (c > 0)
                hull() {
                    translate([0, 0, -eps]) linear_extrude(eps) bottom_profile(c);
                    translate([0, 0, c]) linear_extrude(eps) bottom_profile(0);
                }
    }
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
