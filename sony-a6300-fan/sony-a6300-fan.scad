// Sony a6300 rear cooling fan box: DRAFT
// Author: Denis Shatilov
// License: CC BY-NC 4.0
// https://creativecommons.org/licenses/by-nc/4.0/
//
// The printable part only. dev/sony-a6300-fan-scene.scad shows it on the camera with the parts fitted.
// Sized from cardboard test and caliper measurements (2026-11-18); not printed yet.
//
// Seen from behind the camera. X runs left to right, Z is up, the camera back plate is at Y = 0.
// Modules are drawn with the operator at +Y, and the display is mirrored so the operator stands at -Y.
//
//      ┌──────┬──────────┬──────────┬───┐
//      │      │ L◦H  [ ] │          │   │  switch left of arm socket in top band; 6 mm right exhaust duct
//   ▭──┤ bay  │ chamber  │  ( fan ) │   │  USB-C out of left wall; fan blows onto the plate
//      └──────┴──────────┴──────────┴───┘  bottom bevelled from 0 at the plate to 3 mm at the front
//   solid back rim on left/top/right inside the 5.2 mm recess; exhaust windows outside the recess
//   (right wall, top wall, left wall above USB-C) plus ribbed bottom-back outlet behind the hinge arm.

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
// Right exhaust duct inside the box (feeds the right-wall outlets)
right_duct = 6.0;
// Side and top exhaust slots start this far from the back plate (past the 5.2 mm recess walls)
recess_clear = 5.6;
// Exhaust ribs
rib = 1.4;
rib_pitch = 7;
// Minimum box width. 80 mm fits the recess pocket under the eyepiece.
// The fan sits left of right_duct; the rest is a plenum that sweeps the plate to the unblocked exits.
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
// Knob cross-section estimated. In the front face left of the arm tab & socket, in the top band the tilted
// screen never covers, sliding sideways (L left, Off middle, H right). Body in a printed cradle
// on the inside of the front plate, knob ~2.4 mm proud
sw_body = [12.7, 4.5, 4.7];   // along the slide, across, height into the box
sw_knob = [1.5, 2.0, 4.0];    // along, across, height above the body
sw_step = 2.0;
sw_pins = 3.3;
sw_rim = 1.2;                 // cradle walls
sw_from_top = 7;              // switch centre below the box top (inside the ~14.5 mm uncovered band)
sw_slot = [sw_knob[0] + 2 * sw_step + 0.5, sw_knob[1] + 0.5];   // along, across

/* [Arm mount: tool-free pin-and-socket slide-on shoe arm (sony-a6300-fan-arm.scad)] */
// Open-backed pocket in the front plate accepts the shoe arm's tapered locating lug on -Y slide-in;
// the same box also works standalone (e.g. micro-suction + screen clamp) without attaching the arm.
arm_mount = true;
arm_xc = 37;          // tab & socket centre in box X: right above the shoe (camera x 41, box placed at x 4)
arm_w = 10;           // arm drop-tab width in X (shared with sony-a6300-fan-arm.scad)
tab_band = 14.5;      // uncovered top band height on the front face
pin_w = 6.0;          // arm lug width in X
pin_h = 6.0;          // arm lug root height in Z at the tab face
pin_len = 4.2;        // arm lug protrusion along -Y (penetrates ~4.0 mm into the socket)
pin_z0 = 25.0;        // flat bottom shelf height of the lug in box Z (4.5 mm above the 65-deg screen)
sock_clear = 0.25;    // clearance per side around the lug inside the socket
sock_wall = 1.4;      // collar wall thickness behind the front plate
sock_d = 4.6;         // total socket depth from the front face

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
box_w = max(sec_x + fan + 0.6 + right_duct + wall, box_w_min);
fan_x = box_w - wall - right_duct - 0.3 - fan;      // leaves right_duct mm clear on the right for exhaust
fan_zc = box_h - wall_top - 0.3 - fan / 2;          // fan at the top: room for the bottom bevel
assert(inner_h >= fan + 0.6, "box too short for the fan");
function slant(y) = slant_rise * (y + 0.5) / (box_d + 0.5);   // starts 0.5 behind the plate: no knife edge at the back corner
usb_z0 = slant(box_d - front) + floor_t + 0.3;    // board bottom, above the bevelled floor
usb_zc = usb_z0 + usb_pcb[0] / 2;
usb_yc = (air_gap + 0.3 + usb_rec[2] / 2 + usb_pcb[2] + box_d - front - 0.5 - usb_rec[2] / 2) / 2;
usb_pcb_y = usb_yc - usb_rec[2] / 2;               // component face of the PCB
usb_top = usb_z0 + usb_pcb[0];
sock_w = pin_w + 2 * sock_clear;
sock_h = pin_h + 2 * sock_clear;
sock_x0 = arm_xc - sock_w / 2 - sock_wall;
sock_x1 = arm_xc + sock_w / 2 + sock_wall;
sock_z0 = pin_z0 - sock_clear - sock_wall;
sock_z1 = pin_z0 + pin_h + sock_clear + sock_wall;
sw_xc = min(arm_xc - arm_w / 2, sock_x0) - 0.8 - sw_body[0] / 2 - sw_rim;   // left of arm tab & socket
sw_zc = box_h - sw_from_top;
assert(sw_xc - sw_body[0] / 2 - sw_rim > wall + usb_pcb[1] + 0.3, "switch cradle hits the USB-C board");
assert(sw_zc - sw_body[1] / 2 - sw_rim > usb_zc, "switch cradle hits the lower bay divider");
assert(!arm_mount || sw_xc + sw_body[0] / 2 + sw_rim < min(arm_xc - arm_w / 2, sock_x0), "switch overlaps arm tab or socket");
assert(sw_zc + sw_body[1] / 2 + sw_rim < box_h - wall_top, "switch cradle hits the top wall");
assert(sw_from_top + sw_slot[1] / 2 < tab_band, "switch is below the band the screen leaves uncovered");

