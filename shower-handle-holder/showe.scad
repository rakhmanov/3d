$fn = 96;

flange_d = 20.0;
flange_h = 3.8;

boss_af = 12.0;
boss_h = 6.2;

square_broach = 5.3;

top_round_d = 6.4;
top_round_h = 2.4;

bottom_oval_x = 8.8;
bottom_oval_y = 5.2;
bottom_oval_h = 6.5;

cutout_h = 2.8;
cutout_z = flange_h + 1.45;
cutout_inset_from_side_vertex = 1.15;
cutout_back_stop = 0.75;
cutout_front_extra = 0.6;

flange_chamfer = 0.45;
boss_top_chamfer = 0.35;

clearance_extra = 0.02;

total_h = flange_h + boss_h;
boss_r = boss_af / sqrt(3);

module chamfered_cylinder(d, h, c) {
    cylinder(h = c, d1 = d - 2*c, d2 = d);

    translate([0, 0, c])
        cylinder(h = h - 2*c, d = d);

    translate([0, 0, h - c])
        cylinder(h = c, d1 = d, d2 = d - 2*c);
}

module straight_hex_af(af, h, top_c) {
    r_mid = af / sqrt(3);
    r_top = (af - 2*top_c) / sqrt(3);

    cylinder(h = h - top_c, r = r_mid, $fn = 6);

    translate([0, 0, h - top_c])
        cylinder(h = top_c, r1 = r_mid, r2 = r_top, $fn = 6);
}

module square_broach_cut() {
    translate([0, 0, -1])
        linear_extrude(height = total_h + 2)
            square([
                square_broach + clearance_extra,
                square_broach + clearance_extra
            ], center = true);
}

module top_round_cut() {
    translate([0, 0, total_h - top_round_h])
        cylinder(h = top_round_h + 1, d = top_round_d);
}

module bottom_oval_cut() {
    translate([0, 0, -0.1])
        linear_extrude(height = bottom_oval_h + 0.1)
            hull() {
                translate([-bottom_oval_x/2 + bottom_oval_y/2, 0])
                    circle(d = bottom_oval_y);

                translate([ bottom_oval_x/2 - bottom_oval_y/2, 0])
                    circle(d = bottom_oval_y);
            }
}

module wide_hex_side_cutout_cut() {
    y_front = -boss_af / 2 - cutout_front_extra;
    y_back = cutout_back_stop;

    x_side = boss_r * cos(30) - cutout_inset_from_side_vertex;
    x_back = x_side - 1.8;

    translate([0, 0, cutout_z - cutout_h / 2])
        linear_extrude(height = cutout_h)
            polygon(points = [
                [-x_side, y_front],
                [ x_side, y_front],
                [ x_back, y_back],
                [-x_back, y_back]
            ]);
}

module adapter_body() {
    union() {
        chamfered_cylinder(
            d = flange_d,
            h = flange_h,
            c = flange_chamfer
        );

        translate([0, 0, flange_h])
            straight_hex_af(
                af = boss_af,
                h = boss_h,
                top_c = boss_top_chamfer
            );
    }
}

module faucet_handle_adapter() {
    difference() {
        adapter_body();

        square_broach_cut();
        top_round_cut();
        bottom_oval_cut();
        wide_hex_side_cutout_cut();
    }
}

faucet_handle_adapter();
