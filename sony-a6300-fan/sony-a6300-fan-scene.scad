// Sony a6300 rear cooling fan: display scene (camera + box + parts), not for printing
// Author: Denis Shatilov
// License: CC BY-NC 4.0
// https://creativecommons.org/licenses/by-nc/4.0/
//
// Box from sony-a6300-fan.scad, camera from a6300-camera.scad. The box sits under the eyecup,
// left-aligned with the LCD. The screen is drawn at the smallest tilt that clears the box
// (override with -D lcd_tilt=...).

include <sony-a6300-fan-arm.scad>

show_part = false;
show_arm = false;
arm_mount = false;        // no holder for now: the tilted-up screen holds the box
show_arm_in_scene = false;
show_camera = true;
show_cable = true;
// Cut away the box front to show the parts inside
cutaway = false;

hinge = a6300_lcd_hinge();

// The screen's real linkage is not modelled yet (see README): draw it flipped flat out of the way
lcd_tilt = 90;

// ---------- parts (box coordinates) ----------
// Noctua: beige frame, brown impeller. 3007: black frame and impeller
module fan_model() {
    c_frame = fan == 40 ? "#d6c3a3" : "#1c1c1c";
    c_blade = fan == 40 ? "#6d3a2b" : "#262626";
    translate([fan_x, air_gap, fan_zc - fan / 2]) {
        color(c_frame) difference() {
            hull() for (x = [2, fan - 2], z = [2, fan - 2]) translate([x, 0, z]) rotate([-90, 0, 0]) cylinder(r = 2, h = fan_t, $fn = 16);
            translate([fan / 2, -1, fan / 2]) rotate([-90, 0, 0]) cylinder(d = fan - 2, h = fan_t + 2);
            for (i = [-1, 1], j = [-1, 1]) translate([fan / 2 + i * fan_holes / 2, -1, fan / 2 + j * fan_holes / 2])
                rotate([-90, 0, 0]) cylinder(d = 3.2, h = fan_t + 2, $fn = 16);
        }
        color(c_frame) for (a = [45, 165, 285]) translate([fan / 2, 0, fan / 2]) rotate([0, a, 0]) translate([0, 0, -0.8]) cube([fan / 2, 1.2, 1.6]);
        translate([fan / 2, 0.5, fan / 2]) rotate([-90, 0, 0]) {
            color(c_blade) cylinder(d = fan * 0.36, h = fan_t - 1.5);
            color(c_blade) for (a = [0 : 360 / 9 : 359]) rotate([0, 0, a]) translate([fan * 0.16, -0.5, 1])
                rotate([30, 0, 0]) cube([fan * 0.31, 1, fan_t - 4]);
        }
    }
}

// SS13D07 slide switch in its cradle behind the bay's front plate, knob shown at High (right)
sw_pos = 1;   // 1 = High, 0 = Off, -1 = Low
sw_back = box_d - front - sw_body[2];
module slide_switch() {
    translate([sw_xc, 0, sw_zc]) {
        color("#b9bcc2") translate([-sw_body[0] / 2, box_d - front - 0.4, -sw_body[1] / 2]) cube([sw_body[0], 0.4, sw_body[1]]);   // metal cover
        color("#1a1a1a") translate([-sw_body[0] / 2, sw_back, -sw_body[1] / 2]) cube([sw_body[0], sw_body[2] - 0.4, sw_body[1]]);
        color("#1a1a1a") translate([sw_pos * sw_step - sw_knob[0] / 2, box_d - front, -sw_knob[1] / 2]) cube([sw_knob[0], sw_knob[2], sw_knob[1]]);
        color("#c8a24a") for (i = [0 : 3]) translate([(i - 1.5) * 2.5 - 0.3, sw_back - sw_pins, -0.4]) cube([0.6, sw_pins, 0.8]);
    }
}

module diode(p) {  // 1N4001, DO-41, lying along Z, band toward +Z
    translate(p) {
        color("#1a1a1a") cylinder(d = 2.7, h = 5.2, $fn = 20);
        color("#c9cbd0") translate([0, 0, 4.2]) cylinder(d = 2.75, h = 0.7, $fn = 20);
    }
}

