$fn = 128;  // smoothness


d_large = 6;           // 6" inner
d_small = 5;           // 5" inner
wall = 3;              // wall thickness
height = 60;           // taper section height
lip_length = 20;       // 1 inch lips on both sides
inner_offset = 0.5;    // clearance for hose slip-on

// Computed
dd_large = d_large*25.4;
dd_small = d_small*25.4;

// === MAIN REDUCER BODY ===
module duct_reducer_with_lips() {
    difference() {
        union() {
            // Main tapered reducer
            hull() {
                translate([0, 0, lip_length])
                    cylinder(d=dd_large + 2*wall, h=1);
                translate([0, 0, lip_length + height])
                    cylinder(d=dd_small + 2*wall, h=1);
            }

            // Large-end lip
            translate([0, 0, 0])
                cylinder(d=dd_large + 2*wall, h=lip_length);

            // Small-end lip
            translate([0, 0, lip_length + height])
                cylinder(d=dd_small + 2*wall, h=lip_length);
        }

        // Hollow air path (offset for hose slip-on)
        union() {
            // Main taper
            hull() {
                translate([0, 0, lip_length])
                    cylinder(d=dd_large + inner_offset, h=1);
                translate([0, 0, lip_length + height])
                    cylinder(d=dd_small + inner_offset, h=1);
            }

            // Large-end hollow (lip section)
            translate([0, 0, 0-0.01])
                cylinder(d=dd_large + inner_offset, h=lip_length + 0.02);

            // Small-end hollow (lip section)
            translate([0, 0, lip_length + height])
                cylinder(d=dd_small + inner_offset, h=lip_length + 0.02);
        }
    }
}

// === RENDER ===
duct_reducer_with_lips();
