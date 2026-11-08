// Slide-in window frame for the Surface Go (1st gen) shop screen.
//
// The flat front face goes against the inside of the window glass, taped all
// the way round (12 mm VHB, e.g. 3M 5952). The tablet slides in from the open
// top edge, between the front lip and the back lip, and rests on the bottom wall.
// The Surface Connect slot is on the tablet's right edge as seen from outside
// (looking at the screen), near the bottom. Seen from the room that is the left wall.
//
// This file renders the landscape frame (open on a long edge).
// surface-go-window-frame-portrait.scad renders the portrait one (open on a
// short edge, charger at the bottom). It reuses the modules here, so change
// dimensions in this file only.
//
// Anti-rattle: the pocket has 1 mm of front-back play. Stick a strip of 1 mm
// self-adhesive felt along the back of the tablet's top and bottom edges
// (within 6 mm of the edge, where the back rim overlaps it).
//
// Print front face down on the bed (clean, flat face for the tape). No supports:
// the back rim overhangs 2.5 mm flat, then slopes at 45 degrees.
// Strength: 4 walls (perimeters), 30% gyroid infill.
// Units mm. Coordinates as seen from the ROOM (the tablet's back) in landscape: x right,
// y up, z from the glass (0) towards the room.
//
// Licence: CC BY-NC 4.0

/* [Tablet - Surface Go 1 is 245 x 175 x 8.3] */
tab_w = 245.0;
tab_h = 175.0;
tab_t = 8.3;
clear = 1.0;           // per side around the tablet edge
play_t = 1.0;          // front-back play; a 1 mm felt strip takes it up
tab_r = 5.0;           // pocket corner radius (keep <= tablet's corner radius)

/* [Frame] */
wall = 3.5;            // side wall thickness (3.5 keeps the frame inside a 256 mm bed)
lip = 2.5;             // front lip thickness (glass side)
lip_over = 13.0;       // front lip covers the bezel this far (screen starts ~17 in)
back_flat = 2.5;       // back rim: flat overhang (prints without support)
back_over = 8.0;       // back rim: total reach over the tablet's back
back_skin = 2.0;       // back rim thickness above the 45 degree slope

/* [Cutouts - tablet edges as in landscape] */
// (room view: the charger edge is the LEFT wall, the buttons are top RIGHT)
cable_y = [-78, -18];  // Surface Connect slot in the left wall (room view), y range
btn_x = [68, 112];     // power + volume on the top edge (room view), x range

$fn = 48;

// --- derived ---------------------------------------------------------------
pw = tab_w + 2 * clear;          // pocket 247 x 177
ph = tab_h + 2 * clear;
ow = pw + 2 * wall;              // outer 254 x 184
oh = ph + 2 * wall;
o_r = tab_r + wall;

z_pocket0 = lip;
z_back = lip + tab_t + play_t;   // tablet back / start of back lip
z_slope = z_back + (back_over - back_flat);
z_top = z_slope + back_skin;

win_w = pw - 2 * lip_over;       // 221 x 151 window (screen ~211 x 141)
win_h = ph - 2 * lip_over;

echo(str("outer ", ow, " x ", oh, " x ", z_top, "  window ", win_w, " x ", win_h,
         "  tape strip ", wall + lip_over));

assert(ow <= 255 && oh <= 255, "frame no longer fits a 256 mm bed");

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
// open = "right": portrait, opening on the edge opposite the charger (room
//                 view right wall); hung so the charger edge is at the bottom
module frame(open = "top") frame_body(open);

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

        // the opening: wall removed between the lips
        if (open == "top") {
            box(-pw / 2, pw / 2, 0, big + ph / 2, z_pocket0, z_back);
        } else {
            box(0, big + pw / 2, -ph / 2, ph / 2, z_pocket0, z_back);
        }

        // Surface Connect slot (left wall seen from the room = right edge seen from outside)
        box(-ow / 2 - 1, -pw / 2 + 1, cable_y[0], cable_y[1], z_pocket0, z_back);
        // power / volume access (top edge) when the top is closed
        if (open != "top")
            box(btn_x[0], btn_x[1], ph / 2 - 1, oh / 2 + 1, z_pocket0, z_back);
    }
}

// Shown as it hangs: portrait is turned so the opening is at the top.
module frame_landscape() frame("top");
module frame_portrait() rotate([0, 0, 90]) frame("right");

frame_landscape();
