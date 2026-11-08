// Slide-in window frame for the Surface Go (1st gen) shop screen.
//
// The flat front face goes against the inside of the window glass, taped all
// the way round (12 mm VHB, e.g. 3M 5952). The tablet slides in from the open
// top edge, between the front lip and the back lip, and rests on the bottom wall.
// Right wall (as the tablet sits in landscape) has the Surface Connect slot.
//
// This file renders the landscape frame (open on a long edge).
// surface-go-window-frame-portrait.scad renders the portrait one (open on a
// short edge, charger at the bottom). It reuses the modules here, so change
// dimensions in this file only.
//
// The fit is deliberately loose. Four M4 x 20 thumbscrews go through the ears
// on the back lip and press the tablet against the front lip to stop rattles.
// Screw them straight into the 3.4 mm holes (they cut their own thread in PETG);
// put a small felt pad on the tablet under each screw tip.
//
// Print front face down on the bed (clean, flat face for the tape). No supports:
// the back lip overhangs 2.5 mm flat, then slopes at 45 degrees.
// Units mm. Tablet coordinates as seen from the room in landscape: x right,
// y up, z from the glass (0) towards the room.
//
// Licence: CC BY-NC 4.0

/* [Tablet - Surface Go 1 is 245 x 175 x 8.3] */
tab_w = 245.0;
tab_h = 175.0;
tab_t = 8.3;
clear = 1.0;           // per side around the tablet edge
play_t = 1.5;          // front-back play; the thumbscrews take it up
tab_r = 5.0;           // pocket corner radius (keep <= tablet's corner radius)

/* [Frame] */
wall = 3.0;            // side wall thickness
lip = 2.0;             // front lip thickness (glass side)
lip_over = 13.0;       // front lip covers the bezel this far (screen starts ~17 in)
back_flat = 2.5;       // back lip: flat overhang (prints without support)
back_over = 6.0;       // back lip: total reach over the tablet's back
back_skin = 1.2;       // back lip thickness above the 45 degree slope
finger_r = 18;         // finger notch in the back lip at the opening

/* [Thumbscrews] */
screw_x = 70;          // screws at x = +-screw_x on the top and bottom lips
screw_in = 7.5;        // screw centre, in from the pocket edge
screw_hole = 3.4;      // M4 straight into PETG (3.3 for PLA, 5.6 for heat-set insert)
ear_w = 22;            // ear width along the edge
ear_over = 13;         // ear reach over the tablet's back
ear_h = 14;            // ear height above the tablet's back side of the pocket

/* [Cutouts - tablet edges as in landscape] */
cable_y = [-55, 25];   // Surface Connect slot in the right wall, y range
btn_x = [-112, -68];   // power + volume on the top edge, x range

$fn = 48;

// --- derived ---------------------------------------------------------------
pw = tab_w + 2 * clear;          // pocket 246 x 176
ph = tab_h + 2 * clear;
ow = pw + 2 * wall;              // outer 252 x 182
oh = ph + 2 * wall;
o_r = tab_r + wall;

z_pocket0 = lip;
z_back = lip + tab_t + play_t;   // tablet back / start of back lip
z_slope = z_back + (back_over - back_flat);
z_top = z_slope + back_skin;

win_w = pw - 2 * lip_over;       // 220 x 150 window (screen ~211 x 141)
win_h = ph - 2 * lip_over;

echo(str("outer ", ow, " x ", oh, " x ", z_top, "  window ", win_w, " x ", win_h,
         "  tape strip ", wall + lip_over,
         "  screw: tablet back is ", z_back + ear_h - (lip + tab_t), " mm below the ear top"));

// --- helpers ---------------------------------------------------------------
module rrect(w, h, r) {
    offset(r = r) square([w - 2 * r, h - 2 * r], center = true);
}

module box(x0, x1, y0, y1, z0, z1) {
    translate([x0, y0, z0]) cube([x1 - x0, y1 - y0, z1 - z0]);
}

module slab(inset, z) {
    translate([0, 0, z]) linear_extrude(0.01)
        rrect(pw - 2 * inset, ph - 2 * inset, max(tab_r - inset, 2));
}

// --- frame -----------------------------------------------------------------
// open = "top"  : landscape, tablet slides down onto its long bottom edge
// open = "left" : portrait (tablet turned clockwise), slides down onto its
//                 charger edge, so the charger slot ends up at the bottom
module frame(open = "top") {
    difference() {
        union() {
            frame_body(open);
            ears();
        }
        screw_holes();
    }
}

module frame_body(open) {
    big = 50;
    difference() {
        linear_extrude(z_top) rrect(ow, oh, o_r);

        // screen window, all the way through
        translate([0, 0, -1]) linear_extrude(z_top + 2) rrect(win_w, win_h, 3);
        // tablet pocket
        translate([0, 0, z_pocket0]) linear_extrude(z_back - z_pocket0) rrect(pw, ph, tab_r);
        // back opening: flat overhang, then 45 degree slope, then straight up
        hull() {
            slab(back_flat, z_back - 0.01);
            slab(back_over, z_slope);
        }
        translate([0, 0, z_slope - 0.01])
            linear_extrude(z_top) rrect(pw - 2 * back_over, ph - 2 * back_over, 2);

        // the opening: wall removed between the lips, plus a finger notch
        if (open == "top") {
            box(-pw / 2, pw / 2, 0, big + ph / 2, z_pocket0, z_back);
            translate([0, oh / 2, z_back - 0.01]) cylinder(r = finger_r, h = z_top);
        } else {
            box(-big - pw / 2, 0, -ph / 2, ph / 2, z_pocket0, z_back);
            translate([-ow / 2, 0, z_back - 0.01]) cylinder(r = finger_r, h = z_top);
        }

        // Surface Connect slot (right edge of the tablet)
        box(pw / 2 - 1, ow / 2 + 1, cable_y[0], cable_y[1], z_pocket0, z_back);
        // power / volume access (top edge) when the top is closed
        if (open != "top")
            box(btn_x[0], btn_x[1], ph / 2 - 1, oh / 2 + 1, z_pocket0, z_back);
    }
}

function screw_pos() = [for (sx = [-1, 1], sy = [-1, 1])
    [sx * screw_x, sy * (ph / 2 - screw_in), sy]];

// thicker ear on the back lip for each screw: flat 2.5 mm, then 45 degrees
module ears() {
    for (p = screw_pos()) {
        sy = p[2];
        difference() {
            box(p[0] - ear_w / 2, p[0] + ear_w / 2,
                min(sy * ph / 2, sy * (ph / 2 - ear_over)),
                max(sy * ph / 2, sy * (ph / 2 - ear_over)),
                z_back, z_back + ear_h);
            hull() {
                slab(back_flat, z_back - 0.01);
                slab(ear_over, z_back + ear_over - back_flat);
            }
            translate([0, 0, z_back + ear_over - back_flat - 0.01])
                linear_extrude(ear_h) rrect(pw - 2 * ear_over, ph - 2 * ear_over, 2);
        }
    }
}

module screw_holes() {
    for (p = screw_pos())
        translate([p[0], p[1], z_back - 1]) cylinder(d = screw_hole, h = ear_h + 2, $fn = 24);
}

// Shown as it hangs: portrait is turned so the opening is at the top.
module frame_landscape() frame("top");
module frame_portrait() rotate([0, 0, -90]) frame("left");

frame_landscape();