// Unblocked exhaust zones: side/top windows sit outside the 5.2 mm recess (Y = out_y0 .. out_y1);
// bottom-back slots sit in the back gap (Y = 0 .. air_gap), baffled behind the screen hinge arm.
out_y0 = recess_clear;
out_y1 = box_d - front;
out_d = out_y1 - out_y0;
assert(out_y0 > 5.2 && out_d >= 4.0, "side/top exhaust must sit outside the 5.2 mm recess");
rz0 = 4.8;
rz1 = box_h - wall_top - 1.4;
n_right = 4;
r_slot = (rz1 - rz0 - (n_right - 1) * rib) / n_right;
tx_l0 = 33.8;                                       // strictly right of the eyepiece (X_box = 32)
tx_l1 = fan_x - 1.0;
lz0 = usb_top + 0.8;                                // strictly above the USB-C PCB and its upper post
lz1 = box_h - wall_top - 1.2;
n_bot = floor((box_w - 11 + rib) / rib_pitch);
bot_slot = rib_pitch - rib;
bot_span = n_bot * rib_pitch - rib;
bot_x0 = (box_w - bot_span) / 2;

a_right = n_right * max(0, r_slot) * out_d;
a_top_l = (tx_l1 > tx_l0) ? (tx_l1 - tx_l0) * out_d : 0;   // socket collar stops below the top wall, keeping top-left exhaust open
a_left = max(0, lz1 - lz0) * out_d;
a_bot = n_bot * bot_slot * air_gap;
side_top_area = a_right + a_top_l + a_left;
exit_area = side_top_area + a_bot;
fan_free = PI * (pow(fan / 2 - 1, 2) - pow(fan * 0.2, 2));
assert(sock_x1 < fan_x, "arm socket hits the fan");
assert(sock_z1 < box_h - wall_top - 0.5, "arm socket hits the top wall");
assert(pin_z0 - sock_clear > box_h - tab_band, "arm socket extends below uncovered top band");

echo(str("Box W x H x D = ", box_w, " x ", box_h, " x ", box_d, " mm, fan ", fan, "x", fan, "x", fan_t, " at x=", fan_x));
echo(str("Unblocked exhaust ", round(exit_area), " mm2 (side/top ", round(side_top_area),
         " + bottom-back ", round(a_bot), ") vs fan free area ", round(fan_free), " mm2"));

