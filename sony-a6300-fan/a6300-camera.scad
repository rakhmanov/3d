// Sony a6300 display model: for showing accessories in context, not for printing
// Author: Denis Shatilov
// License: CC BY-NC 4.0
// https://creativecommons.org/licenses/by-nc/4.0/
//
// Built from Sony's spec (120.0 x 66.9 x 48.8 mm from grip to monitor, 3.0" 16:9 tilting LCD),
// calipers and photos of a real body (2026-11-18): screen recess, eyepiece, shoe, flash / MENU buttons.
// The LCD's tilt linkage is not modelled (drawn flipped flat). Positions from photos are +/- 2 mm.
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
eyecup = [3, 36, 47.5, 66.4, 9.92]; // x0, x1, z0, z1, protrusion from the plate (9.92 measured)
mount = [41, 31];               // lens axis x, z (shoe sits right above it in the top photo)

function a6300_eyecup() = eyecup;
function a6300_lcd_hinge() = [0, lcd_at[1]];   // y, z of the tilt axis (bottom-back edge of the LCD)
shoe = [mount[0], frame - 5.88 - 18, frame - 5.88];   // centre x, front y, open end 5.88 in from the back edge
function a6300_shoe() = [shoe[0], shoe[1], shoe[2], body[1]];
function a6300_menu() = [73, 50.5, 5.7];         // MENU button x, z, diameter (photo; the cardboard block under the eyepiece cleared it)
function a6300_flash() = [62, 50.5, 5.7];        // flash button
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

// lcd_tilt: 0 = closed, 90 = facing straight up. The top edge swings out and down about the hinge.
module a6300(lcd_tilt = 0, lens = true) {
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
    // back controls (on the frame): flash, MENU, AF/MF-AEL lever, then the right-hand cluster
    btn(a6300_flash()[0], a6300_flash()[1], a6300_flash()[2]);
    btn(a6300_menu()[0], a6300_menu()[1], a6300_menu()[2]);
    color(c_body) translate([79, frame, 45]) cube([10, 2, 8]);
    btn(84, 49, 5, 2.5, c_metal);
    btn(113, 47, 7, 1.5, "#7a1f1f");                      // MOVIE
    btn(103, 40, 7);                                      // Fn
    btn(103, 23, 22, 2.5);                                // control wheel
    btn(103, 23, 9, 3, c_metal);
    btn(93, 7, 6); btn(114, 7, 6);                        // playback, C2 / delete
    // strap lugs
    color(c_metal) for (x = [-2.5, body[0] + 0.5]) translate([x, -16, 55]) cube([2, 6, 6]);
    // terminal door on the left side (cable side)
    color(c_rubber) translate([-0.6, -24, 12]) cube([1, 18, 30]);
    // LCD on its hinge
    hinge = a6300_lcd_hinge();
    translate([lcd_at[0], hinge[0], hinge[1]]) rotate([-lcd_tilt, 0, 0]) translate([0, 0, -0])
        a6300_lcd();
    color(c_metal) translate([lcd_at[0] + 8, -0.5, 0]) cube([lcd[0] - 16, 1.5, 1.5]);   // hinge bracket
}

a6300(35);
