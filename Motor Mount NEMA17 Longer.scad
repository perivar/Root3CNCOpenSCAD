
#import("Motor Mount NEMA17.STL");
epsilon = 0.1;
offset = 10;
distx = 31;
disty = 15;

nema17_holder();

module nema17_holder() {
difference() {

translate([0,0,0]) rotate([0,0,0]) cube([86,46,73]);   
   
   //holder(); 

// skewed box
translate([-epsilon,-3.1,0]) rotate([62.4,0,0]) cube([86+2*epsilon,90,50]);    
    
    // skewed chamfer
    translate([0,-30.5,0]) rotate([-27.6,0,0]) rotate([0,0,45]) cube([20,20,100]);   
   
    // skewed chamfer
    translate([86,-30.5,0]) rotate([-27.6,0,0]) rotate([0,0,45]) cube([20,20,100]);      
    
    translate([0,46-4,0])  rotate([0,0,45]) cube([20,20,100]);   
    
    translate([86,46-4,0])  rotate([0,0,45]) cube([20,20,100]);   
    
    
    // cutout
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

translate([21,43,10]) cube([44,3+epsilon,59]);

    screw_slot(0, 15);
    screw_slot(31, 15);
    
    screw_slot(0, 15, 31);
    screw_slot(31, 15, 31);
    
    motor_hole();
    
    // hex slot
translate([43,44.5-8/2,10-epsilon]) rotate([0,0,90]) cylinder(d=7, h=20, $fn = 6, center=false);
    
    // hex slot cut box
    translate([43-3,40,10]) cube([6,6,12]);
    
    // and screw hole
translate([43,44.5-8/2,10-epsilon-11]) rotate([0,0,90]) cylinder(d=4, h=20, $fn = 30, center=false);
    
    
}
    
    
}
}

module holder() {
 
 difference() {

union() {      
translate([0,35,offset]) cube([86,11,73-offset]);
}

union() {

translate([21,43,10]) cube([44,3+epsilon,59]);

    screw_slot(0, 15);
    screw_slot(31, 15);
    
    screw_slot(0, 15, 31);
    screw_slot(31, 15, 31);
    
    motor_hole();
    
translate([43,44.5-8/2,10-epsilon]) rotate([0,0,90]) cylinder(d=7, h=20, $fn = 6, center=false);
    
    translate([43-3,40,10]) cube([6,6,12]);
    
}

}
    
}

module screw_slot(distx = 0, disty = 0, l=0) {
hull() {
translate([27.5+distx,43+epsilon,16.5+l]) rotate([90,0,0]) cylinder(d=4, h=8+2*epsilon, $fn = 30, center=false);

translate([27.5+distx,43+epsilon,16.5+disty+l]) rotate([90,0,0]) cylinder(d=4, h=8+2*epsilon, $fn = 30, center=false);
}
}


module motor_hole() {
    hull() {
translate([43,43+epsilon,47]) rotate([90,0,0]) cylinder(d=24, h=8+2*epsilon, $fn = 30, center=false);
        
translate([43,43+epsilon,47-15]) rotate([90,0,0]) cylinder(d=24, h=8+2*epsilon, $fn = 30, center=false);        
    }
}