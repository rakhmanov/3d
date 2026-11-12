// Battery holder tray: 9V compartments, coin cell slots, AA and AAA in scalloped rows.
// Author: Denis Shatilov
// License: CC BY-NC 4.0
// https://creativecommons.org/licenses/by-nc/4.0/
//
// Layout (seen from the front, x right, y to the back):
//   left column: 3 snug 9V compartments, one behind the other, long side front to back
//   back strip:  coin cell slots (CR2032 / CR2025 / CR2016 on edge)
//   middle:      2 rows of AA, front: 2 rows of AAA
// Each AA/AAA row is a scalloped trench: round holes joined by a narrower slot. The slot
// is narrower than the battery, so every battery still sits in its own hole. Each row
// is shifted half a hole against the row in front, so the walls between rows wave.
//
// Print-speed choices that don't change the look:
//  * The joining slot makes each row one perimeter loop instead of 6-8 small circles:
//    far fewer retractions, travels and short segments.
//  * Rows are shifted half a hole and pulled together until the wall between them is
//    min_wall at its narrowest. The wavy wall is close to constant thickness, so it
//    prints as perimeters with little or no infill and the tray is shallower.
//  * min_wall (and coin_wall) is a whole number of lines (4 = two perimeters from each side), so the
//    narrow spots are not gap-filled.
//  * Closed flat floor, one top height, no overhangs, no supports.
// Slicer: 2 walls, 10-15 % infill, 0.2-0.28 mm layers. Set line_w to your wall line width.

/* [Print] */
line_w = 0.45;          // slicer wall line width (0.42 Bambu/Orca, 0.45 PrusaSlicer)
floor_t = 1.2;          // closed bottom
height = 20;            // overall height
border = 4;             // outer wall
inner_wall = 2.4;       // wall between the 9V compartments
col_gap = 6;            // flat strip between the 9V column and the battery rows
corner_r = 8;           // outer corner radius
top_r = 1;              // rounded top outer edge

/* [Fit] */
clr = 0.8;              // added to battery diameters / sizes
neck = 0.7;             // joining slot width, as a fraction of the hole diameter
nine_clr = 0.2;         // added to the 9V size: snug, the battery should not rattle
coin_clr = 0.6;         // added to the coin diameter (slot length front to back)

/* [Counts] */
aa_n = 6;               // per row
aa_rows = 2;
aaa_n = 8;              // per row
aaa_rows = 2;
nine_v_n = 3;           // snug compartments, one behind the other (tray grows deeper if needed)
coin_depth = 12;        // coin slot depth from the top (coins stick out about 40 %)

// Battery sizes
aa_d = 14.5;
aaa_d = 10.5;
nine_v = [17.5, 26.5];  // x (along the front), y: rotated, long side front to back
coin = [3.2, 20.0];     // thickness, diameter

$fn = 64;

// --- derived ---------------------------------------------------------------
min_wall = 4 * line_w;
col_w = nine_v[0] + nine_clr;                 // left column inner width
nine_d = nine_v[1] + nine_clr;                // one 9V compartment, front to back
col_need = nine_v_n * nine_d + (nine_v_n - 1) * inner_wall;
xm = border + col_w + col_gap;           // main area starts here
coin_wall = 6 * line_w;                  // walls between coin slots (3 lines from each side)

function hole(d) = d + clr;
function pitch(d) = hole(d) + min_wall;
// spacing of two rows shifted half a pitch, wall min_wall at the narrowest
function s_rows(d) = sqrt(pow(hole(d) + min_wall, 2) - pow(pitch(d) / 2, 2));
function span(d, n) = (n - 1) * pitch(d) + pitch(d) / 2 + hole(d);

main_w = max(span(aa_d, aa_n), span(aaa_d, aaa_n));
w = xm + main_w + border;

aaa_y = [for (k = [0 : aaa_rows - 1]) border + hole(aaa_d) / 2 + k * s_rows(aaa_d)];
aa_y0 = aaa_y[aaa_rows - 1] + hole(aaa_d) / 2 + min_wall + hole(aa_d) / 2;
aa_y = [for (k = [0 : aa_rows - 1]) aa_y0 + k * s_rows(aa_d)];
// coin slots are just one coin diameter long; when the 9V column is deeper than the
// battery rows, the spare depth widens the wall between the AA rows and the coin slots
coin_len = coin[1] + coin_clr;
main_back = aa_y[aa_rows - 1] + hole(aa_d) / 2 + min_wall + coin_len;
spare = max(0, border + col_need - main_back);
coin_y0 = aa_y[aa_rows - 1] + hole(aa_d) / 2 + min_wall + spare;
inner_back = coin_y0 + coin_len;
d = inner_back + border;

coin_w = coin[0] + 0.6;
coin_count = floor((main_w + coin_wall) / (coin_w + coin_wall));
coin_x0 = xm + (main_w - (coin_count * (coin_w + coin_wall) - coin_wall)) / 2;

// snug 9V compartments at the back of the column, what is left in front is a small bin
nine_y0 = inner_back - nine_v_n * nine_d - (nine_v_n - 1) * inner_wall;
bin_d = nine_y0 - inner_wall - border;   // small bin in front when the column has room

module rrect(x, y, r) {
    translate([r, r]) offset(r = r) square([x - 2 * r, y - 2 * r]);
}

// outer body: rounded corners, top outer edge rounded by top_r (stepped, no overhang)
module body() {
    steps = 6;
    z0 = height - top_r;
    linear_extrude(z0) rrect(w, d, corner_r);
    for (i = [1 : steps]) {
        dz = top_r * i / steps;
        inset = top_r - sqrt(top_r * top_r - dz * dz);
        translate([0, 0, z0 + top_r * (i - 1) / steps - 0.001])
            linear_extrude(top_r / steps + 0.001)
                translate([inset, inset]) rrect(w - 2 * inset, d - 2 * inset, corner_r - inset);
    }
}

// scalloped rows: holes joined by a slot, every other row shifted half a pitch
module scallop_rows(dia, n, ys) {
    D = hole(dia);
    P = pitch(dia);
    x0 = xm + (main_w - span(dia, n)) / 2 + D / 2;
    for (k = [0 : len(ys) - 1]) {
        xs = x0 + (k % 2) * P / 2;
        translate([0, ys[k], floor_t]) {
            for (i = [0 : n - 1]) translate([xs + i * P, 0, 0]) cylinder(d = D, h = height);
            translate([xs, -neck * D / 2, 0]) cube([(n - 1) * P, neck * D, height]);
        }
    }
}

module tray() {
    difference() {
        body();

        // 9V compartments (back) and small bin (front), left column
        for (i = [0 : nine_v_n - 1])
            translate([border, nine_y0 + i * (nine_d + inner_wall), floor_t])
                cube([col_w, nine_d, height]);
        if (bin_d > 5)
            translate([border, border, floor_t]) cube([col_w, bin_d, height]);

        // coin slots
        for (i = [0 : coin_count - 1])
            translate([coin_x0 + i * (coin_w + coin_wall), coin_y0, height - coin_depth])
                cube([coin_w, coin_len, height]);

        scallop_rows(aa_d, aa_n, aa_y);
        scallop_rows(aaa_d, aaa_n, aaa_y);
    }
}

tray();

echo(str("9V pocket ", col_w, " x ", nine_d, bin_d > 5 ? str(", bin ", col_w, " x ", bin_d) : "", "; Tray ", w, " x ", d, " x ", height, " mm; ", aa_rows * aa_n, " AA, ",
         aaa_rows * aaa_n, " AAA, ", nine_v_n, " 9V, ", coin_count, " coin cells"));
