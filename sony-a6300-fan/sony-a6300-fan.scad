// Sony a6300 rear cooling fan box: DRAFT
// Author: Denis Shatilov
// License: CC BY-NC 4.0
// https://creativecommons.org/licenses/by-nc/4.0/
//
// The printable part only. sony-a6300-fan-scene.scad shows it on the camera with the parts fitted.
// Not measured on the camera yet. The part sizes are real (see README), the clear space is a guess.
//
// Seen from behind the camera. X runs left to right, Z is up, the camera back plate is at Y = 0.
// Modules are drawn with the operator at +Y, and the display is mirrored so the operator stands at -Y.
//
//      ┌──────┬───────────┐
//   ▯──┤ bay  │  ( fan )  │   left wall: 3-position slide switch H / O / L (upper), Adafruit 4090 USB-C (lower)
//   ▭──┤      │   grille  │   fan blows onto the back plate, air leaves through the ribbed band
//       \_____┴───────────┘   along the back edge of all four walls. Bottom-front edge slanted.

/* [Fan] */
// 30 = 3007 5V fan, e.g. WINSINN 3007 hydraulic (30x30x7, holes on 24); a Sunon MF30060 (6.5 thick) also fits.
// 40 = Noctua NF-A4x10 5V (40x40x10, holes on 32)
fan = 30; // [30, 40]
fan_t = fan == 40 ? 10 : 7;
fan_holes = fan == 40 ? 32 : 24;
fan_screw_d = fan == 40 ? 3.4 : 3.2;   // clearance for the fan screws (M3 self-tapping into the 3007 frame)

/* [Box] */
// Overall height at the back, from the cardboard test on the camera (2026-11-18): 35 (36 just squeezes in)
box_h_set = 35;
wall = 1.6;
wall_top = 1.2;       // thinner top wall lets the fan sit higher, which leaves room for a steeper bevel
// Fan to back plate gap, also the height of the exhaust band in every wall
air_gap = 4.4;   // box 13.0 deep: the screen allows ~14 (cardboard test), 1 mm kept as margin
// Electronics bay inner width (USB-C board is 13.97 deep from the wall)
bay_w = 15.5;
// Exhaust ribs
rib = 1.2;
rib_pitch = 7;
// Minimum box width. 74 = the LCD's width, so the box covers the whole pocket the screen leaves.
// The fan sits centred in the space right of the bay; the rest is a closed plenum that makes the
// air sweep the plate sideways to the exhaust ribs. 0 = just wide enough for the fan
box_w_min = 80;
// The bottom is bevelled across the full depth to clear the screen's hinge arm: 0 at the plate,
// slant_rise up at the outside face (cardboard test: 35 against the plate, 32.5-33 outside).
// More rise = more clearance. The inside floor follows the bevel
slant_rise = 3.0;   // ~3.3 is the most before the bevel reaches the fan's bottom front corner
floor_t = 1.2;

/* [USB-C: Adafruit 4090 "USB Type C Breakout Board - Downstream Connection"] */
// From the Eagle board file: 20.32 x 13.97 PCB, connector centred on a long edge,
// two 2.5 mm plated holes 15.24 apart and 2.54 in from the connector edge, 5.1k on CC1 and CC2
usb_pcb = [20.32, 13.97, 1.6];
usb_hole_d = 2.5;
usb_hole_dx = 15.24;
usb_hole_in = 2.54;
// Receptacle shell W x depth x H (typical mid-size USB-C receptacle; Adafruit lists 5.0 total height)
usb_rec = [8.94, 7.35, 3.26];
// Outside counterbore so the plug's overmold seats and the shell reaches full depth
usb_cbore = [13.0, 7.2];
usb_thin = 0.6;   // plug overmold stops this far from the receptacle mouth: keep it under ~0.7

/* [Switch: SS13D07 mini slide switch, 1P3T: High / Off / Low] */
// Body 12.7 x 4.5 x 4.7 (XKB SS13D07L4B / ROCPU SS-13D07 listings), "L4" = 4 mm knob, 2 mm per step.
// Knob cross-section estimated. In the front face just left of the fan, in the top band the tilted
// screen never covers, sliding sideways (L left, Off middle, H right). Body in a printed cradle
// on the inside of the front plate, knob ~2.4 mm proud
sw_body = [12.7, 4.5, 4.7];   // along the slide, across, height into the box
sw_knob = [1.5, 2.0, 4.0];    // along, across, height above the body
sw_step = 2.0;
sw_pins = 3.3;
sw_rim = 1.2;                 // cradle walls
sw_from_top = 7;              // switch centre below the box top (inside the ~14.5 mm uncovered band)
sw_slot = [sw_knob[0] + 2 * sw_step + 0.5, sw_knob[1] + 0.5];   // along, across