// ---------- part ----------
module front_face_2d() {
    difference() {
        square([box_w, box_h]);
        translate([fan_x + fan / 2, fan_zc]) {
            difference() {
                circle(d = fan - 2);
                circle(d = fan * 0.25);                                  // hub disc over the motor
                difference() { circle(r = fan * 0.30 + 1); circle(r = fan * 0.30); }
                for (a = [90, 210, 330]) rotate(a) translate([0, -0.7]) square([fan, 1.4]);
            }
            for (i = [-1, 1], j = [-1, 1]) translate([i, j] * fan_holes / 2) circle(d = fan_screw_d);
        }
    }
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
            // lower bay divider (Z <= usb_zc, Y >= air_gap): guards USB-C bay while leaving back & top open
            translate([wall + bay_w, air_gap, 0]) cube([wall, box_d - front - air_gap + 0.01, usb_zc]);
            // inside floor following the bevel (thinner where the fan's bottom edge sits)
            difference() {
                rotate([90, 0, 90]) translate([0, 0, wall - 0.01]) linear_extrude(box_w - 2 * wall + 0.02)
                    polygon([[0, -1], [box_d - front + 0.01, slant(box_d - front) - 1],
                             [box_d - front + 0.01, slant(box_d - front) + floor_t], [0, floor_t]]);
                translate([fan_x - 0.2, air_gap - 0.2, fan_zc - fan / 2 - 0.2]) cube([fan + 0.4, fan_t + 0.4, fan + 0.4]);
            }
            // open-backed pin socket collar for the shoe arm's tapered lug
            if (arm_mount) translate([sock_x0, box_d - sock_d, sock_z0])
                cube([sock_x1 - sock_x0, sock_d - front + 0.01, sock_z1 - sock_z0]);
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
        // unblocked exhaust windows outside the 5.2 mm recess (solid back rim on left, top, right)
        if (r_slot > 0) for (i = [0 : n_right - 1])
            translate([box_w - wall - 1, out_y0, rz0 + i * (r_slot + rib)]) cube([wall + 2, out_d, r_slot]);
        if (tx_l1 > tx_l0)
            translate([tx_l0, out_y0, box_h - wall_top - 1]) cube([tx_l1 - tx_l0, out_d, wall_top + 2]);
        if (lz1 > lz0)
            translate([-1, out_y0, lz0]) cube([wall + 2, out_d, lz1 - lz0]);
        // bottom-back exhaust band (baffled behind the screen hinge arm)
        for (i = [0 : n_bot - 1])
            translate([bot_x0 + i * rib_pitch, -1, -1]) cube([bot_slot, air_gap + 1, slant(air_gap) + floor_t + 1.6]);
        // USB-C: shell opening, and the outside counterbore down to a thin wall
        translate([-1, usb_yc, usb_zc]) rrect_x(usb_rec[2] + 0.4, usb_rec[0] + 0.4, wall + 2, 1.2);
        translate([-1, usb_yc, usb_zc]) rrect_x(usb_cbore[1], usb_cbore[0], 1 + wall - usb_thin, 2.5);
        // slide switch: knob slot through the front plate, body pocket in the cradle
        translate([sw_xc - sw_slot[0] / 2, box_d - front - 1, sw_zc - sw_slot[1] / 2]) cube([sw_slot[0], front + 2, sw_slot[1]]);
        translate([sw_xc - sw_body[0] / 2 - 0.1, box_d - front - 3.5, sw_zc - sw_body[1] / 2 - 0.1]) cube([sw_body[0] + 0.2, 3.5 + 0.01, sw_body[1] + 0.2]);
        // L left of the slot, H right (engraved 0.4 mm into the front face)
        for (m = [["L", -1], ["H", 1]]) translate([sw_xc + m[1] * (sw_slot[0] / 2 + 2.2), box_d + 0.01, sw_zc])
            rotate([90, 0, 0]) linear_extrude(0.41) text(m[0], size = 2.6, halign = "center", valign = "center", font = "Liberation Sans:style=Bold");
        // open-backed pin pocket through the front face and collar
        if (arm_mount) translate([arm_xc - sock_w / 2, box_d - sock_d - 0.5, pin_z0 - sock_clear])
            cube([sock_w, sock_d + 1.5, sock_h]);
        // bottom bevel across the full depth: 0 at the plate, slant_rise at the outside face
        rotate([90, 0, 90]) translate([0, 0, -1]) linear_extrude(box_w + 2)
            polygon([[-1, -1], [box_d + 1, -1], [box_d + 1, slant(box_d + 1)], [-1, slant(-1)]]);
    }
}

// The modules are drawn with the operator at +Y; the real part is their mirror image.
if (show_part) color("WhiteSmoke")
    if (orient == "print") translate([0, 0, box_d]) rotate([90, 0, 0]) mirror([0, 1, 0]) box();
    else mirror([0, 1, 0]) box();
