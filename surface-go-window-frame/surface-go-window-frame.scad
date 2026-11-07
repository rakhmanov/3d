// Window frame for the Surface Go (1st gen) shop screen.
//
// Glass side: front lip + skirt. Four 3M Dual Lock pads sit at
// (+-pad_c, +-pad_c) - the same spots in landscape and portrait, so the
// frame can be pulled off the glass and snapped back rotated 90 degrees.
// Room side: open back; two flexible bars snap into grooves to hold the tablet.
//
// Print orientation as modelled: back (room side) down on the bed, glass side up.
// Supports only under the front lip (it faces the tablet bezel, hidden).
// Units mm. Landscape as seen from the room: x right, y up, z towards the glass.
//
// Parts: this file renders the frame. surface-go-back-bar.scad (print 2) and
// surface-go-fit-test.scad reuse it via use<>, so change dimensions here only.
//
// Licence: CC BY-NC 4.0

/* [Tablet - Surface Go 1 is 245 x 175 x 8.3] */
tab_w = 245.0;
tab_h = 175.0;
tab_t = 8.3;
clear = 0.5;           // per side in the pocket
tab_r = 5.0;           // pocket corner radius (keep <= tablet's corner radius)

/* [Frame] */
wall = 3.0;            // side wall thickness
lip = 2.0;             // front lip thickness (glass side)
lip_over = 13.0;       // how far the lip covers the bezel (screen starts ~17 in)

/* [Back retention bars] */
ret = 1.5;             // wall material behind the groove (holds the bar in)
bar_t = 3.0;
groove_h = bar_t + 0.3;
groove_d = 1.2;        // groove depth into the long walls
bar_w = 14.0;
bar_play = 0.4;        // bar is this much shorter than groove-to-groove
tab_play = 0.5;        // front-back slack for the tablet

/* [3M Dual Lock] */
dl_mated = 5.7;        // measure your mated pair incl. both adhesives!
pad = 12.0;            // pad square size
pad_c = 81.5;          // pad centre offset from frame centre (both axes)
pad_recess = 0.4;      // shallow locating pocket for each pad
skirt_gap = 0.3;       // skirt stops this short of the glass

/* [Cutouts - landscape: right edge = Surface Connect, top-left = buttons] */
cable_y = [-55, 25];   // slot in the right wall, y range
btn_x = [-112, -68];   // slot in the top wall, x range (power + volume)

$fn = 64;

// --- derived ---------------------------------------------------------------
pw = tab_w + 2 * clear;          // pocket 246 x 176
ph = tab_h + 2 * clear;
ow = pw + 2 * wall;              // outer 252 x 182
oh = ph + 2 * wall;
o_r = tab_r + wall;

z_groove0 = ret;
z_tab0 = ret + groove_h;
z_lip0 = z_tab0 + tab_t + tab_play;
z_lip1 = z_lip0 + lip;
skirt = dl_mated - pad_recess - skirt_gap;
z_top = z_lip1 + skirt;

win_w = pw - 2 * lip_over;       // 220 x 150 window (screen ~211 x 141)
win_h = ph - 2 * lip_over;

// sanity: pad must sit inside the lip band, clear of the skirt
assert(pad_c - pad / 2 >= ph / 2 - lip_over, "pad overlaps the screen window");
assert(pad_c + pad / 2 <= ph / 2, "pad overlaps the skirt");

echo(str("outer ", ow, " x ", oh, " x ", z_top, "  window ", win_w, " x ", win_h));

// --- helpers ---------------------------------------------------------------
module rrect(w, h, r) {
    offset(r = r) square([w - 2 * r, h - 2 * r], center = true);
}

module box(x0, x1, y0, y1, z0, z1) {
    translate([x0, y0, z0]) cube([x1 - x0, y1 - y0, z1 - z0]);
}

// --- parts -----------------------------------------------------------------
module frame() {
    difference() {
        linear_extrude(z_top) rrect(ow, oh, o_r);

        // tablet pocket (open back)
        translate([0, 0, -0.01]) linear_extrude(z_lip0 + 0.01) rrect(pw, ph, tab_r);
        // screen window through the lip
        translate([0, 0, -1]) linear_extrude(z_top + 2) rrect(win_w, win_h, 3);
        // space inside the skirt, in front of the lip
        translate([0, 0, z_lip1]) linear_extrude(skirt + 1) rrect(pw, ph, tab_r);

        // bar grooves along the full length of both long walls
        for (s = [1, -1])
            box(-pw / 2 + tab_r, pw / 2 - tab_r,
                min(s * ph / 2, s * (ph / 2 + groove_d)),
                max(s * ph / 2, s * (ph / 2 + groove_d)),
                z_groove0, z_groove0 + groove_h);

        // Surface Connect slot (right wall), open from the back up to the lip
        box(pw / 2 - 1, ow / 2 + 1, cable_y[0], cable_y[1], -1, z_lip0);
        // button access (top wall)
        box(btn_x[0], btn_x[1], ph / 2 - 1, oh / 2 + 1, -1, z_lip0);

        // Dual Lock locating recesses on the lip's glass face
        for (sx = [1, -1], sy = [1, -1])
            translate([sx * pad_c, sy * pad_c, 0])
                box(-pad / 2 - 0.2, pad / 2 + 0.2, -pad / 2 - 0.2, pad / 2 + 0.2,
                    z_lip1 - pad_recess, z_lip1 + 1);
    }
}

module bar() {
    bar_len = ph + 2 * groove_d - bar_play;
    linear_extrude(bar_t) rrect(bar_w, bar_len, 2);
    linear_extrude(bar_t + 4) rrect(bar_w, 20, 2);   // finger tab to pull it out
}

// one corner of the frame, ~20 min print: check the tablet corner, lip and bar fit
module test_corner() {
    intersection() {
        frame();
        box(70, 130, 40, 95, -1, 30);
    }
}

frame();
