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
//   solid back rim inside the 5.2 mm recess; 100% unblocked exhaust windows outside the recess
//   (3 right, 6 top slots clear of the eyecup/USB-C bay [2 mid-plenum + 4 across fan & right duct], 1 left above USB-C) + 4 right-side bottom-back bleed slots.

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
// Exhaust ribs & bottom-back vent count
rib = 1.2;
bot_rim = 1.6;        // continuous connecting rail along Y = 0..bot_rim (prevents ribs snapping on insertion)
bot_y1 = 6.0;         // bottom-back exhaust front edge (leaves 7.0 mm solid bevel baffle; 4.4 mm open slot depth)
n_bot = 4;            // right-side only (X = 32.0..76.8): clears screen flex-ribbon connector shelf (X_box ~11..31)
n_top_r = 4;          // uniform slots across fan top & right duct (X = 43.0..77.4)
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
sw_from_top = 8.5;            // switch centre below the box top (inside ~14.5 mm band; headroom under mid-left top slot)
sw_slot = [sw_knob[0] + 2 * sw_step + 0.5, sw_knob[1] + 0.5];   // along, across

/* [Arm mount: tool-free pin-and-socket slide-on shoe arm (sony-a6300-fan-arm.scad)] */
// Open-backed pocket in the front plate accepts the shoe arm's locating lug on -Y slide-in;
// a monolithic top bearing boss fuses the pocket ceiling straight into the box's top wall.
// The same box also works standalone (e.g. micro-suction + screen clamp) without attaching the arm.
arm_mount = true;
arm_xc = 37;          // tab & socket centre in box X: right above the shoe (camera x 41, box placed at x 4)
arm_w = 10;           // arm drop-tab width in X (shared with sony-a6300-fan-arm.scad)
tab_band = 14.5;      // uncovered top band height on the front face
pin_w = 6.0;          // arm lug width in X
pin_h = 6.0;          // arm lug root height in Z at the tab face
pin_len = 4.2;        // arm lug protrusion along -Y (penetrates ~4.0 mm into the pocket)
pin_z0 = 25.0;        // flat bottom shelf height of the lug in box Z
sock_clear = 0.25;    // clearance per side around the lug inside the pocket
sock_wall = 1.4;      // side margin on the fused top bearing boss behind the front plate
sock_d = 4.2;         // total bearing depth from the front face (3.15 mm open top behind boss)

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
sock_top_z = pin_z0 + pin_h + sock_clear;
sw_xc = min(arm_xc - arm_w / 2, sock_x0) - 0.8 - sw_body[0] / 2 - sw_rim;   // left of arm tab & boss
sw_zc = box_h - sw_from_top;
assert(sw_xc - sw_body[0] / 2 - sw_rim > wall + usb_pcb[1] + 0.3, "switch cradle hits the USB-C board");
assert(sw_zc - sw_body[1] / 2 - sw_rim > usb_zc, "switch cradle hits the lower bay divider");
assert(!arm_mount || sw_xc + sw_body[0] / 2 + sw_rim < min(arm_xc - arm_w / 2, sock_x0), "switch overlaps arm tab or socket");
assert(sw_zc + sw_body[1] / 2 + sw_rim < box_h - wall_top, "switch cradle hits the top wall");
assert(sw_from_top + sw_slot[1] / 2 < tab_band, "switch is below the band the screen leaves uncovered");

