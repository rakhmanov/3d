// Shower / tub valve handle adapter (round flange + 7-cornered boss with a side window)
// Author: Denis Shatilov
// License: CC BY-NC 4.0
// https://creativecommons.org/licenses/by-nc/4.0/
//
// Boss, window depth, height, stem and worn bore measured with calipers 2026-11-11;
// the rest is still estimated from photos (README.md). Print flange-down, no supports.
//
// Section through the window (window points at -X, on a slanted boss face):
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
// Window height, from the flange top up
window_h = 2.6;
// Opening starts this fraction along the first edge, past the point
window_start_frac = 0.35;
// and ends this fraction down the side wall on the other side. Side walls are square to their faces
window_end_frac = 0.75;
// Window back wall to the far side of the boss (the screw opening's depth). Measured
window_back = 11.09;
// Direction the window faces, degrees
window_angle = 180;

/* [Bottom socket] */
// Hollow from below (the stem's base fits here). Equal long and short sides = round
bottom_shape = "obround"; // [obround, square]
// Long side (obround: end to end; square: across flats). ~10 hole on the lip face, from a photo
bottom_long = 9.8;
// Short side, across the straight sides
bottom_short = 9.8;
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
// Added to the boss size for printing. 0: the measured part is already worn, so it reads small
hex_fit = 0;
// Added to the other hole sizes for printing (positive = looser)
hole_fit = 0.2;

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
// Back wall square to the opening's centre line, window_back from the boss's far side
win_wall = min([for (p = boss_pts) p * unit(win_mid)]) + window_back;
frame_rot = window_angle - win_mid;
boss_h   = total_h - flange_h;
bot_depth = bottom_depth < 0 ? flange_h + window_h : bottom_depth;
bore_h   = top_round_h  < 0 ? boss_h - window_h  : top_round_h;

assert(hex_r * 2 < flange_d, "Boss corners overhang the flange");
assert(bore_h + window_h >= boss_h - eps || bore_h + window_h < boss_h - 1, "Top bore stops less than 1 mm short of the window");
assert(bottom_long + 2 * bottom_entry_chamfer < 2 * boss_inr - 1, "Bottom socket leaves a too-thin wall under the hex");

echo(str("Adapter: flange ", flange_d, " x ", flange_h, ", boss ", n_pts, " corners, r ", boss_corner_r,
         ", top round ", boss_top_round, ", taper ", hex_taper, ", height ", boss_h, ", total ", total_h,
         ", stem bore ", top_round_d + top_round_fit, ", window ", round(win_a1 - win_a0), " deg wide x ", window_h,
         ", back wall ", round(win_wall * 100) / 100, " from centre"));

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

module window_2d() {
    intersection() {
        half_plane(win_start, boss_pts[0] - boss_pts[1]);
        half_plane(win_end, boss_pts[n_pts - 1] - boss_pts[n_pts - 2]);
        half_plane(win_wall * unit(win_mid), unit(win_mid));
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
    rotate(frame_rot) translate([0, 0, flange_h]) linear_extrude(window_h) window_2d();
    rotate([0, 0, window_angle]) {
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