/* [Arm mount: the shoe arm (sony-a6300-fan-arm.scad) screws to the front face] */
// Off by default: for now the tilted-up screen holds the box (see HANDOFF.md). The arm file turns it on,
// and then the switch has to move out of the way of the screw bosses
arm_mount = false;
// The arm's tab sits on the front face in the top band the screen never reaches (14.5-15 mm under
// the eyepiece), left of the fan, held by 2 x M3 screws into heat-set inserts in bosses behind the front plate
arm_xc = 37;          // tab centre in box X: right above the shoe (camera x 41, box placed at x 4)
tab_band = 14.5;      // top band height on the front face
screw_z = [4, 11];    // screw heights below the box top
insert_d = 4.0;       // M3 x 4 heat-set insert hole
insert_l = 5.0;
boss_d = 7.5;

show_part = true;
// "print": the real (mirrored) part, front face down on the bed. "display": as it sits on the camera
orient = "print"; // ["print", "display"]
$fn = 64;

// ---------- derived ----------
front = wall;
box_d = front + fan_t + air_gap;
box_h = box_h_set;
inner_h = box_h - wall - wall_top;
sec_x = wall + bay_w + wall;                        // fan section starts right of the divider
box_w = max(sec_x + fan + 0.6 + wall, box_w_min);
fan_x = box_w - wall - 0.3 - fan;                   // fan at the right end: the plenum left of it is where the arm comes down
fan_zc = box_h - wall_top - 0.3 - fan / 2;          // fan at the top: room for the bottom bevel
assert(inner_h >= fan + 0.6, "box too short for the fan");
function slant(y) = slant_rise * (y + 0.5) / (box_d + 0.5);   // starts 0.5 behind the plate: no knife edge at the back corner
usb_z0 = slant(box_d - front) + floor_t + 0.3;    // board bottom, above the bevelled floor
usb_zc = usb_z0 + usb_pcb[0] / 2;
usb_yc = (air_gap + 0.3 + usb_rec[2] / 2 + usb_pcb[2] + box_d - front - 0.5 - usb_rec[2] / 2) / 2;
usb_pcb_y = usb_yc - usb_rec[2] / 2;               // component face of the PCB
usb_top = usb_z0 + usb_pcb[0];
sw_xc = fan_x - 1 - sw_body[0] / 2 - sw_rim;      // just left of the fan
sw_zc = box_h - sw_from_top;
assert(sw_xc - sw_body[0] / 2 - sw_rim > sec_x, "switch cradle hits the bay divider");
if (arm_mount && abs(sw_xc - arm_xc) < sw_body[0] / 2 + sw_rim + boss_d / 2 && sw_zc - sw_body[1] / 2 - sw_rim < box_h - screw_z[0] + boss_d / 2)
    echo("WARNING: switch and the arm's screw bosses overlap: move one of them before printing with the arm");
assert(sw_zc + sw_body[1] / 2 + sw_rim < box_h - wall_top, "switch cradle hits the top wall");
assert(sw_from_top + sw_slot[1] / 2 < tab_band, "switch is below the band the screen leaves uncovered");
n_x = floor((box_w - 6 + rib) / rib_pitch);
n_z = floor((box_h - 6 + rib) / rib_pitch);
slot_s = (box_w - 6 - (n_x * rib_pitch - rib)) / 2;
exit_area = 2 * (n_x + n_z) * (rib_pitch - rib) * air_gap;
fan_free = PI * (pow(fan / 2 - 1, 2) - pow(fan * 0.2, 2));
assert(arm_xc - boss_d / 2 > sec_x && arm_xc + boss_d / 2 < fan_x, "arm screw bosses must sit in the plenum between the bay and the fan");

echo(str("Box W x H x D = ", box_w, " x ", box_h, " x ", box_d, " mm, fan ", fan, "x", fan, "x", fan_t));
echo(str("Exhaust ", round(exit_area), " mm2 vs fan free area ", round(fan_free), " mm2"));

// ---------- part ----------
module front_face_2d() {
    difference() {
        square([box_w, box_h]);
        translate([fan_x + fan / 2, fan_zc]) {
            difference() {
                circle(d = fan - 2);
                circle(d = fan * 0.25);                                  // hub disc over the motor
                for (r = [fan * 0.2 : 5 : fan / 2 - 3]) difference() { circle(r = r + 1); circle(r = r); }
                for (a = [90, 210, 330]) rotate(a) translate([0, -0.9]) square([fan, 1.8]);
            }
            for (i = [-1, 1], j = [-1, 1]) translate([i, j] * fan_holes / 2) circle(d = fan_screw_d);
        }
    }
}

module slots_x(z0) {
    s = (box_w - 6 - (n_x * rib_pitch - rib)) / 2;
    for (i = [0 : n_x - 1]) let(x = 3 + s + i * rib_pitch)
        translate([x, -1, z0 - 1]) cube([rib_pitch - rib, air_gap + 1, wall + 2]);
}
module slots_z(x0) {
    s = (box_h - 6 - (n_z * rib_pitch - rib)) / 2;
    for (i = [0 : n_z - 1]) translate([x0 - 1, -1, 3 + s + i * rib_pitch]) cube([wall + 2, air_gap + 1, rib_pitch - rib]);
}

module rrect_x(w_y, h_z, len, r = 1) {  // rounded rectangle prism along X, centred in Y/Z
    hull() for (i = [-1, 1], j = [-1, 1]) translate([0, i * (w_y / 2 - r), j * (h_z / 2 - r)])
        rotate([0, 90, 0]) cylinder(r = r, h = len);
}

