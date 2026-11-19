// Sony a6300 display model: for showing accessories in context, not for printing
// Author: Denis Shatilov
// License: CC BY-NC 4.0
// https://creativecommons.org/licenses/by-nc/4.0/
//
// Built from Sony's spec (120.0 x 66.9 x 48.8 mm from grip to monitor, 3.0" 16:9 tilting LCD),
// calipers and photos of a real body (2026-11-18): screen recess, eyepiece, shoe, flash / MENU buttons,
// plus a photo-fitted dual-hinge LCD tilt linkage (+/- 1-2 mm from side photo + cardboard test).
//
// X runs left to right seen from behind, Z is up, the back plate is at Y = 0, and the operator is at +Y.

body = [120.0, 66.9];
shell_t = 29;        // front plate to back plate
grip_t = 13;         // grip in front of the front plate (29 + 13 + 7 LCD ~= 48.8)
// The back: a magnesium plate (Y = 0) in a recess; the body frame around it stands frame mm proud
frame = 5.2;
recess = [3, 87, 2, 47.5];      // x0, x1, z0, z1 (photo / caliper)
lcd = [80, 44, 6.35];           // LCD module W x H x thickness (6.3-6.4 measured)
lcd_at = [5, 2];
lcd_view = [66.4, 37.4];        // 3.0" 16:9 active area
// Dual-hinge tilt linkage (fitted +/- 1-2 mm to side photo & cardboard test):
// lower arm pivots on the body at lcd_hinge1, stops at lcd_arm_max, and carries the LCD's upper pivot.
lcd_hinge1 = [1.5, 4.5];        // lower pivot [y, z] near the recess bottom
lcd_arm_len = 29.5;             // pivot-to-pivot length of the lower tilt arm
lcd_arm_t = 3.0;                // thickness of the tilt arm bracket
lcd_arm_w = 64;                 // width of the tilt arm bracket, centered on the LCD
lcd_pivot_from_top = 12.0;      // distance from the LCD's top edge down to the upper pivot
lcd_arm_max = 54;               // mechanical stop angle (deg back from +Z toward +Y) of the lower tilt arm
eyecup = [3, 30, 47.5, 66.4, 9.92]; // x0, x1, z0, z1, protrusion from the plate (9.92 measured; diopter sits beside it)
mount = [41, 31];               // lens axis x, z (shoe sits right above it in the top photo)

function a6300_eyecup() = eyecup;
function a6300_lcd_hinge() = lcd_hinge1;   // [y, z] of the lower tilt pivot
function a6300_lcd_arm_angle(lcd_tilt, lcd_arm = undef) =
    (lcd_arm == undef) ? max(0, min(lcd_tilt, lcd_arm_max)) : lcd_arm;
function a6300_lcd_pose(lcd_tilt, lcd_arm = undef) =
    let(
        a = a6300_lcd_arm_angle(lcd_tilt, lcd_arm),
        p1 = lcd_hinge1,
        p2 = [p1[0] + lcd_arm_len * sin(a), p1[1] + lcd_arm_len * cos(a)],
        d_top = lcd_pivot_from_top,
        d_bot = lcd[1] - d_top,
        tb = [p2[0] - d_top * sin(lcd_tilt), p2[1] + d_top * cos(lcd_tilt)],
        tf = [tb[0] + lcd[2] * cos(lcd_tilt), tb[1] + lcd[2] * sin(lcd_tilt)],
        bb = [p2[0] + d_bot * sin(lcd_tilt), p2[1] - d_bot * cos(lcd_tilt)],
        bf = [bb[0] + lcd[2] * cos(lcd_tilt), bb[1] + lcd[2] * sin(lcd_tilt)]
    ) [p1, p2, tb, tf, bb, bf, a];
function a6300_lcd_arm_top_z(y, lcd_tilt, lcd_arm = undef) =
    let(
        a = a6300_lcd_arm_angle(lcd_tilt, lcd_arm),
        y0 = lcd_hinge1[0] - (lcd_arm_t / 2) * cos(a),
        z0 = lcd_hinge1[1] + (lcd_arm_t / 2) * sin(a)
    ) (a > 0 ? z0 + (y - y0) / tan(a) : 1e6);
