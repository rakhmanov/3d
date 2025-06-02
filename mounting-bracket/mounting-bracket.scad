// Bracket
$fn=60;
width=70;
height=14;
depth=8.5;

module body(){
    p0 = [0, 0];
    p1 = [0, height];
    p2 = [7.5, height];
    p3 = [11.5, height-4];
    p4 = [47.5, height-4];
    p5 = [50.5, height];
    p6 = [width, height];
    p7 = [width, 0];

    points = [p0, p1, p2, p3, p4, p5, p6, p7];
    linear_extrude(height=depth) polygon(points);
}

module holes(){
    translate([11, height-8.5, 0-.01]) cylinder(r=1.8, h=depth+0.02);
    translate([55.5, height-8.5, 0-.01]) cylinder(r=1.8, h=depth+0.02);
}


module wheelCuts(){
    translate([0, -2, 0-.01]) cylinder(r=7, h=depth+0.02);
    translate([width, -2, 0-.01]) cylinder(r=7, h=depth+0.02);
}



difference() {
    body();
    holes();
    wheelCuts();
}