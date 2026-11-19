// Sony a6300 rear cooling fan: fit test (DRAFT)
// Author: Denis Shatilov
// License: CC BY-NC 4.0
// https://creativecommons.org/licenses/by-nc/4.0/
//
// A thin open-backed shell with the box's outside size, to try against the camera before printing
// the real box. Hold it in the pocket under the eyepiece, back against the magnesium plate, and
// tilt the screen: where the screen touches is how much the real box has to lose. Side depth marks
// (every 2 mm plus the 5.3 mm recess edge), front V-groove scribe marks, and 45-deg beveled blind
// "fake cutouts" for all exhaust vents and the stepped USB-C port show where every opening lands
// while keeping the shell printable without supports or overhangs. Printed front face down.

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

module blind_rect(w, h, d = mark, bx0 = mark, bx1 = mark, by0 = mark, by1 = mark) {
    // 45-deg+ beveled blind recess cutting into -Z from an outer surface at Z = 0, exact mouth [0..w, 0..h]
    eps = 0.04;
    s = eps / d;
    hull() {
        translate([-bx0 * s, -by0 * s, eps - 0.01]) cube([w + (bx0 + bx1) * s, h + (by0 + by1) * s, 0.01]);
        translate([bx0, by0, -d]) cube([w - bx0 - bx1, h - by0 - by1, 0.01]);
    }
}

module blind_rrect(w, h, r, d = 0.35) {
    // Centered rounded-rectangle blind recess into -Z with 45-deg perimeter bevel
    eps = 0.04;
    rb = max(0.2, r - d);
    hull() for (i = [-1, 1], j = [-1, 1]) {
        translate([i * (w / 2 - r), j * (h / 2 - r), eps - 0.01]) cylinder(r = r + eps, h = 0.01, $fn = 24);
        translate([i * (w / 2 - r), j * (h / 2 - r), -d]) cylinder(r = rb, h = 0.01, $fn = 24);
    }
}

module front_circle_vgroove(xc, zc, r, d = mark) {
    translate([xc, box_d + 0.02, zc]) rotate([90, 0, 0]) rotate_extrude($fn = 64)
        polygon([[max(0.05, r - d - 0.02), 0], [r, d + 0.02], [r + d + 0.02, 0]]);
}

module fit_test() {
    slant_a = atan(slant_rise / (box_d + 0.5));
    difference() {
        cube([box_w, box_d, box_h]);
        // inner cavity whose bottom follows the bevel so the sloped bottom wall stays continuous from bed to back
        rotate([90, 0, 90]) translate([0, 0, t]) linear_extrude(box_w - 2 * t)
            polygon([[-1, slant(-1) + t], [box_d - t, slant(box_d - t) + t],
                     [box_d - t, box_h - t], [-1, box_h - t]]);
        // same bottom bevel as the box
        rotate([90, 0, 90]) translate([0, 0, -1]) linear_extrude(box_w + 2)
            polygon([[-1, -1], [box_d + 1, -1], [box_d + 1, slant(box_d + 1)], [-1, slant(-1)]]);
        // side depth V-grooves: 2, 4 mm + 5.3 mm recess edge on both walls, plus 8, 10 mm ticks in left mid zone
        for (s = [[0, 1], [box_w, -1]]) {
            for (y = [2, 4]) side_vgroove(s[0], s[1], y, mark, 4, box_h - 4);
            side_vgroove(s[0], s[1], 5.3, 0.45, slant(5.3) + 0.8, box_h - 1);
        }
        for (y = [8, 10]) side_vgroove(0, 1, y, mark, usb_top - 3.0, lz0 - 0.6);
        // front-face reference 45-deg V-grooves: uncovered top band line, switch, arm pocket, fan grille & screws
        front_hgroove(2, box_w - 2, box_h - tab_band, mark - 0.04);
        front_rect_vgroove(sw_xc, sw_zc, sw_slot[0], sw_slot[1], mark);
        if (arm_mount) front_rect_vgroove(arm_xc, pin_z0 + pin_h / 2, sock_w, sock_h, mark);
        front_circle_vgroove(fan_x + fan / 2, fan_zc, (fan - 2) / 2, mark);
        for (i = [-1, 1], j = [-1, 1])
            front_circle_vgroove(fan_x + fan / 2 + i * fan_holes / 2, fan_zc + j * fan_holes / 2, fan_screw_d / 2, mark);
        // right wall fake exhaust cutouts (3 slots, X = box_w)
        if (r_slot > 0) for (i = [0 : n_right - 1])
            translate([box_w, out_y0, rz0 + i * (r_slot + rib)]) rotate([90, 0, 90])
                blind_rect(out_d, r_slot, mark);
        // top wall fake exhaust cutouts (6 slots, Z = box_h)
        translate([top_l_x0, out_y0, box_h]) blind_rect(top_l_x1 - top_l_x0, top_d_full, mark);
        translate([top_m_x0, out_y0, box_h]) blind_rect(top_m_x1 - top_m_x0, top_d_boss, mark);
        for (i = [0 : n_top_r - 1])
            translate([top_r_x0 + i * top_r_pitch, out_y0, box_h]) blind_rect(top_r_slot, top_d_full, mark);
        // left wall fake cutouts: upper exhaust slot + stepped USB-C counterbore & receptacle (X = 0)
        if (lz1 > lz0)
            translate([0, out_y1, lz0]) rotate([90, 0, -90]) blind_rect(out_d, lz1 - lz0, mark);
        translate([0, usb_yc, usb_zc]) rotate([90, 0, -90]) {
            blind_rrect(usb_cbore[1], usb_cbore[0], 2.5, 0.35);
            translate([0, 0, -0.35 + 0.01]) blind_rrect(usb_rec[2] + 0.4, usb_rec[0] + 0.4, 1.2, 0.36);
        }
        // bottom bevel fake exhaust cutouts (4 right-side slots along Y = bot_rim .. bot_y1)
        for (i = [0 : n_bot - 1])
            translate([bot_x0 + i * bot_pitch, 0, slant(0)]) rotate([slant_a, 0, 0]) mirror([0, 0, 1])
                translate([0, bot_rim / cos(slant_a), 0])
                    blind_rect(bot_slot, bot_d / cos(slant_a), mark, mark, mark, 0.8, mark);
    }
}

// front face down
translate([0, 0, box_d]) rotate([90, 0, 0]) mirror([0, 1, 0]) fit_test();