module adafruit_4090() {  // PCB parallel to the front face, receptacle through the left wall
    translate([wall, usb_pcb_y, usb_zc]) {
        color("#161616") translate([0, -usb_pcb[2], -usb_pcb[0] / 2]) cube([usb_pcb[1], usb_pcb[2], usb_pcb[0]]);
        color("#c8a24a") for (s = [-1, 1]) translate([usb_hole_in, 0.01, s * usb_hole_dx / 2]) rotate([-90, 0, 0])
            difference() { cylinder(d = 4.2, h = 0.05, $fn = 24); cylinder(d = usb_hole_d, h = 1, center = true, $fn = 24); }
        color("#c8a24a") for (i = [0 : 7]) translate([usb_pcb[1] - 2.54, 0.01, (i - 3.5) * 2.54]) rotate([-90, 0, 0])
            cylinder(d = 1.6, h = 0.05, $fn = 16);
        color("#d0d0d0") for (dz = [5.8, 7.6]) translate([3.5, 0, -dz]) cube([1.6, 0.5, 0.8]);   // R1, R2 5.1k
        color("#c9cbd0") translate([-usb_thin - 0.01, 0, 0]) rrect_x(usb_rec[2], usb_rec[0], usb_rec[1], 1.4);
    }
}

module wires() {
    module run(pts, c) color(c) for (i = [0 : len(pts) - 2]) hull() { translate(pts[i]) sphere(d = 1.2, $fn = 8); translate(pts[i + 1]) sphere(d = 1.2, $fn = 8); }
    yb = usb_pcb_y - usb_pcb[2] - 0.8;   // behind the board
    py = sw_back - sw_pins;                       // switch pin tips
    yf = box_d - front - fan_t + 3;
    dz = sw_zc - 9;                               // diodes lie in the chamber, below the switch
    run([[wall + usb_pcb[1] - 2.54, yb, usb_zc + 3.8], [sw_xc - 1.25, yb, usb_zc + 3.8], [sw_xc - 1.25, py, sw_zc]], "#b02020");    // VBUS -> common
    run([[sw_xc + 3.75, py, sw_zc], [wall + bay_w + 3, yf, sw_zc], [fan_x + 3, yf, fan_zc + 2]], "#b02020");                     // H -> fan +
    run([[sw_xc - 3.75, py, sw_zc], [sw_xc - 3.75, py, dz], [wall + bay_w + 2, py, dz]], "#b02020");                             // L -> diodes
    translate([wall + bay_w + 2, py, dz]) rotate([0, 90, 0]) { diode([0, 0, 0]); diode([0, 0, 6]); }
    run([[wall + bay_w + 14, py, dz], [fan_x + 3, yf, fan_zc - 2]], "#b02020");                                                  // diodes -> fan +
    run([[wall + usb_pcb[1] - 2.54, yb, usb_zc - 3.8], [wall + bay_w, box_d - front - fan_t + 5, fan_zc - 2], [fan_x + 3, box_d - front - fan_t + 5, fan_zc - 2]], "#202020"); // GND -> fan
}

module usb_c_cable() {
    color("#3c3c3e") translate([-usb_thin - 6.65 + 0.01, usb_yc, usb_zc]) rrect_x(2.4, 8.25, 6.65, 1.1); // plug shell, hidden
    color("#5a5a5e") translate([-(wall - usb_thin) - 24, usb_yc, usb_zc]) rrect_x(usb_cbore[1] - 0.4, usb_cbore[0] - 0.6, 24, 2.4);
    color("#5a5a5e") hull() {
        translate([-(wall - usb_thin) - 23.5, usb_yc, usb_zc]) sphere(d = 4, $fn = 16);
        translate([-(wall - usb_thin) - 45, usb_yc + 4, usb_zc - 30]) sphere(d = 4, $fn = 16);
    }
}

module fan_box_assembly() {
    difference() {
        color("WhiteSmoke") box();
        if (cutaway) translate([wall + 0.5, box_d - front - 0.5, wall]) cube([box_w, front + 1, box_h - 2 * wall]);
    }
    fan_model();
    slide_switch();
    adafruit_4090();
    wires();
    if (show_cable) usb_c_cable();
}

// ---------- scene ----------
mirror([0, 1, 0]) {
    translate([box_x, 0, box_z]) { fan_box_assembly(); if (show_arm_in_scene) color("#e6e6e6") arm(); }
    if (show_camera) a6300(lcd_tilt);
}