// Unblocked exhaust zones: wide side/top windows sit outside the 5.2 mm recess (Y = out_y0 .. out_y1);
// 6 top slots stay clear of the eyecup/USB-C bay (X < 22.5): 2 mid-plenum slots + 4 uniform slots across fan & right duct.
// 4 right-side bottom-back slots (Y = bot_rim .. bot_y1) sit past the ribbon shelf under the mid chamber, fan & right duct.
out_y0 = recess_clear;
out_y1 = box_d - front;
out_d = out_y1 - out_y0;
assert(out_y0 > 5.2 && out_d >= 4.0, "side/top exhaust must sit outside the 5.2 mm recess");
rz0 = 4.0;                                          // clears the sloped inner floor at Y = 11.4 (3.84 mm)
rz1 = box_h - wall_top - 0.6;                       // 33.2 mm
n_right = 3;
r_slot = (rz1 - rz0 - (n_right - 1) * rib) / n_right; // 8.93 mm wide slots
lz0 = usb_top + 0.6;                                // strictly above the USB-C PCB and its upper post
lz1 = box_h - wall_top - 0.6;                       // 33.2 mm (8.14 mm tall)
bot_margin = 3.2;                                   // 1.6 mm corner flange inside right wall
top_y1_full = out_y1 - 0.05;                        // 11.35 mm, avoids coplanar seam with front inner face
top_y1_boss = arm_mount ? box_d - sock_d - 0.05 : top_y1_full; // 8.75 mm behind boss & arm (11.35 if noarm)
top_d_full = top_y1_full - out_y0;                  // 5.75 mm
top_d_boss = top_y1_boss - out_y0;                  // 3.15 mm (arm_mount=true) / 5.75 mm (false)
top_l_x0 = 22.5;                                    // right of 24 mm eyecup (X_cam=26.5) & clear of USB-C bay
top_l_x1 = sock_x0 - rib;                           // 31.15 mm
top_m_x0 = sock_x0;                                 // 32.35 mm (directly behind fused arm boss)
top_m_x1 = fan_x - 0.3;                             // 41.80 mm (0.3 mm clear of fan frame)
top_r_x0 = top_m_x1 + rib;                          // 43.00 mm (starts 1 rib right of top_m, across fan & right duct)
top_r_x1 = box_w - wall - 1.0;                      // 77.40 mm
top_r_slot = (top_r_x1 - top_r_x0 - (n_top_r - 1) * rib) / n_top_r; // 7.70 mm wide uniform slots
top_r_pitch = top_r_slot + rib;
top_r_open_w = max(0, top_r_x1 - max(top_r_x0 + (n_top_r - 1) * top_r_pitch, fan_x + fan)); // 5.30 mm unblocked over right duct
assert(top_l_x1 > top_l_x0 + 3 && top_m_x1 > top_m_x0 + 3 && top_r_slot > 3, "top exhaust slots too narrow");
assert(top_r_x0 + (n_top_r - 1) * top_r_pitch <= fan_x + fan, "right-duct top slot obstructed by rib");
assert(top_d_boss >= 2.5, "top slot behind arm boss too shallow");
bot_d = bot_y1 - bot_rim;                           // 4.40 mm open slot depth (matching air_gap)
bot_x0 = 32.0;                                      // X_cam = 36: clears ribbon shelf (X_box ~11..31) & USB-C bay
bot_span = (box_w - bot_margin) - bot_x0;           // 44.8
bot_slot = (bot_span - (n_bot - 1) * rib) / n_bot;  // 10.30 mm wide slots (181 mm2 secondary bleed)
bot_pitch = bot_slot + rib;
bot_cut_z1 = slant(bot_y1) + floor_t + 0.3;         // 2.94 mm: clears sloped inner floor at Y = 6.0, below fan relief
divider_y0 = 5.2;                                   // clear of PCB back face (5.37 mm) while keeping upper bay open
assert(divider_y0 < usb_pcb_y - usb_pcb[2], "bay divider overlaps USB-C PCB");
assert(bot_cut_z1 < fan_zc - fan / 2 - 0.25, "bottom-back cutout reaches the fan");

a_right = n_right * max(0, r_slot) * out_d;
a_top = (top_l_x1 - top_l_x0) * top_d_full + (top_m_x1 - top_m_x0) * top_d_boss + top_r_open_w * top_d_full;
a_left = max(0, lz1 - lz0) * out_d;
a_bot = n_bot * bot_slot * bot_d;
free_air_area = a_right + a_top + a_left;
fan_free = PI * (pow(fan / 2 - 1, 2) - pow(fan * 0.2, 2));
assert(sock_x1 < fan_x, "arm top boss hits the fan");
assert(box_h - wall_top - sock_top_z >= 1.4, "fused top bearing boss too thin");
assert(pin_z0 - sock_clear > box_h - tab_band, "arm pocket extends below uncovered top band");

echo(str("Box W x H x D = ", box_w, " x ", box_h, " x ", box_d, " mm, fan ", fan, "x", fan, "x", fan_t, " at x=", fan_x));
echo(str("Free-air exhaust ", round(free_air_area), " mm2 (right ", round(a_right), " + top ", round(a_top),
         " + left ", round(a_left), ") + secondary bottom-right bleed ", round(a_bot),
         " mm2 (baffled by tilt arm) vs fan free area ", round(fan_free), " mm2"));

