// Sony a6300 rear cooling fan: tool-free shoe arm (DRAFT)
// Author: Denis Shatilov
// License: CC BY-NC 4.0
// https://creativecommons.org/licenses/by-nc/4.0/
//
// Second printable part. After placing the box in the screen recess, slide this arm forward (-Y)
// into the camera's flash shoe: a drop-tab enters the uncovered top band in front of the box, and
// its locating lug (flat load-bearing top shelf + 0.6 mm tip chamfers + 45-deg bottom ramp) engages
// the box's front pocket during the last ~4 mm of shoe travel (zero screws or inserts). Underside
// ribs on the foot add gentle shoe-spring retention; on top sits a passive cold shoe (or 1/4"-20
// insert block).
//
// Printed lying flat on its back (+Y face of the tab/bridge/top block on the bed, -Y pointing up):
// continuous XY perimeters wrap the bridge-to-tab corner for bending strength, the lug grows straight
// up off the tab, the 45-deg rear foot taper keeps it support-free inside the shoe, and both the
// 18.8 mm cold-shoe ceiling bridge and the 3.2 mm foot flange overhangs are eliminated.
//
//            [ top block ]
//   foot ═══╤═══════════╗ bridge
//   (in the shoe)       ║
//   camera back ▕       ║ tab, in front of the box
//               ▕ ┌─────╫──────┐
//               ▕ │ box ◀═ lug │  top band: the screen never gets here (flat top shelf takes gravity)
//               ▕ └────────────┘

include <sony-a6300-fan.scad>
use <dev/a6300-camera.scad>

show_part = false;
show_arm = true;
// "print": the real (mirrored) part, lying flat on its back (+Y face on the bed). "display": as it sits on the camera
arm_orient = "print"; // ["print", "display"]

/* [Arm] */
arm_t = 4;            // tab thickness in front of the box
tab_gap = 0.2;        // tab to box front face
bridge_t = 4;
// ISO 518 foot: 18.4 wide, 1.9 thick; neck through the 12.6 opening
foot = [18.4, 16, 1.9];
neck_w = 12;
foot_chamfer = 0.8;   // 45-deg front corner lead-in on the foot
foot_rib_h = 0.2;     // underside friction rib height (engages shoe floor spring)
pin_chamfer = 0.6;    // 45-deg lead-in chamfer on top and sides of the lug tip
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
t_z0 = pin_z0 - 2.0;
pin_tip_h = pin_h - pin_len - pin_chamfer;
assert(pin_tip_h >= 1.0, "lug tip too thin after 45-deg bottom ramp and top chamfer");
y_f0 = s_y0 + 1;
y_n1 = sh[2] - 0.5;                // clears the hump behind the shoe by 0.5 mm
y_d = y_n1 - (bridge_z0 - foot_z0); // where the 45-deg neck ramp reaches foot_z0
flange_w = (foot[0] - neck_w) / 2;
y_fw = y_d - flange_w;             // where the 45-deg side flanges reach full foot width
assert(y_fw > y_f0 + foot_chamfer + 5, "foot too short after 45-deg support-free ramps");
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
    fx0 = s_x - foot[0] / 2;
    fx1 = s_x + foot[0] / 2;
    difference() {
        union() {
            // ISO 518 foot + tapered neck + bridge as one seamless blank trimmed cleanly to shape
            difference() {
                rotate([90, 0, 90]) translate([0, 0, fx0]) linear_extrude(foot[0], convexity = 4)
                    polygon([[y_f0, foot_z0], [y_d, foot_z0], [y_n1, bridge_z0],
                             [t_y1, bridge_z0], [t_y1, bridge_z1], [y_f0, bridge_z1]]);
                for (sx = [-1, 1]) let(fx = s_x + sx * foot[0] / 2, bx = sx < 0 ? bx0 : bx1) {
                    // 45-deg front corner chamfers on the foot (oversized outside foot edges)
                    translate([0, 0, foot_z0 - 1]) linear_extrude(foot[2] + 2)
                        polygon([[fx + sx, y_f0 - 1], [fx - sx * (foot_chamfer + 1), y_f0 - 1],
                                 [fx + sx, y_f0 + foot_chamfer + 1]]);
                    // 45-deg rear flange flares and rear wing trims beyond y_d
                    translate([0, 0, foot_z0 - 1]) linear_extrude(bridge_z1 - foot_z0 + 2)
                        polygon([[fx + sx, y_fw - 1], [bx, y_d], [bx, t_y1 + 1], [fx + sx, t_y1 + 1]]);
                    // side steps above foot_z1 (keeps 12 mm neck width cleanly inside the shoe slot opening)
                    translate([sx < 0 ? fx - 1 : bx, y_f0 - 1, foot_z1])
                        cube([abs(bx - fx) + 1, t_y1 - y_f0 + 2, bridge_z1 - foot_z1 + 1]);
                }
            }
            // top block (same X-extrusion axis as the blank so front/back faces match bit-for-bit)
            if (top_h > 0) rotate([90, 0, 90]) translate([0, 0, tx0]) linear_extrude(tx1 - tx0)
                polygon([[y_f0, bridge_z1 - 0.5], [t_y1, bridge_z1 - 0.5],
                         [t_y1, arm_top], [y_f0, arm_top]]);
            // two tapered friction ribs under the full-width portion of the foot (> 55 deg ramp, support-free)
            for (sx = [-1, 1]) rotate([90, 0, 90]) translate([0, 0, s_x + sx * 4.0 - 1.0]) linear_extrude(2.0)
                polygon([[y_f0 + 2.5, foot_z0 + 0.01], [y_f0 + 2.5 + foot_rib_h + 0.15, foot_z0 - foot_rib_h],
                         [y_f0 + 8.5 - foot_rib_h - 0.15, foot_z0 - foot_rib_h], [y_f0 + 8.5, foot_z0 + 0.01]]);
            translate([t_x0, t_y0, t_z0]) cube([arm_w, arm_t, bridge_z0 - t_z0 + 0.5]);
            // reversed locating lug: flat horizontal top bearing shelf + 0.6 mm tip chamfers + 45-deg bottom ramp
            intersection() {
                rotate([90, 0, 90]) translate([0, 0, arm_xc - pin_w / 2]) linear_extrude(pin_w)
                    polygon([[t_y0 + 0.01, pin_z0], [t_y0 + 0.01, pin_z0 + pin_h],
                             [t_y0 - pin_len + pin_chamfer, pin_z0 + pin_h],
                             [t_y0 - pin_len, pin_z0 + pin_h - pin_chamfer],
                             [t_y0 - pin_len, pin_z0 + pin_len], [t_y0, pin_z0]]);
                translate([0, 0, pin_z0 - 1]) linear_extrude(pin_h + 2)
                    polygon([[arm_xc - pin_w / 2, t_y0 + 0.01], [arm_xc + pin_w / 2, t_y0 + 0.01],
                             [arm_xc + pin_w / 2, t_y0 - pin_len + pin_chamfer],
                             [arm_xc + pin_w / 2 - pin_chamfer, t_y0 - pin_len],
                             [arm_xc - pin_w / 2 + pin_chamfer, t_y0 - pin_len],
                             [arm_xc - pin_w / 2, t_y0 - pin_len + pin_chamfer]]);
            }
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
    if (arm_orient == "print") translate([0, arm_top, t_y1]) rotate([90, 0, 0]) mirror([0, 1, 0]) arm();
    else mirror([0, 1, 0]) arm();