module box() {
    difference() {
        union() {
            // one solid shell: block minus the open-backed cavity minus the front openings (no seams)
            difference() {
                cube([box_w, box_d, box_h]);
                translate([wall, -1, wall]) cube([box_w - 2 * wall, box_d - front + 1, box_h - wall - wall_top]);
                translate([0, box_d + 1, 0]) rotate([90, 0, 0]) linear_extrude(front + 1.01)
                    difference() { square([box_w, box_h]); front_face_2d(); }
            }
            translate([wall + bay_w, 0, 0]) cube([wall, box_d - front, box_h]);   // bay / fan divider
            // inside floor following the bevel (thinner where the fan's bottom edge sits)
            difference() {
                rotate([90, 0, 90]) translate([0, 0, wall - 0.01]) linear_extrude(box_w - 2 * wall + 0.02)
                    polygon([[0, -1], [box_d - front + 0.01, slant(box_d - front) - 1],
                             [box_d - front + 0.01, slant(box_d - front) + floor_t], [0, floor_t]]);
                translate([fan_x - 0.2, air_gap - 0.2, fan_zc - fan / 2 - 0.2]) cube([fan + 0.4, fan_t + 0.4, fan + 0.4]);
            }
            // screw bosses for the arm's tab, behind the front plate
            if (arm_mount) for (z = screw_z) translate([arm_xc, box_d - front + 0.01, box_h - z]) rotate([90, 0, 0])
                cylinder(d = boss_d, h = insert_l + 1.5 - front, $fn = 32);
            // slide switch cradle on the inside of the bay's front plate
            translate([sw_xc - sw_body[0] / 2 - sw_rim, box_d - front - 3, sw_zc - sw_body[1] / 2 - sw_rim])
                cube([sw_body[0] + 2 * sw_rim, 3 + 0.01, sw_body[1] + 2 * sw_rim]);
            // USB-C board posts from the front wall, pins through the board's 2.5 mm holes
            for (s = [-1, 1]) translate([wall + usb_hole_in, box_d - front + 0.01, usb_zc + s * usb_hole_dx / 2])
                rotate([90, 0, 0]) {
                    cylinder(d = 5, h = box_d - front - usb_pcb_y);
                    cylinder(d = 2.2, h = box_d - front - usb_pcb_y + usb_pcb[2] + 0.6);
                }
        }
        // exhaust band along the back edge of all four walls, plus the divider (bay air out the left)
        for (z0 = [0, box_h - wall_top]) slots_x(z0);
        for (x0 = [0, box_w - wall]) slots_z(x0);
        translate([wall + bay_w - 1, -1, wall]) cube([wall + 2, air_gap + 1, box_h - wall - wall_top]);
        // fan wires into the bay
        translate([wall + bay_w - 1, box_d - front - fan_t, fan_zc - 4]) cube([wall + 2, fan_t, 8]);
        // USB-C: shell opening, and the outside counterbore down to a thin wall
        translate([-1, usb_yc, usb_zc]) rrect_x(usb_rec[2] + 0.4, usb_rec[0] + 0.4, wall + 2, 1.2);
        translate([-1, usb_yc, usb_zc]) rrect_x(usb_cbore[1], usb_cbore[0], 1 + wall - usb_thin, 2.5);
        // slide switch: knob slot through the front plate, body pocket in the cradle
        translate([sw_xc - sw_slot[0] / 2, box_d - front - 1, sw_zc - sw_slot[1] / 2]) cube([sw_slot[0], front + 2, sw_slot[1]]);
        translate([sw_xc - sw_body[0] / 2 - 0.1, box_d - front - 3.5, sw_zc - sw_body[1] / 2 - 0.1]) cube([sw_body[0] + 0.2, 3.5 + 0.01, sw_body[1] + 0.2]);
        // L left of the slot, H right (engraved 0.4 mm into the front face)
        for (m = [["L", -1], ["H", 1]]) translate([sw_xc + m[1] * (sw_slot[0] / 2 + 2.2), box_d + 0.01, sw_zc])
            rotate([90, 0, 0]) linear_extrude(0.41) text(m[0], size = 2.6, halign = "center", valign = "center", font = "Liberation Sans:style=Bold");
        // heat-set insert holes from the front face
        if (arm_mount) for (z = screw_z) translate([arm_xc, box_d + 0.01, box_h - z]) rotate([90, 0, 0]) cylinder(d = insert_d, h = insert_l, $fn = 24);
        // bottom bevel across the full depth: 0 at the plate, slant_rise at the outside face
        rotate([90, 0, 90]) translate([0, 0, -1]) linear_extrude(box_w + 2)
            polygon([[-1, -1], [box_d + 1, -1], [box_d + 1, slant(box_d + 1)], [-1, slant(-1)]]);
    }
}

// The modules are drawn with the operator at +Y; the real part is their mirror image.
if (show_part) color("WhiteSmoke")
    if (orient == "print") translate([0, 0, box_d]) rotate([90, 0, 0]) mirror([0, 1, 0]) box();
    else mirror([0, 1, 0]) box();