shoe = [mount[0], frame - 5.88 - 18, frame - 5.88];   // centre x, front y, open end 5.88 in from the back edge
function a6300_shoe() = [shoe[0], shoe[1], shoe[2], body[1]];
function a6300_menu() = [73, 52.5, 5.7];         // MENU button x, z, diameter (photo; the cardboard block under the eyepiece cleared it)
function a6300_flash() = [62, 52.5, 5.7];        // flash button
function a6300_frame() = frame;
function a6300_recess() = recess;

c_body = "#2b2b2d";
c_rubber = "#1b1b1c";
c_metal = "#8d8f93";

module rounded_slab(x0, x1, y0, y1, z0, z1, r = 4, rt = 1.5) {
    hull() {
        for (x = [x0 + r, x1 - r], y = [y0 + r, y1 - r]) {
            translate([x, y, z0]) cylinder(r = r, h = z1 - z0 - rt);
            translate([x, y, z1 - rt]) cylinder(r1 = r, r2 = r - rt, h = rt);
        }
    }
}

module btn(x, z, d, h = 1.5, c = c_body) {
    color(c) translate([x, frame, z]) rotate([-90, 0, 0]) cylinder(d = d, h = h, $fn = 32);
}

module a6300_lcd() {
    color(c_body) hull() for (x = [2, lcd[0] - 2], z = [2, lcd[1] - 2])
        translate([x, 0, z]) rotate([-90, 0, 0]) cylinder(r = 2, h = lcd[2], $fn = 16);
    color("#0e1a2a") translate([(lcd[0] - lcd_view[0]) / 2, lcd[2] - 0.2, (lcd[1] - lcd_view[1]) / 2 + 1])
        cube([lcd_view[0], 0.4, lcd_view[1]]);
    color(c_rubber) translate([lcd[0] - 6, lcd[2] - 0.5, 4]) cube([4, 0.6, 2]); // "SONY" plate hint
}

