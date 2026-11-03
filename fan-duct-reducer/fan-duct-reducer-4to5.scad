// 4" to 5" preset of fan-duct-reducer.scad, shortest support-free version (52 mm):
// small end plugs into a 4" sheet-metal roaster exhaust pipe, 5" duct slides into the large end.
// Edit the values below (or use Window > Customizer). See README.md for what each one does.
use <fan-duct-reducer.scad>

/* [Sizes] */
// Units for large_size / small_size (everything else is mm)
units = "inch"; // [inch, mm]
// Nominal diameter of the large (5") end
large_size = 5;
// Diameter of the small (4") end. Measure the pipe! With small_fit = "into" this is the pipe's INNER diameter
small_size = 4;

/* [Fit] */
// over: reducer slides OVER the pipe (size = pipe outer diameter). into: reducer slides INTO the pipe/hose (size = its inner diameter)
large_fit = "over"; // [over, into]
// into: reducer slides into the thin sheet-metal roaster pipe; forgiving, a hose clamp around the pipe takes up any slack
small_fit = "into"; // [over, into]
// Diametral slip-fit clearance, mm
clearance = 0.5;

/* [Shape] */
// Wall thickness, mm
wall = 3;
// Length of the tapered section, mm. 17 is the shortest that stays under 45 deg (support-free) for this size/fit
taper_height = 17;
// Length of the straight collar on the large end, mm (enough for tape or a clamp on the 5" duct)
large_lip = 15;
// Length of the straight collar on the small end, mm (fits a ~13 mm hose clamp around the pipe)
small_lip = 20;

duct_reducer(units = units, large_size = large_size, small_size = small_size,
             large_fit = large_fit, small_fit = small_fit, clearance = clearance,
             wall = wall, taper_height = taper_height, large_lip = large_lip, small_lip = small_lip);
