// Fork from https://www.thingiverse.com/thing:713203/file
// by VincentM is licensed under the Creative Commons - Attribution - Share Alike license.

// Height of the gasket
height = 4;

// Roundness
$fn=60; 

difference() {
        // Hull
        hull() {
			translate ([0,0,0]) cylinder (r=5.5,h=height);
			translate ([31,0,0]) cylinder (r=5.5,h=height);
			translate ([0,31,0]) cylinder (r=5.5,h=height);
			translate ([31,31,0]) cylinder (r=5.5,h=height);
        }

        // Bolt holes
		translate ([0,0,0-.01]) cylinder (r=1.7,h=height+.02);
		translate ([31,0,0-.01]) cylinder (r=1.7,h=height+.02);
		translate ([0,31,0-.01]) cylinder (r=1.7,h=height+.02);
		translate ([31,31,0-.01]) cylinder (r=1.7,h=height+.02);
        
        // Center Hole
        translate ([15.5,15.5,-.01]) cylinder (r=12,h=height+.02);
}
