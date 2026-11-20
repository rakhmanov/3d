// Sony a6300 rear cooling fan: fit test 2 (DRAFT)
// Author: Denis Shatilov
// License: CC BY-NC 4.0
// https://creativecommons.org/licenses/by-nc/4.0/
//
// A thin open-backed shell with the box's outside size, to try against the camera before printing
// the real box. Fit test 2 includes the real arm pocket + fused top bearing boss (to test the
// printed shoe arm directly), staggered 1 mm side depth grooves (1, 2, 3, 4, 5.3 mm + left
// 8, 10 mm), built-in 5/10 mm X-rulers on the top-front and bottom-back edges, +2/+4 mm Z-ticks
// on the left front corner, front V-grooves, and 45-deg beveled blind fake cutouts for all
// exhaust vents, the left-wall Off/On switch slot, and the stepped USB-C port.
// Printed front face down with zero overhangs.

include <../sony-a6300-fan.scad>

show_part = false;
t = 1.2;          // shell wall (follows the bottom bevel; 3 perimeters, thick enough for V-grooves)
mark = 0.4;       // 45-deg V-groove depth
lead_r_back = 0.5; // back-edge lead-in on the right end, leaves 0.7 mm on the 1.2 mm shell wall (box: 0.8 on 1.6)

module side_vgroove(x_face, dir, yc, d, z0, z1) {
    translate([0, 0, z0]) linear_extrude(z1 - z0)
        polygon([[x_face - dir * 0.02, yc - d - 0.02], [x_face + dir * d, yc], [x_face - dir * 0.02, yc + d + 0.02]]);
}

module front_hgroove(x0, x1, zc, d) {
    rotate([90, 0, 90]) translate([0, 0, x0]) linear_extrude(x1 - x0)
        polygon([[box_d + 0.02, zc - d - 0.02], [box_d - d, zc], [box_d + 0.02, zc + d + 0.02]]);
}

