
//import("Motor Mount NEMA17.STL");
epsilon = 0.1;

nema17_holder();

module nema17_holder() {

  difference() {

    // main box
    cube([86,46,73]);   
   
    // skewed box
    translate([-epsilon,-3.1,0]) rotate([62.4,0,0]) cube([86+2*epsilon,90,50]);    
    
    // skewed chamfer
    translate([0,-30.5,0]) rotate([-27.6,0,0]) rotate([0,0,45]) cube([20,20,100]);   
   
    // skewed chamfer
    translate([86,-30.5,0]) rotate([-27.6,0,0]) rotate([0,0,45]) cube([20,20,100]);      
    
    // straight chamfer
    translate([0,46-4,0])  rotate([0,0,45]) cube([20,20,100]);   
    
    // straight chamfer
    translate([86,46-4,0])  rotate([0,0,45]) cube([20,20,100]);   
    
    // cutout a rounded shape
    hull() {
        //left
        translate([20-2*epsilon,46-11,11-epsilon]) rotate([90,0,0]) cylinder(d=10, h=46-11+epsilon, $fn = 30, center=false);

        translate([20+2*epsilon,30,11-epsilon]) rotate([0,0,0]) cylinder(d=10, h=86, $fn = 30, center=false);

        // right
        translate([86-20+2*epsilon,46-11,11-epsilon]) rotate([90,0,0]) cylinder(d=10, h=46-11+epsilon, $fn = 30, center=false);

        translate([86-20+2*epsilon,30,11-epsilon]) rotate([0,0,0]) cylinder(d=10, h=86, $fn = 30, center=false);    
    }

    // window
    translate([23,11,-epsilon]) rotate([0,0,0]) cube([40,24,6+2*epsilon]); 

    // screw slots
    union() {
        // indented back plate
        translate([21,43,10]) cube([44,3+epsilon,59]);

        translate([27.5,43,16.5]) {
            screw_slot(0, 15, 0);
            screw_slot(31, 15, 0);            
            screw_slot(0, 15, 31);
            screw_slot(31, 15, 31);
        }
    
        translate([43,43,47]) motor_hole();

        // front nut and screw slots
        translate([7,5.5,0]) hex_screw_hole(screw_dia=3, flats_dia=5.5, nut_height=20, screw_height=4, clearance=0.26);

        translate([43,5.5,0]) hex_screw_hole(screw_dia=3, flats_dia=5.5, nut_height=20, screw_height=4, clearance=0.26);

        translate([79,5.5,0]) hex_screw_hole(screw_dia=3, flats_dia=5.5, nut_height=20, screw_height=4, clearance=0.26);

        // back nut and screw slots
        translate([43,40.5,0]) hex_screw_hole(screw_dia=3, flats_dia=5.5, nut_height=20, screw_height=4, clearance=0.26);

        // inner screw slots
        translate([7,40.5,0]) inner_hex_screw_hole(screw_dia=3, flats_dia=5.5, nut_height=4, screw_height=20, clearance=0.26);

        translate([79,40.5,0]) inner_hex_screw_hole(screw_dia=3, flats_dia=5.5, nut_height=4, screw_height=20, clearance=0.26, flip=true);     
    }
  }
}

module screw_slot(distx=0, disty=0, distz=0, thickness=8) {
    hull() {
        translate([distx,epsilon,distz]) rotate([90,0,0]) cylinder(d=4, h=thickness+2*epsilon, $fn=30, center=false);

        translate([distx,epsilon,distz+disty]) rotate([90,0,0]) cylinder(d=4, h=thickness+2*epsilon, $fn=30, center=false);
    }
}

module motor_hole(length=15, thickness=8) {
    hull() {
        translate([0,epsilon,0]) rotate([90,0,0]) cylinder(d=24, h=thickness+2*epsilon, $fn=30, center=false);
                
        translate([0,epsilon,-length]) rotate([90,0,0]) cylinder(d=24, h=thickness+2*epsilon, $fn=30, center=false);        
    }
}

module hex_screw_hole(screw_dia = 3, flats_dia = 5.5, nut_height = 10, screw_height = 4, clearance = 0.05) {
    
    //flats_dia = 5.5; // M3 nut
    //flats_dia = 6.0; // M3.5 nut
    //flats_dia = 7.0; // M4 nut
    //flats_dia = 8.0; // M5 nut
    
    //clearance = 0.05; // perfect fit for a hex nut?

    num_sides = 6;
    hex_rad = flats_dia / 2 / cos(180 / num_sides);
    
    // nut
    translate([0,0,screw_height]) rotate([0,0,90]) cylinder(r = hex_rad + clearance, $fn= num_sides, h=nut_height);  
    
    // screw
    translate([0,0,-epsilon]) cylinder(r = screw_dia / 2 + clearance, $fn= 30, h=screw_height+2*epsilon);
}

module inner_hex_screw_hole(screw_dia = 3, flats_dia = 5.5, nut_height = 10, screw_height = 4, clearance = 0.05, flip=false) {

    num_sides = 6;
    hex_rad = flats_dia / 2 / cos(180 / num_sides);

    // nut
    translate([0,0,4]) cylinder(r = hex_rad + clearance, $fn= num_sides, h=nut_height);  
    
    // container box
    cont_length = 12;
    if (flip) {
        translate([-3.5,-3,5]) cube([cont_length,6,3]);
    } else {    
        translate([3.5-cont_length,-3,5]) cube([cont_length,6,3]);
    }
    
    // screw
    translate([0,0,-epsilon]) cylinder(r = screw_dia / 2 + clearance, $fn= 30, h=screw_height+2*epsilon); 
}
