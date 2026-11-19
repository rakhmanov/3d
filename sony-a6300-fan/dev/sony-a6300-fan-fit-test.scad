// Sony a6300 rear cooling fan: fit test (DRAFT)
// Author: Denis Shatilov
// License: CC BY-NC 4.0
// https://creativecommons.org/licenses/by-nc/4.0/
//
// A thin open-backed shell with the box's outside size, to try against the camera before printing
// the real box. Hold it in the pocket under the eyepiece, back against the magnesium plate, and
// tilt the screen: where the screen touches is how much the real box has to lose. Depth marks
// every 2 mm on the sides (the 5.3 mm mark is the recess edge) and front scribe V-grooves make it
// easy to read off. Printed front face down, no supports.

include <../sony-a6300-fan.scad>

show_part = false;
t = 1.2;          // shell wall (follows the bottom bevel; 3 perimeters, thick enough for V-grooves)
mark = 0.4;       // 45-deg V-groove depth

module side_vgroove(x_face, dir, yc, d, z0, z1) {
    translate([0, 0, z0]) linear_extrude(z1 - z0)
        polygon([[x_face - dir * 0.02, yc - d - 0.02], [x_face + dir * d, yc], [x_face - dir * 0.02, yc + d + 0.02]]);
}

module front_hgroove(x0, x1, zc, d) {
    rotate([90, 0, 90]) translate([0, 0, x0]) linear_extrude(x1 - x0)
        polygon([[box_d + 0.02, zc - d - 0.02], [box_d - d, zc], [box_d + 0.02, zc + d + 0.02]]);
}

module front_rect_vgroove(xc, zc, w, h, d) {
    dm = d + 0.02;
    ym = box_d + 0.02;
    ya = box_d - d;
    hw = w / 2;
    hh = h / 2;
    pts = [
        [xc - hw - dm, ym, zc - hh - dm], [xc + hw + dm, ym, zc - hh - dm],
        [xc + hw + dm, ym, zc + hh + dm], [xc - hw - dm, ym, zc + hh + dm],
        [xc - hw + dm, ym, zc - hh + dm], [xc + hw - dm, ym, zc - hh + dm],
        [xc + hw - dm, ym, zc + hh - dm], [xc - hw + dm, ym, zc + hh - dm],
        [xc - hw,      ya, zc - hh],      [xc + hw,      ya, zc - hh],
        [xc + hw,      ya, zc + hh],      [xc - hw,      ya, zc + hh]
    ];
    faces = [
        for (k = [0 : 3]) let(n = (k + 1) % 4) [k, n, 4 + n, 4 + k],       // mouth at +Y (CW from outside)
        for (k = [0 : 3]) let(n = (k + 1) % 4) [k, 8 + k, 8 + n, n],       // outer 45-deg slope
        for (k = [0 : 3]) let(n = (k + 1) % 4) [4 + k, 4 + n, 8 + n, 8 + k] // inner 45-deg slope
    ];
    polyhedron(points = pts, faces = faces, convexity = 4);
}

module fit_test() {
    difference() {
        cube([box_w, box_d, box_h]);
        // inner cavity whose bottom follows the bevel so the sloped bottom wall stays continuous from bed to back
        rotate([90, 0, 90]) translate([0, 0, t]) linear_extrude(box_w - 2 * t)
            polygon([[-1, slant(-1) + t], [box_d - t, slant(box_d - t) + t],
                     [box_d - t, box_h - t], [-1, box_h - t]]);
        // same bottom bevel as the box
        rotate([90, 0, 90]) translate([0, 0, -1]) linear_extrude(box_w + 2)
            polygon([[-1, -1], [box_d + 1, -1], [box_d + 1, slant(box_d + 1)], [-1, slant(-1)]]);
        // 45-deg depth V-grooves on both side walls: every 2 mm, deeper/longer at the 5.3 mm recess edge
        for (s = [[0, 1], [box_w, -1]]) {
            for (y = [2 : 2 : box_d - 2]) side_vgroove(s[0], s[1], y, mark, 4, box_h - 4);
            side_vgroove(s[0], s[1], 5.3, 0.55, slant(5.3) + 0.8, box_h - 1);
        }
        // front-face reference 45-deg V-grooves: uncovered top band line, switch slot outline, fan grille circle
        front_hgroove(2, box_w - 2, box_h - tab_band, mark - 0.04);
        front_rect_vgroove(sw_xc, sw_zc, sw_slot[0], sw_slot[1], mark);
        let(r = (fan - 2) / 2)
        translate([fan_x + fan / 2, box_d + 0.02, fan_zc]) rotate([90, 0, 0]) rotate_extrude($fn = 64)
            polygon([[r - mark - 0.02, 0], [r, mark + 0.02], [r + mark + 0.02, 0]]);
    }
}

// front face down
translate([0, 0, box_d]) rotate([90, 0, 0]) mirror([0, 1, 0]) fit_test();
