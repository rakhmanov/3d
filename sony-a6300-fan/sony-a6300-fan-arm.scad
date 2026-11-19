// Sony a6300 rear cooling fan: shoe arm (DRAFT)
// Author: Denis Shatilov
// License: CC BY-NC 4.0
// https://creativecommons.org/licenses/by-nc/4.0/
//
// Second printable part. A foot slides into the camera's flash shoe from the back, a bridge runs
// back over the top edge (and the little hump behind the shoe), and a straight tab drops in front of
// the box. The tab screws to the box's front face with 2 x M3 into heat-set inserts, inside the top
// band the tilting screen never reaches. On top: a cold shoe so a mic or light still fits, or a
// 1/4"-20 insert for a metal shoe adapter.
//
// Printed upside down, standing on the top block: the neck + foot and the tab grow up from it.
// No supports; only the foot's flanges overhang the neck by 3.2 mm each side.
//
//            [ top block ]
//   foot ═══╤═══════════╗ bridge
//   (in the shoe)       ║
//   camera back ▕       ║ tab, in front of the box
//               ▕ ┌─────╫──────┐
//               ▕ │ box ◉ M3   │  top band: the screen never gets here
//               ▕ │     ◉ M3   │
//               ▕ └────────────┘

include <sony-a6300-fan.scad>
use <dev/a6300-camera.scad>

show_part = false;
show_arm = true;
arm_mount = true;   // the box gets the screw bosses when used with the arm (the switch must then move)
// "print": the real (mirrored) part, upside down on its top block. "display": as it sits on the camera
arm_orient = "print"; // ["print", "display"]

/* [Arm] */
arm_w = 12;
arm_t = 4;            // tab thickness in front of the box
tab_gap = 0.2;        // tab to box front face
bridge_t = 4;
// ISO 518 foot: 18.4 wide, 1.9 thick; neck through the 12.6 opening
foot = [18.4, 16, 1.9];
neck_w = 12;
// What goes on top: "shoe" = printed cold shoe, "quarter" = block for a 1/4"-20 heat-set insert, "none"
top_mount = "shoe"; // ["shoe", "quarter", "none"]
top_h = top_mount == "quarter" ? 7 : top_mount == "shoe" ? 4.4 : 0;

// ---------- where the box and the shoe sit (camera coordinates -> box coordinates) ----------
ec = a6300_eyecup();
sh = a6300_shoe();
fl = a6300_flash();
box_x = 4;                         // box left edge, 1 mm inside the recess
box_z = ec[2] - 0.3 - box_h;       // box top just under the eyepiece
s_x = sh[0] - box_x;
s_y0 = sh[1];
s_z = sh[3] - box_z;               // camera top surface
foot_z0 = s_z + 0.35;
foot_z1 = foot_z0 + foot[2];
bridge_z0 = s_z + 2.8 + 0.8;       // clears the shoe's lips and the hump behind the shoe
bridge_z1 = bridge_z0 + bridge_t;
t_x0 = arm_xc - arm_w / 2;
t_y0 = box_d + tab_gap;
t_y1 = t_y0 + arm_t;
t_z0 = box_h - tab_band;
bx0 = min(s_x - neck_w / 2, t_x0);
bx1 = max(s_x + neck_w / 2, t_x0 + arm_w);
tx0 = min(bx0, s_x - 12);
tx1 = max(bx1, s_x + 12);
flash_left = fl[0] - fl[2] / 2 - box_x;
echo(str("Arm: shoe centre at box x ", s_x, ", tab centre ", arm_xc, ", drop ", bridge_z1 - t_z0,
         " mm, ", flash_left - (t_x0 + arm_w), " mm clear of the flash button"));
assert(abs(s_x - arm_xc) < 4, "tab is far from the shoe: set arm_xc in sony-a6300-fan.scad");
assert(t_x0 + arm_w < flash_left - 1, "tab reaches the flash button");

module arm() {
    difference() {
        union() {
            translate([s_x - foot[0] / 2, s_y0 + 1, foot_z0]) cube([foot[0], foot[1], foot[2]]);
            translate([s_x - neck_w / 2, s_y0 + 1, foot_z1 - 0.01]) cube([neck_w, foot[1], bridge_z0 - foot_z1 + 0.02]);
            translate([bx0, s_y0 + 1, bridge_z0]) cube([bx1 - bx0, t_y1 - s_y0 - 1, bridge_t]);
            // top block covers the whole bridge footprint, so it is a flat base when printing upside down
            if (top_h > 0) translate([tx0, s_y0 + 1, bridge_z1 - 0.01]) cube([tx1 - tx0, t_y1 - s_y0 - 1, top_h]);
            translate([t_x0, t_y0, t_z0]) cube([arm_w, arm_t, bridge_z1 - t_z0]);
        }
        // M3 screws into the box's inserts, heads sunk into the tab
        for (z = screw_z) translate([arm_xc, t_y0 - 1, box_h - z]) rotate([-90, 0, 0]) {
            cylinder(d = 3.4, h = arm_t + 2, $fn = 24);
            translate([0, 0, 1 + arm_t - 1.8]) cylinder(d = 6.2, h = 3, $fn = 32);
        }
        if (top_mount == "shoe") translate([s_x, 0, bridge_z1]) {
            translate([-9.4, s_y0 + 3, 1.0]) cube([18.8, 60, 2.2]);   // slot, open toward the back
            translate([-6.4, s_y0 + 3, 1.0]) cube([12.8, 60, 10]);    // opening between the lips
        }
        if (top_mount == "quarter") translate([s_x, s_y0 + 11, bridge_z1 + 0.5]) cylinder(d = 7.9, h = 10, $fn = 32);
    }
}

arm_top = bridge_z1 + top_h;
if (show_arm) color("#e6e6e6")
    if (arm_orient == "print") translate([0, 0, arm_top]) rotate([0, 180, 0]) mirror([0, 1, 0]) arm();
    else mirror([0, 1, 0]) arm();
