// Parametric Purge Bellow for Zerno Z1 Grinder (v2 funnel)
// Author: Denis Shatilov 
// License: CC BY-NC 4.0
// https://creativecommons.org/licenses/by-nc/4.0/
// You may remix, adapt, and share this work non-commercially,
// but you must give appropriate credit.

// Parameters
diameter = 58.5;           // Outer diameter (mm)
fold_sections = 5;         // Number of accordion folds
wall_thickness = 0.8;      // Wall thickness (mm)
wave_depth = 8.0;          // Depth of each accordion wave (mm)
height_per_fold = 4;       // Height of each fold (mm)
sgmt = 120;                // Number of sgmt per fold (must be even for wave)
insert_height = 10.5;      // Heigh used for inserts
solid_top = false;         // Controls whether to create hole for the funnel cap

// Derived parameters
folds = fold_sections * 2;
total_height_accordion = folds * height_per_fold;
insert_height_cap = insert_height-2.5;
starting_hight = solid_top ? 0.8 : insert_height_cap;
total_height = solid_top ? total_height_accordion + starting_hight : total_height_accordion + 2*starting_hight;
cap_insert_cutout_diameter = diameter-4.375*wall_thickness; // Cutout for cap insert
insert_lip_diameter = diameter-3.5*wall_thickness; // Width of the insert
insert_lip_cutout_diameter = diameter-7.5*wall_thickness; // Cutout from the insert


// Module for accordion shape
module accordion() {
    for(i = [0 : 1 : folds - 1]) {
        fold(i);
    }
}

module fold(i) {
    outer_d = (i % 2 == 0) ? diameter : diameter - wave_depth;
    next_outer_d = (i % 2 == 0) ? diameter - wave_depth : diameter;
    translate([0, 0, i * height_per_fold])
        difference() {
            // Outer shape
            cylinder(
                h = height_per_fold, 
                d1 = outer_d, 
                d2 = next_outer_d, 
                $fn = sgmt
            );
            
            // Inner cutout - thicker wall at bottom if it's the first fold
            translate([0, 0, -0.01])
                cylinder(
                    h = height_per_fold + 0.02, 
                    d1 = outer_d - 2*wall_thickness, 
                    d2 = next_outer_d - 2*wall_thickness, 
                    $fn = sgmt
                );
        }
}

// Module for the insert lip into the funnel
module insert_lip() {
    union() {
        // Connector to the accordion
        difference() {
            translate([0, 0, 0])
            cylinder(
                h = 1,
                d = diameter,
                $fn=100
            );
            // Removal
            translate([0, 0, -0-0.01])
                cylinder(
                    h = 1+0.02,
                    // Creating smooth transition into the accordion to avoid overhang.
                    // 4 is a magic number for the angle with 1mm height
                    d1 = insert_lip_cutout_diameter+4,
                    d2 = insert_lip_cutout_diameter,
                    $fn=100
                );
        }
        // Main body of the insert
        translate([0, 0, 1])
        difference() {
            cylinder(
                h = insert_height,
                d = insert_lip_diameter,
                $fn=100
            );
            // Removal
            translate([0, 0, -0.01])
                cylinder(h = insert_height + 0.02, d = insert_lip_cutout_diameter, $fn=100);
        }
    }
}

// Hole to insert the funnel cap
module cap_insert() {
    difference() {
        cylinder(h = insert_height_cap, d = diameter, $fn=100);
        // Removal
        translate([0,0,-0.01])
            cylinder(h = insert_height_cap + 0.02, d = cap_insert_cutout_diameter, $fn=100);
    }
}

module top_cap() {
    cylinder(h = wall_thickness, d = diameter, $fn=sgmt);
}

// Part are printed in reverse to handle overhang
module purge_bellow() {
    // Insert lip for press-fit
    translate([0,0,starting_hight + total_height_accordion])
        insert_lip();
    // Accordion body
    translate([0,0,starting_hight])
       accordion();
    // Top part
    if (solid_top) {
        top_cap();
    } else {
        cap_insert();
    }
}

// Render the bellow
purge_bellow();
