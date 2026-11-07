// Parametric Purge Bellow for Zerno Z1 Grinder (v3: v2 plus a hard stop)
// Author: Denis Shatilov
// License: CC BY-NC 4.0
// https://creativecommons.org/licenses/by-nc/4.0/
// You may remix, adapt, and share this work non-commercially,
// but you must give appropriate credit.
//
// The bellows is v2 (bellows-v2.scad) with a seat added inside the funnel insert.
// A separate rigid tube (bellows-v3-stop.scad, print in PLA or PETG) drops into the
// bellows and rests on that seat. Pressing the bellows down, the cap hits the tube
// after `stroke` mm, so:
//  * the folds never get crushed flat (the biggest strain on them), and
//  * a hard press ends in a rigid knock: cap -> tube -> funnel insert -> grinder,
//    which is the shock that frees stuck coffee, instead of the folds absorbing it.
//
// Fold, wall and fit settings live in bellows-v2.scad.

use <bellows-v2.scad>

// Parameters
stroke = 18;               // How far the cap travels before it hits the tube (mm). v2 crushes flat at roughly 26-28.
tube_od = 48;              // Stop tube outer diameter; keeps ~1.75 mm clear of the folds
tube_wall = 2;             // Stop tube wall (mm)
seat_inner_d = 45;         // Smallest opening left by the seat (mm)
seat_top = 1.2;            // Flat thickness above the 45 degree underside of the seat (mm)

// Derived
lip_r = v2_lip_inner_r();
seat_z = v2_lip_start_z();                       // seat starts where the insert bore starts
seat_contact_z = seat_z + (lip_r - tube_od / 2); // where the tube's outer edge touches the 45 degree seat
tube_length = seat_contact_z - v2_cap_underside_z() - stroke;

assert(tube_od / 2 < v2_fold_inner_r() - 1, "stop tube would rub the folds");
assert(seat_inner_d < tube_od - 2, "seat opening must be smaller than the tube or the tube falls through");
assert(tube_length > 5, "stroke too long for this bellows");

// Ring inside the funnel insert. Its underside is a 45 degree cone (prints without
// supports, and centers the tube); the tube rests on it.
module stop_seat() {
    r_in = seat_inner_d / 2;
    depth = lip_r - r_in;
    rotate_extrude($fn = 100)
        polygon([
            [lip_r + 0.5, seat_z],
            [lip_r + 0.5, seat_z + depth + seat_top],
            [r_in, seat_z + depth + seat_top],
            [r_in, seat_z + depth],
            [lip_r, seat_z]
        ]);
}

// Rigid stop tube (printed separately, see bellows-v3-stop.scad)
module stop_tube() {
    difference() {
        cylinder(h = tube_length, d = tube_od, $fn = 100);
        translate([0, 0, -0.01]) cylinder(h = tube_length + 0.02, d = tube_od - 2 * tube_wall, $fn = 100);
    }
}

module bellows_v3() {
    purge_bellow();
    stop_seat();
}

echo(str("v3 stop tube length: ", tube_length, " mm, stroke: ", stroke, " mm"));

bellows_v3();
