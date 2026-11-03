// Short preset of fan-duct-reducer.scad: 60 mm tall instead of 100 mm.
// Edit the values below (or use Window > Customizer). See README.md for what each one does.
use <fan-duct-reducer.scad>

/* [Sizes] */
// Units for large_size / small_size (everything else is mm)
units = "inch"; // [inch, mm]
// Nominal diameter of the large duct
large_size = 6;
// Nominal diameter of the small duct
small_size = 5;

/* [Fit] */
// over: reducer slides OVER the pipe (size = pipe outer diameter). into: reducer slides INTO the pipe/hose (size = its inner diameter)
large_fit = "over"; // [over, into]
small_fit = "over"; // [over, into]
// Diametral slip-fit clearance, mm
clearance = 0.5;

/* [Shape] */
// Wall thickness, mm
wall = 3;
// Length of the tapered section, mm
taper_height = 30;
// Length of the straight collar on the large end, mm
large_lip = 15;
// Length of the straight collar on the small end, mm
small_lip = 15;

duct_reducer(units = units, large_size = large_size, small_size = small_size,
             large_fit = large_fit, small_fit = small_fit, clearance = clearance,
             wall = wall, taper_height = taper_height, large_lip = large_lip, small_lip = small_lip);
