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
wall = 1.6;
// Fan to back plate gap, also the height of the exhaust band in every wall
air_gap = 4.0;
// Electronics bay inner width (USB-C board is 13.97 deep from the wall)
bay_w = 15.5;
// Exhaust ribs
rib = 1.2;
rib_pitch = 7;
// Minimum box width. 74 = the LCD's width, so the box covers the whole pocket the screen leaves.
// The fan sits centred in the space right of the bay; the rest is a closed plenum that makes the
// air sweep the plate sideways to the exhaust ribs. 0 = just wide enough for the fan
box_w_min = 74;
// Slant on the bottom-front edge for the tilted screen
screen_chamfer = 2.5;

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
// Knob cross-section estimated. Body sits in a printed cradle against the inside of the left wall,
// knob pokes ~2.4 mm out through a slot: thumbnail-operated
sw_body = [12.7, 4.5, 4.7];   // along the slide (vertical), across, height into the bay
sw_knob = [1.5, 2.0, 4.0];    // along, across, height above the body
sw_step = 2.0;
sw_pins = 3.3;
sw_rim = 1.2;                 // cradle side walls; the box's top wall caps it, a thin ledge holds it below
sw_ledge = 0.8;
sw_slot = [sw_knob[0] + 2 * sw_step + 0.5, sw_knob[1] + 0.5];   // along, across

show_part = true;
$fn = 64;

// ---------- derived ----------
front = wall;
box_d = front + fan_t + air_gap;
bay_need = 0.5 + usb_pcb[0] + 0.3 + sw_ledge + sw_body[0] + 0.2;  // USB-C board below the switch cradle
inner_h = max(fan + 0.6, bay_need);
box_h = inner_h + 2 * wall;
sec_x = wall + bay_w + wall;                        // fan section starts right of the divider
box_w = max(sec_x + fan + 0.6 + wall, box_w_min);
fan_x = sec_x + (box_w - wall - sec_x - fan) / 2;   // fan's left edge, centred in its section
fan_zc = box_h / 2;
side_yc = (air_gap + box_d - front) / 2;          // middle of the solid part of the left wall
usb_zc = wall + 0.5 + usb_pcb[0] / 2;
usb_yc = (air_gap + 0.3 + usb_rec[2] / 2 + usb_pcb[2] + box_d - front - 0.5 - usb_rec[2] / 2) / 2;
usb_pcb_y = usb_yc - usb_rec[2] / 2;               // component face of the PCB
sw_zc = box_h - wall - 0.2 - sw_body[0] / 2;
n_x = floor((box_w - 6 + rib) / rib_pitch);
n_z = floor((box_h - 6 + rib) / rib_pitch);
exit_area = 2 * (n_x + n_z) * (rib_pitch - rib) * air_gap;
fan_free = PI * (pow(fan / 2 - 1, 2) - pow(fan * 0.2, 2));
chamfer_max = fan_zc - (fan / 2 - 1);

echo(str("Box W x H x D = ", box_w, " x ", box_h, " x ", box_d, " mm, fan ", fan, "x", fan, "x", fan_t));
echo(str("Exhaust ", round(exit_area), " mm2 vs fan free area ", round(fan_free), " mm2"));
if (screen_chamfer > chamfer_max) echo(str("WARNING: screen_chamfer > ", chamfer_max, " notches the grille"));

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
    for (i = [0 : n_x - 1]) translate([3 + s + i * rib_pitch, -1, z0 - 1]) cube([rib_pitch - rib, air_gap + 1, wall + 2]);
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
            translate([0, box_d, 0]) rotate([90, 0, 0]) linear_extrude(front) front_face_2d();
            difference() {
                cube([box_w, box_d - front, box_h]);
                translate([wall, -1, wall]) cube([box_w - 2 * wall, box_d, box_h - 2 * wall]);
            }
            translate([wall + bay_w, 0, 0]) cube([wall, box_d - front, box_h]);   // bay / fan divider
            // slide switch cradle on the inside of the left wall
            translate([wall - 0.01, side_yc - sw_body[1] / 2 - sw_rim, sw_zc - sw_body[0] / 2 - sw_ledge])
                cube([sw_body[2] - 1, sw_body[1] + 2 * sw_rim, box_h - wall - (sw_zc - sw_body[0] / 2 - sw_ledge) + 0.01]);
            // USB-C board posts from the front wall, pins through the board's 2.5 mm holes
            for (s = [-1, 1]) translate([wall + usb_hole_in, box_d - front + 0.01, usb_zc + s * usb_hole_dx / 2])
                rotate([90, 0, 0]) {
                    cylinder(d = 5, h = box_d - front - usb_pcb_y);
                    cylinder(d = 2.2, h = box_d - front - usb_pcb_y + usb_pcb[2] + 0.6);
                }
        }
        // exhaust band along the back edge of all four walls, plus the divider (bay air out the left)
        for (z0 = [0, box_h - wall]) slots_x(z0);
        for (x0 = [0, box_w - wall]) slots_z(x0);
        translate([wall + bay_w - 1, -1, wall]) cube([wall + 2, air_gap + 1, box_h - 2 * wall]);
        // fan wires into the bay
        translate([wall + bay_w - 1, box_d - front - fan_t, fan_zc - 4]) cube([wall + 2, fan_t, 8]);
        // USB-C: shell opening, and the outside counterbore down to a thin wall
        translate([-1, usb_yc, usb_zc]) rrect_x(usb_rec[2] + 0.4, usb_rec[0] + 0.4, wall + 2, 1.2);
        translate([-1, usb_yc, usb_zc]) rrect_x(usb_cbore[1], usb_cbore[0], 1 + wall - usb_thin, 2.5);
        // slide switch: knob slot, and the body pocket inside the cradle
        translate([-1, side_yc - sw_slot[1] / 2, sw_zc - sw_slot[0] / 2]) cube([wall + 2, sw_slot[1], sw_slot[0]]);
        translate([wall - 0.01, side_yc - sw_body[1] / 2 - 0.1, sw_zc - sw_body[0] / 2 - 0.1]) cube([sw_body[2] + 1, sw_body[1] + 0.2, sw_body[0] + 0.3]);
        // H above the slot, L below (engraved 0.4 mm)
        for (m = [["H", 1], ["L", -1]]) translate([0.4, side_yc, sw_zc + m[1] * (sw_slot[0] / 2 + 1.9)])
            rotate([90, 0, -90]) mirror([1, 0, 0]) linear_extrude(1) text(m[0], size = 2.4, halign = "center", valign = "center", font = "Liberation Sans:style=Bold");
        // slant on the bottom-front edge
        rotate([90, 0, 90]) translate([0, 0, -1]) linear_extrude(box_w + 2)
            polygon([[box_d - screen_chamfer - 1, -1], [box_d + 1, -1], [box_d + 1, screen_chamfer + 1]]);
    }
}

if (show_part) mirror([0, 1, 0]) color("WhiteSmoke") box();
