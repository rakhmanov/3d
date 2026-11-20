// Casting mold for a silicone Zerno Z1 purge bellows
// Author: Denis Shatilov
// License: CC BY-NC 4.0
// https://creativecommons.org/licenses/by-nc/4.0/
//
// Printed TPU bellows (v1-v4) all end up cracking along the layer lines. A cast
// silicone bellows has no layers. This mold casts one with the same fit as v3:
// same outer diameter, same 5 folds over 40 mm, the funnel cap socket at the bottom
// and the funnel insert lip at the top.
//
// Untested: first cast still to do. Silicone wall and clearances are first guesses.
//
// Pieces (print in PLA or PETG, not resin: resin can stop platinum silicone curing):
//   core  : base plate + inner core (the bore of the bellows), print upright, 1x
//   shell : outer half-shell, print lying on its flat split face, 2x
// Assembly: shell halves meet on the plate, inside its rim. Short pieces of 1.75 mm
// filament in the pin holes line the halves up. Hold them with rubber bands or tape.
// Pour into the funnel at the top, trim the funnel ring off the cast part afterwards.

part = "all";              // "all" (exploded view), "core", "shell", "section"

// Silicone part
diameter = 58.5;           // Outer diameter, as v1-v4
fold_sections = 5;         // Folds, as v1-v4
accordion_height = 40;     // Height of the folded part, as v1-v4
wave_depth = 8.0;          // Narrow ring diameter = diameter - wave_depth, as v1-v4
crease_radius = 1.5;       // Rounding of the creases (no overhang limit in a mold)
sil_wall = 1.5;            // Silicone wall through the folds (TPU v4: 0.6). Thin gaps fill badly.
socket_height = 8;         // Funnel cap socket at the bottom (v1 cap_insert height)
socket_id = 55.0;          // Socket bore, as v1 (58.5 - 4.375 * 0.8)
connector_height = 1;      // Ring between the folds and the lip, as v1
lip_height = 10.5;         // Funnel insert lip at the top, as v1
lip_od = 55.7;             // As v1 (58.5 - 3.5 * 0.8)
lip_id = 52.5;             // As v1 (58.5 - 7.5 * 0.8)

// Mold
shell_wall = 4;            // Shell thickness at its narrowest (around the socket)
plate_height = 4;          // Base plate under the part
rim_height = 3;            // Rim on the plate that holds the shell halves
rim_wall = 2.5;
rim_gap = 0.25;            // Clearance between shell and rim
funnel_height = 10;        // Pour funnel above the lip
funnel_od = 64;            // Funnel mouth diameter
pin_d = 1.95;              // Holes for 1.75 mm filament dowels
pin_depth = 6;
sgmt = 180;

// Derived
r_out = diameter / 2;
r_in = r_out - wave_depth / 2;
folds = fold_sections * 2;
hpf = accordion_height / folds;
z_acc0 = socket_height;
z_acc1 = z_acc0 + accordion_height;
z_lip0 = z_acc1 + connector_height;
z_top = z_lip0 + lip_height;
shell_r = r_out + shell_wall;
plate_r = shell_r + rim_gap + rim_wall;

// Round convex corners with r_convex and concave corners with r_concave
module rounded(r_convex, r_concave) {
    offset(r = -r_concave) offset(r = r_concave)
        offset(r = r_convex) offset(r = -r_convex)
            children();
}

// Everything inside the outer surface of the part, as a 2D half section (x = radius)
module outer_region() {
    zig = [for (i = [0 : folds]) [(i % 2 == 0) ? r_out : r_in, z_acc0 + i * hpf]];
    rounded(crease_radius, crease_radius) polygon(concat(
        [[-5, -5], [r_out, -5]],
        zig,
        [[r_out, z_lip0], [lip_od / 2, z_lip0], [lip_od / 2, z_top + 5], [-5, z_top + 5]]
    ));
}

// Everything inside the bore of the part
module bore_region() {
    union() {
        intersection() {
            offset(delta = -sil_wall) outer_region();
            translate([-5, z_acc0]) square([r_out + 10, accordion_height]);
        }
        translate([-5, -5]) square([socket_id / 2 + 5, socket_height + 5]);
        translate([-5, z_acc1 - 1]) square([lip_id / 2 + 5, z_top - z_acc1 + 1 + funnel_height + 5]);
    }
}

module part_section() {
    intersection() {
        difference() { outer_region(); bore_region(); }
        square([r_out + 1, z_top]);
    }
}

module silicone_part() {
    rotate_extrude($fn = sgmt) part_section($fn = 0, $fs = 0.2, $fa = 4);
}

module core() {
    // Plate with a rim that holds the shell halves
    translate([0, 0, -plate_height]) cylinder(h = plate_height, r = plate_r, $fn = sgmt);
    difference() {
        cylinder(h = rim_height, r = plate_r, $fn = sgmt);
        translate([0, 0, -0.01]) cylinder(h = rim_height + 0.02, r = shell_r + rim_gap, $fn = sgmt);
    }
    // Core = the bore, up through the funnel
    rotate_extrude($fn = sgmt) intersection() {
        bore_region($fn = 0, $fs = 0.2, $fa = 4);
        square([r_out, z_top + funnel_height]);
    }
}

module shell_solid() {
    difference() {
        union() {
            cylinder(h = z_top, r = shell_r, $fn = sgmt);
            translate([0, 0, z_top]) cylinder(h = funnel_height, r = funnel_od / 2 + 2.5, $fn = sgmt);
        }
        rotate_extrude($fn = sgmt) intersection() { outer_region($fn = 0, $fs = 0.2, $fa = 4); square([r_out + 1, z_top + 1]); }
        // Pour funnel: widens from the lip to the mouth
        translate([0, 0, z_top - 0.01])
            cylinder(h = funnel_height + 0.02, d1 = lip_od, d2 = funnel_od, $fn = sgmt);
    }
}

// Pin heights along the split face, on the solid part of the wall
pin_z = [socket_height / 2, z_acc0 + accordion_height / 2, z_top - 3];
pin_x = (shell_r + r_out) / 2;

module shell_half() {
    difference() {
        intersection() {
            shell_solid();
            translate([-100, 0, -1]) cube([200, 100, z_top + funnel_height + 2]);
        }
        for (s = [-1, 1], z = pin_z)
            translate([s * pin_x, -0.01, z]) rotate([-90, 0, 0]) cylinder(h = pin_depth, d = pin_d, $fn = 24);
    }
}

// Keeps the y > 0 half, for the section view
module cut() { difference() { children(); translate([-100, -200, -10]) cube([200, 200, 200]); } }

if (part == "core") {
    core();
} else if (part == "shell") {
    // Lying on the split face, ready to print
    rotate([90, 0, 0]) shell_half();
} else if (part == "section") {
    // Half cross-section of the assembled mold, as stacked flat layers so the colors
    // show in preview: core gray, shell blue, silicone red on top
    $fn = 0; $fs = 0.2; $fa = 4;
    color("lightgray") linear_extrude(1) intersection() { bore_region(); square([r_out, z_top + funnel_height]); }
    color("steelblue") linear_extrude(1) difference() { square([shell_r, z_top]); outer_region(); }
    color("red") translate([0, 0, 2]) linear_extrude(1) part_section();
} else if (part == "silicone") {
    silicone_part();
} else {
    color("lightgray") core();
    color("steelblue") {
        translate([0, 40, 0]) shell_half();
        translate([0, -40, 0]) mirror([0, 1, 0]) shell_half();
    }
    translate([90, 0, 0]) color("red") silicone_part();
}