// lcd_tilt: 0 = closed, 90 = facing straight up. Lower arm tilts out up to lcd_arm_max,
// while the LCD pivots up (+lcd_tilt around X) so its top edge swings in and its bottom swings out.
module a6300(lcd_tilt = 0, lens = true, lcd_arm = undef) {
    // body shell with a recessed top-left (flash) and a raised right shoulder
    color(c_body) difference() {
        rounded_slab(0, body[0], -shell_t, frame, 0, body[1]);
        translate([recess[0], 0, recess[2]]) cube([recess[1] - recess[0], frame + 1, recess[3] - recess[2]]);   // screen recess
    }
    // grip
    color(c_rubber) rounded_slab(body[0] - 30, body[0], -shell_t - grip_t, -shell_t + 2, 0, body[1] - 3, 6, 4);
    // lens mount and lens (16-50 PZ: 64.7 x 29.9)
    translate([mount[0], -shell_t, mount[1]]) rotate([90, 0, 0]) {
        color(c_metal) cylinder(d = 60, h = 2.5);
        if (lens) {
            color(c_rubber) translate([0, 0, 2.5]) cylinder(d = 64.7, h = 29.9, $fn = 96);
            color("#3a3a3c") translate([0, 0, 2.5 + 29.9 - 0.1]) cylinder(d = 52, h = 0.2);
            color("#101828") translate([0, 0, 2.5 + 29.9]) cylinder(d = 38, h = 0.1);
        }
    }
    // top: hot shoe, mode dial, control dial, shutter + power collar on the grip
    // Multi Interface Shoe, ISO 518 size: 18.6 slot, 12.6 opening, 2 mm slot height, open at the back
    color(c_metal) translate([shoe[0], 0, body[1]]) difference() {
        translate([-11, shoe[1], 0]) cube([22, shoe[2] - shoe[1], 2.8]);
        translate([-9.3, shoe[1] + 1.5, 0.3]) cube([18.6, 30, 2.0]);
        translate([-6.3, shoe[1] + 1.5, 0.3]) cube([12.6, 30, 5]);
    }
    color(c_body) translate([96, -12, body[1]]) cylinder(d = 25, h = 6, $fn = 48);
    color(c_body) translate([78, -4, body[1]]) cylinder(d = 17, h = 4, $fn = 48);
    color(c_metal) translate([107, -shell_t - 6, body[1] - 3]) cylinder(d = 14, h = 2, $fn = 32);
    color(c_body) translate([107, -shell_t - 6, body[1] - 3]) cylinder(d = 9, h = 3.5, $fn = 32);
    // EVF eyecup with eyepiece and eye sensor
    color(c_rubber) difference() {
        rounded_slab(eyecup[0], eyecup[1], frame - 1, eyecup[4], eyecup[2], eyecup[3], 2, 0.01);
        translate([eyecup[0] + 7, eyecup[4] - 2, eyecup[2] + 6]) cube([eyecup[1] - eyecup[0] - 14, 3, eyecup[3] - eyecup[2] - 10]);
    }
    color("#101828") translate([eyecup[0] + 7, eyecup[4] - 2.1, eyecup[2] + 6]) cube([eyecup[1] - eyecup[0] - 14, 0.2, eyecup[3] - eyecup[2] - 10]);
    color("#444") for (dx = [-3, 3]) translate([(eyecup[0] + eyecup[1]) / 2 + dx, eyecup[4], eyecup[2] + 3]) rotate([-90, 0, 0]) cylinder(d = 2, h = 0.3, $fn = 12);
    // back controls (on the frame): diopter, flash, MENU, AF/MF-AEL lever, then the right-hand cluster
    btn(35.5, 52.5, 7, 1.5, c_rubber);                    // diopter wheel
    btn(a6300_flash()[0], a6300_flash()[1], a6300_flash()[2]);
    btn(a6300_menu()[0], a6300_menu()[1], a6300_menu()[2]);
    color(c_body) translate([88, frame, 49]) cube([11, 2, 7]);
    btn(93.5, 52.5, 6, 2.5, c_metal);
    btn(113, 47, 7, 1.5, "#7a1f1f");                      // MOVIE
    btn(103, 40, 7);                                      // Fn
    btn(103, 23, 22, 2.5);                                // control wheel
    btn(103, 23, 9, 3, c_metal);
    btn(93, 7, 6); btn(114, 7, 6);                        // playback, C2 / delete
    // strap lugs
    color(c_metal) for (x = [-2.5, body[0] + 0.5]) translate([x, -16, 55]) cube([2, 6, 6]);
    // terminal door on the left side (cable side)
    color(c_rubber) translate([-0.6, -24, 12]) cube([1, 18, 30]);
    // LCD on its dual-hinge tilt linkage
    pose = a6300_lcd_pose(lcd_tilt, lcd_arm);
    p1 = pose[0];
    p2 = pose[1];
    arm_a = pose[6];
    arm_x0 = lcd_at[0] + (lcd[0] - lcd_arm_w) / 2;
    d_bot = lcd[1] - lcd_pivot_from_top;
    color(c_rubber) translate([arm_x0, p1[0], p1[1]]) rotate([-arm_a, 0, 0]) difference() {
        union() {
            translate([0, -lcd_arm_t / 2, 0]) cube([lcd_arm_w, lcd_arm_t, lcd_arm_len]);
            for (z = [0, lcd_arm_len]) translate([0, 0, z]) rotate([0, 90, 0]) cylinder(d = lcd_arm_t, h = lcd_arm_w, $fn = 16);
        }
        for (x0 = [8, 38]) translate([x0, -lcd_arm_t, 6]) cube([18, 2 * lcd_arm_t, 16]);
    }
    color(c_metal) translate([arm_x0 + 4, p1[0], p1[1]]) rotate([0, 90, 0]) cylinder(d = 2.0, h = lcd_arm_w - 8, $fn = 16);
    translate([lcd_at[0], p2[0], p2[1]]) rotate([lcd_tilt, 0, 0]) translate([0, 0, -d_bot])
        a6300_lcd();
}

a6300(65);
