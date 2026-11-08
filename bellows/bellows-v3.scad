// Parametric Purge Bellow for Zerno Z1 Grinder (v3: v1 folds, rounded where they tear)
// Author: Denis Shatilov
// License: CC BY-NC 4.0
// https://creativecommons.org/licenses/by-nc/4.0/
// You may remix, adapt, and share this work non-commercially,
// but you must give appropriate credit.
//
// Same fit as bellows.scad (same diameter, cap hole and funnel insert).
//  * v1 tears at the narrow rings. When you press, the inside (bore) surface of a narrow
//    ring is stretched across the layer lines, and v1's sharp crease puts all of that
//    stretch on one layer line.
//  * v2 rounded every fold to 1.75 mm and made them shallower and thicker. That left no
//    flat wall to swing, so it is about 4x stiffer than v1 and barely folds.
//  * v3 keeps v1's deep folds (stiffness goes with depth cubed), flat walls that swing
//    like hinges and v1's wall build: every layer is the same 0.8 mm wide (two 0.4 mm
//    lines), so the creases print exactly like the walls. It only rounds the creases,
//    narrow and wide rings alike, so the stretch spreads over several layers instead of
//    one. (A wall of constant thickness at right angles to the surface would print
//    0.6 mm wide at every crease: one line instead of two, right where it tears.)

// Parameters
diameter = 58.5;           // Outer diameter (mm)
fold_sections = 5;         // Number of accordion folds (same as v1)
accordion_height = 40;     // Height of the folded part (mm), same as v1
wall_thickness = 0.8;      // Wall width in each layer = two 0.4 mm lines (as v1; 0.57 mm through the 45 degree slopes)
wave_depth = 8.0;          // Narrow ring diameter = diameter - wave_depth (same as v1)
crease_radius = 1.2;       // Radius of every crease, narrow and wide rings, both surfaces (v1: 0)
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

// Walls steeper than 45 degrees from vertical would overhang too much to print.
assert(wave_depth / 2 <= height_per_fold, "wave_depth too large for this fold height: walls would pass 45 degrees");
assert(crease_radius * 2 < sqrt(2) * height_per_fold, "crease_radius leaves no flat wall between the creases");

// 2D half cross-section of the accordion: x = radius, y = height.
// Built as the solid area inside the outer surface, rounded, minus the same shape moved
// wall_thickness inwards: every horizontal slice (= printed layer) is wall_thickness wide.
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
    intersection() {
        square([r_out + 1, total_height_accordion]);
        difference() {
            rounded(crease_radius, crease_radius) polygon(outline);
            translate([-wall_thickness, 0]) rounded(crease_radius, crease_radius) polygon(outline);
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
        accordion_profile($fn = 0, $fs = 0.2, $fa = 6);
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

// Profile check: uncomment to see the cross-section in 2D
// accordion_profile($fn = 0, $fs = 0.2, $fa = 6);

// Render the bellow
purge_bellow();
