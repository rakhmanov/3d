// Sony a6300 rear cooling fan: fit test (DRAFT)
// Author: Denis Shatilov
// License: CC BY-NC 4.0
// https://creativecommons.org/licenses/by-nc/4.0/
//
// A thin open-backed shell with the box's outside size, to try against the camera before printing
// the real box. Hold it in the pocket under the eyepiece, back against the magnesium plate, and
// tilt the screen: where the screen touches is how much the real box has to lose. Depth marks
// every 2 mm on the sides (the 5.3 mm mark is the recess edge) make it easy to read off.
// Printed front face down, no supports.

include <sony-a6300-fan.scad>

show_part = false;
t = 0.8;          // shell wall
mark = 0.4;       // mark groove depth

module fit_test() {
    difference() {
        cube([box_w, box_d, box_h]);
        translate([t, -1, t]) cube([box_w - 2 * t, box_d - t + 1, box_h - 2 * t]);
        // same bottom bevel as the box
        rotate([90, 0, 90]) translate([0, 0, -1]) linear_extrude(box_w + 2)
            polygon([[-1, -1], [box_d + 1, -1], [box_d + 1, slant(box_d + 1)], [-1, slant(-1)]]);
        // depth marks on both side walls: every 2 mm, long one at the 5.3 mm recess edge
        for (x = [-0.01, box_w - mark + 0.01], y = [2 : 2 : box_d - 2]) translate([x, y - 0.2, 4]) cube([mark, 0.4, box_h - 8]);
        for (x = [-0.01, box_w - mark + 0.01]) translate([x, 5.3 - 0.3, 1]) cube([mark, 0.6, box_h - 2]);
    }
}

// front face down
translate([0, 0, box_d]) rotate([90, 0, 0]) mirror([0, 1, 0]) fit_test();
