// Parametric Purge Bellow for Zerno Z1 Grinder (v2: rounded folds for TPU 95A)
// Author: Denis Shatilov
// License: CC BY-NC 4.0
// https://creativecommons.org/licenses/by-nc/4.0/
// You may remix, adapt, and share this work non-commercially,
// but you must give appropriate credit.
//
// Same fit as bellows.scad (same diameter, cap hole and funnel insert), different folds:
//  * Folds are rounded instead of sharp. A sharp crease puts all of the bending on one
//    line of plastic, right on a layer line, which is where v1 tears.
//  * wall_thickness is measured straight through the wall. In v1 it was measured
//    sideways, so the 45 degree walls were really only 0.57 mm thick.
//  * More, shallower folds over the same height, so each fold bends less per press.

// Parameters
diameter = 58.5;           // Outer diameter (mm)
fold_sections = 7;         // Number of accordion folds (v1: 5)
accordion_height = 40;     // Height of the folded part (mm), same as v1
wall_thickness = 0.7;      // Wall thickness, measured straight through the wall (mm)
wave_depth = 5.6;          // Narrow ring diameter = diameter - wave_depth (v1: 8)
crease_radius = 1.75;      // Bend radius at the middle of the wall, wide and narrow rings (v1: 0)
sgmt = 120;                // Segments around the circle
insert_height = 10.5;      // Height used for inserts
solid_top = false;         // Controls whether to create hole for the funnel cap

// Derived parameters
folds = fold_sections * 2;
height_per_fold = accordion_height / folds;
total_height_accordion = accordion_height;
insert_height_cap = insert_height-2.5;
starting_hight = solid_top ? 0.8 : insert_height_cap;
fit_wall = 0.8;            // v1 wall, kept for the cap hole and funnel insert so they fit the same
cap_insert_cutout_diameter = diameter-4.375*fit_wall; // Cutout for cap insert
insert_lip_diameter = diameter-3.5*fit_wall; // Width of the insert
insert_lip_cutout_diameter = diameter-7.5*fit_wall; // Cutout from the insert

// Dimensions other designs can read with use <bellows-v2.scad> (e.g. bellows-v3.scad)
function v2_lip_start_z() = starting_hight + total_height_accordion + 1; // where the funnel insert's straight bore starts
function v2_lip_inner_r() = insert_lip_cutout_diameter / 2;              // radius of that bore
function v2_cap_underside_z() = starting_hight;                         // underside of the cap / funnel cap
function v2_fold_inner_r() = (diameter - wave_depth) / 2 - wall_thickness; // tightest radius inside the folds

// Walls steeper than 45 degrees from vertical would overhang too much to print.
assert(wave_depth / 2 <= height_per_fold, "wave_depth too large for this fold height: walls would pass 45 degrees");
assert(crease_radius > wall_thickness / 2, "crease_radius must be larger than half the wall");

// 2D half cross-section of the accordion: x = radius, y = height.
// Built as the solid area inside the outer surface, rounded, then hollowed out by
// offsetting inwards, so the wall has the same thickness everywhere, bends included.
module accordion_profile() {
    r_out = diameter / 2;
    r_in = r_out - wave_depth / 2;
    ext = 5; // straight run past each end so the end bends round off too
    zigzag = [for (i = [0 : folds]) [(i % 2 == 0) ? r_out : r_in, i * height_per_fold]];
    outline = concat(
        [[-ext, -ext], [r_out, -ext]],
        zigzag,
        [[r_out, total_height_accordion + ext], [-ext, total_height_accordion + ext]]
    );
    // Outside surface radii: wide rings bend around the outside, narrow rings around the inside
    r_wide = crease_radius + wall_thickness / 2;
    r_narrow = crease_radius - wall_thickness / 2;

    intersection() {
        square([r_out + 1, total_height_accordion]);
        difference() {
            rounded(r_wide, r_narrow) polygon(outline);
            offset(r = -wall_thickness) rounded(r_wide, r_narrow) polygon(outline);
        }
    }
}

// Round convex corners with r_convex and concave corners with r_concave
module rounded(r_convex, r_concave) {
    offset(r = -r_concave) offset(r = r_concave)
        offset(r = r_convex) offset(r = -r_convex)
            children();
}

module accordion() {
    rotate_extrude($fn = sgmt)
        accordion_profile($fn = 0, $fs = 0.25, $fa = 6);
}

// Module for the insert lip into the funnel (unchanged from v1)
module insert_lip() {
    union() {
        // Connector to the accordion
        difference() {
            cylinder(h = 1, d = diameter, $fn=100);
            translate([0, 0, -0.01])
                cylinder(
                    h = 1+0.02,
                    // Smooth transition into the accordion to avoid overhang
                    d1 = insert_lip_cutout_diameter+4,
                    d2 = insert_lip_cutout_diameter,
                    $fn=100
                );
        }
        // Main body of the insert
        translate([0, 0, 1])
        difference() {
            cylinder(h = insert_height, d = insert_lip_diameter, $fn=100);
            translate([0, 0, -0.01])
                cylinder(h = insert_height + 0.02, d = insert_lip_cutout_diameter, $fn=100);
        }
    }
}

// Hole to insert the funnel cap (unchanged from v1)
module cap_insert() {
    difference() {
        cylinder(h = insert_height_cap, d = diameter, $fn=100);
        translate([0,0,-0.01])
            cylinder(h = insert_height_cap + 0.02, d = cap_insert_cutout_diameter, $fn=100);
    }
}

module top_cap() {
    cylinder(h = 0.8, d = diameter, $fn=sgmt);
}

// Parts are printed in reverse to handle overhang
module purge_bellow() {
    translate([0,0,starting_hight + total_height_accordion])
        insert_lip();
    translate([0,0,starting_hight])
        accordion();
    if (solid_top) {
        top_cap();
    } else {
        cap_insert();
    }
}

// Render the bellow
purge_bellow();