module front_vgroove(xc, z0, z1, d = 0.35) {
    translate([0, 0, z0]) linear_extrude(z1 - z0)
        polygon([[xc - d - 0.02, box_d + 0.02], [xc, box_d - d], [xc + d + 0.02, box_d + 0.02]]);
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
        union() {
            difference() {
                cube([box_w, box_d, box_h]);
                // inner cavity whose bottom follows the bevel so the sloped bottom wall stays continuous from bed to back
                rotate([90, 0, 90]) translate([0, 0, t]) linear_extrude(box_w - 2 * t)
                    polygon([[-1, slant(-1) + t], [box_d - t, slant(box_d - t) + t],
                             [box_d - t, box_h - t], [-1, box_h - t]]);
            }
            // fused top bearing boss matching the real box so the printed shoe arm engages & locks
            if (arm_mount) translate([sock_x0, box_d - sock_d, sock_top_z])
                cube([sock_x1 - sock_x0, sock_d - t + 0.5, box_h - t - sock_top_z + 0.5]);
        }
        // same bottom bevel as the box
        rotate([90, 0, 90]) translate([0, 0, -1]) linear_extrude(box_w + 2)
            polygon([[-1, -1], [box_d + 1, -1], [box_d + 1, slant(box_d + 1)], [-1, slant(-1)]]);
        // same rounded leading (right) end and latch hook channel as the box
        lead_in_cut();
        latch_channel();
        // staggered 1 mm side depth V-grooves: 2, 4 mm (mid) + 1, 3 mm (upper) + 5.3 mm recess edge on both walls, plus 8, 10 mm left ticks
        for (s = [[0, 1, sw_zc - sw_slot[1] / 2 - 1.0], [box_w, -1, box_h - max(1, lead_r) - 0.3]]) {
            for (y = [2, 4]) side_vgroove(s[0], s[1], y, mark, 6, 30);
            for (y = [1, 3]) side_vgroove(s[0], s[1], y, 0.35, 30.5, 34.5);
            side_vgroove(s[0], s[1], 5.3, 0.28, slant(5.3) + max(0.8, lead_r / cos(slant_a) + 0.2), s[2]);
        }
        for (y = [8, 10]) side_vgroove(0, 1, y, mark, usb_top - 3.0, usb_top);
        // real arm pocket through-cut (test actual printed shoe-arm lock)
        if (arm_mount) translate([arm_xc - sock_w / 2, box_d - t - 0.5, pin_z0 - sock_clear])
            cube([sock_w, t + 1.5, sock_h]);
        // front-face reference 45-deg V-grooves: uncovered top band line, top 5/10 mm X-ruler, fan grille & screws
        front_hgroove(2, box_w - 2, box_h - tab_band, mark - 0.04);
        for (x = [5 : 5 : box_w - 5])
            front_vgroove(x, box_h - ((x % 10 == 0) ? 2.0 : 1.2), box_h + 0.02, 0.35);
        front_circle_vgroove(fan_x + fan / 2, fan_zc, (fan - 2) / 2, mark);
        for (i = [-1, 1], j = [-1, 1])
            front_circle_vgroove(fan_x + fan / 2 + i * fan_holes / 2, fan_zc + j * fan_holes / 2, fan_screw_d / 2, mark);
        // left-wall bottom-front Z-ticks (+2, +4 mm above bottom-front corner) for side clearance readings
        for (dz = [2, 4])
            translate([0, box_d + 0.02, slant(box_d) + dz - 0.4]) rotate([90, 0, -90])
                blind_rect(2.5, 0.8, 0.35, 0.35, 0.35, 0.35, 0.35);
        // bottom-back edge X-ruler ticks (every 5 mm, longer every 10 mm; open at Y=0 -> zero overhangs, visible from below)
        for (x = [5 : 5 : box_w - 5]) let(d = 0.35, ly = (x % 10 == 0) ? 1.35 : 0.9, L = ly / cos(slant_a))
            translate([x, 0, slant(0)]) rotate([slant_a, 0, 0]) translate([0, L, 0]) rotate([90, 0, 0])
                linear_extrude(L + 0.25)
                    polygon([[-d - 0.02, -0.02], [0, d], [d + 0.02, -0.02]]);
        // right wall fake exhaust cutouts (3 slots, X = box_w)
        if (r_slot > 0) for (i = [0 : n_right - 1])
            translate([box_w, out_y0, rz0 + i * (r_slot + rib)]) rotate([90, 0, 90])
                blind_rect(out_d, r_slot, mark);
        // top wall fake exhaust cutouts (6 slots, Z = box_h)
        translate([top_l_x0, out_y0, box_h]) blind_rect(top_l_x1 - top_l_x0, top_d_full, mark);
        translate([top_m_x0, out_y0, box_h]) blind_rect(top_m_x1 - top_m_x0, top_d_boss, mark);
        for (i = [0 : n_top_r - 1])
            translate([top_r_x0 + i * top_r_pitch, out_y0, box_h]) blind_rect(top_r_slot, top_d_full, mark);
        // left wall fake cutouts: Off/On switch slot above USB-C + stepped USB-C counterbore & receptacle (X = 0)
        translate([0, sw_yc + sw_slot[0] / 2, sw_zc - sw_slot[1] / 2]) rotate([90, 0, -90])
            blind_rect(sw_slot[0], sw_slot[1], 0.35, 0.35, 0.35, 0.35, 0.35);
        translate([0, usb_yc, usb_zc]) rotate([90, 0, -90]) {
            blind_rrect(usb_cbore[1], usb_cbore[0], 2.5, 0.35);
            translate([0, 0, -0.35 + 0.01]) blind_rrect(usb_rec[2] + 0.4, usb_rec[0] + 0.4, 1.2, 0.36);
        }
        // bottom bevel fake exhaust cutouts (4 right-side slots along Y = bot_rim .. bot_y1)
        for (i = [0 : n_bot - 1])
            translate([bot_x0 + i * bot_pitch, 0, slant(0)]) rotate([slant_a, 0, 0]) mirror([0, 0, 1])
                translate([0, bot_rim / cos(slant_a), 0])
                    blind_rect(bot_slot, bot_d / cos(slant_a), mark, mark, mark, max(mark, mark / tan(42 - slant_a)), mark);
    }
}

// front face down
translate([0, 0, box_d]) rotate([90, 0, 0]) mirror([0, 1, 0]) fit_test();
