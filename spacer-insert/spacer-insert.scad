$fn=120;
height=8.6; // Desired overall height
inner_width=7.5; // Inner tube 
outer_width=10.25; // Together with expansion at the top
sticking_out=0.30;
thickness=1.8; // lip


inner_radius=inner_width/2;
inner_cutout=inner_radius-(thickness/3);

outer_radius=outer_width/2;
outer_cutout=outer_radius-(thickness);

union(){
    union(){
        difference(){
            translate ([0,0,0]) cylinder (r=inner_radius,h=height);
            translate ([0,0,0-0.01]) cylinder (r=inner_cutout,h=height+.02);
        }
    }


    // top
    difference(){
        translate ([0,0,0]) cylinder (r=outer_radius,h=sticking_out);
        translate ([0,0,0-0.01]) cylinder (r=outer_cutout,h=sticking_out+0.02);
    }
}