// ---------- part ----------
module front_face_2d() {
    difference() {
        square([box_w, box_h]);
        translate([fan_x + fan / 2, fan_zc]) {
            difference() {
                circle(d = fan - 2);
                circle(d = fan * 0.25);                                  // hub disc over the motor
                for (a = [45, 135, 225, 315]) rotate(a) translate([0, -0.6]) square([fan, 1.2]);
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
            // lower bay divider (Z <= usb_zc, Y >= divider_y0): guards USB-C bay while leaving back & top open
            translate([wall + bay_w, divider_y0, 0]) cube([wall, box_d - front - divider_y0 + 0.01, usb_zc]);
            // inside floor following the bevel (thinner where the fan's bottom edge sits)
            difference() {
                rotate([90, 0, 90]) translate([0, 0, wall - 0.01]) linear_extrude(box_w - 2 * wall + 0.02)
                    polygon([[0, -1], [box_d - front + 0.01, slant(box_d - front) - 1],
                             [box_d - front + 0.01, slant(box_d - front) + floor_t], [0, floor_t]]);
                translate([fan_x - 0.2, air_gap - 0.2, fan_zc - fan / 2 - 0.2]) cube([fan + 0.4, fan_t + 0.4, fan + 0.4]);
            }
            // top bearing boss fused solid into both the front plate and the top wall (no side/bottom collar walls)
            if (arm_mount) translate([sock_x0, box_d - sock_d, sock_top_z])
                cube([sock_x1 - sock_x0, sock_d - front + 0.5, box_h - wall_top - sock_top_z + 0.5]);
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
        translate([top_l_x0, out_y0, box_h - wall_top - 1]) cube([top_l_x1 - top_l_x0, top_d_full, wall_top + 2]);
        translate([top_m_x0, out_y0, box_h - wall_top - 1]) cube([top_m_x1 - top_m_x0, top_d_boss, wall_top + 2]);
        for (i = [0 : n_top_r - 1])
            translate([top_r_x0 + i * top_r_pitch, out_y0, box_h - wall_top - 1]) cube([top_r_slot, top_d_full, wall_top + 2]);
        if (lz1 > lz0)
            translate([-1, out_y0, lz0]) cube([wall + 2, out_d, lz1 - lz0]);
        // bottom-back exhaust band (framed by continuous bot_rim back rail, baffled behind the 7 mm front bevel & tilt arm)
        for (i = [0 : n_bot - 1])
            translate([bot_x0 + i * bot_pitch, bot_rim, -1]) cube([bot_slot, bot_d, bot_cut_z1 + 1]);
        // USB-C: shell opening, and the outside counterbore down to a thin wall
        translate([-1, usb_yc, usb_zc]) rrect_x(usb_rec[2] + 0.4, usb_rec[0] + 0.4, wall + 2, 1.2);
        translate([-1, usb_yc, usb_zc]) rrect_x(usb_cbore[1], usb_cbore[0], 1 + wall - usb_thin, 2.5);
        // slide switch: knob slot through the front plate, body pocket in the cradle
        translate([sw_xc - sw_slot[0] / 2, box_d - front - 1, sw_zc - sw_slot[1] / 2]) cube([sw_slot[0], front + 2, sw_slot[1]]);
        translate([sw_xc - sw_body[0] / 2 - 0.1, box_d - front - 3.5, sw_zc - sw_body[1] / 2 - 0.1]) cube([sw_body[0] + 0.2, 3.5 + 0.01, sw_body[1] + 0.2]);
        // L left of the slot, H right (engraved 0.4 mm into the front face)
        for (m = [["L", -1], ["H", 1]]) translate([sw_xc + m[1] * (sw_slot[0] / 2 + 2.2), box_d + 0.01, sw_zc])
            rotate([90, 0, 0]) linear_extrude(0.41) text(m[0], size = 2.6, halign = "center", valign = "center", font = "Liberation Sans:style=Bold");
        // pocket through the front plate under the fused top bearing boss
        if (arm_mount) translate([arm_xc - sock_w / 2, box_d - front - 0.5, pin_z0 - sock_clear])
            cube([sock_w, front + 1.5, sock_h]);
        // bottom bevel across the full depth: 0 at the plate, slant_rise at the outside face
        rotate([90, 0, 90]) translate([0, 0, -1]) linear_extrude(box_w + 2)
            polygon([[-1, -1], [box_d + 1, -1], [box_d + 1, slant(box_d + 1)], [-1, slant(-1)]]);
    }
}

// The modules are drawn with the operator at +Y; the real part is their mirror image.
if (show_part) color("WhiteSmoke")
    if (orient == "print") translate([0, 0, box_d]) rotate([90, 0, 0]) mirror([0, 1, 0]) box();
    else mirror([0, 1, 0]) box();
