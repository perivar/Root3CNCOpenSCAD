use <MCAD/boxes.scad> // for roundedBox, e.g roundedBox([30, 30, 40], 5, true);
use <MCAD/bearing.scad>;
use <MCAD/nuts_and_bolts.scad>;
use <MCAD/metric_fastners.scad>;

include <C:\Users\perner\My Projects\PulpitRockCNC3D\stepper.scad>

use <C:\Users\perner\My Projects\PulpitRockCNC3D\20-GT2-6 Timing Pulley.scad>


/*
Abbrev.	Inner D.	Outer D.	Thickness	Notes
608		8 mm		22 mm		7 mm	A common roller skate bearing used extensively in RepRaps.
626		6 mm		19 mm		6 mm	 
625		5 mm		16 mm		5 mm	 
624		4 mm		13 mm		5 mm	 
623		3 mm		10 mm		4 mm	 
603		3 mm		9 mm		5 mm	 
*/

bearingInnerDia = 8; 		
bearingOuterDia = 22;	// outer dimensions
bearingThickness = 7;	// thickness
bearingClearance = 0.2;	// clearance around the outer dimensions

bearingDiameter = bearingOuterDia + bearingClearance;

epsilon = 0.1; // small tolerance used for CSG subtraction/addition

// screw/nut dimensions
// http://www.fairburyfastener.com/xdims_metric_nuts.htm
screw_dia = 4.5;	// M3 = 3 mm, M4 = 4 mm - orig. 3.4
nut_dia = 8.2;		// M3 = 6 mm, M4 = 7.7 mm - orig. 6.5
nut_height = 2.5; 	// M3 = 2.3 mm, M4 = 3 mm - orig. 3

module rect_tube(len=500) {
    color("lightgray") {
        rotate([45,0,0]) square_tube(len);
    }
}

module square_tube(len=500) {
    thickness = 1.5;
    dimension = 25;
    
    difference() {
        cube([len,dimension,dimension]);
        
        translate([-epsilon,thickness,thickness]) cube([len+2*epsilon,dimension-2*thickness,dimension-2*thickness]);
    }    
}

module mount() {
    translate([60,25,0]) rotate([0,0,180]) import("Y Axis Bar Mount 25x25 2mm STD.STL");
    translate([0,25,90]) rotate([90,0,0]) mount_cap();
}

module mount_cap() {
    import("Y Gantry Box Section Belt Clamp.STL");
}

module bearing_sandwich() {
    bearing();
    translate([0,0,-0.5]) washer(5);    
    translate([0,0,7]) washer(5);    
}

module y_carriage_top(y = 200) {
    translate([0,0,64]) mirror([0,0,1]) y_carriage_bottom(y);
}

module y_carriage_bottom(y = 200) {

    // carriage measurements: 64 mm wide, 130 mm long
    
    z = 0;
    x = 32 + 1.8; 
        
    translate([-x,y,z]) rotate([90,0,90]) import("Box Section Linear Guild STD.STL");    
    
    // dummy screws for positioning
    len = 80;
    
    for (v = [0, 32.3, 64.7, 97], w = [-len+28,len-28]) {      
    #translate([w,y+16.5+v,6.5]) rotate([0,90,0]) cylinder(h = len, r = 2.4, center = true, $fn=20);
    }
    
    translate([-x+18,y+27,z+15]) rotate([0,-45,0]) bearing_sandwich();
    
    translate([-x+18+32,y+27,z+15]) rotate([0,45,0]) bearing_sandwich();
    
    translate([-x+18,y+27+76,z+15]) rotate([0,-45,0]) bearing_sandwich();
    
    translate([-x+18+32,y+27+76,z+15]) rotate([0,45,0]) bearing_sandwich();        
}

module y_carriage(y = 200) {
    translate([30,0,15.5]) y_carriage_top(y);
    translate([30,0,15.5]) y_carriage_bottom(y);
}

module x_carriage(x = 200, y = 200) {
    translate([456,160-(200-y),92]) rotate([0,0,90]) y_carriage_top(x);
    translate([456,160-(200-y),90]) rotate([0,0,90])y_carriage_bottom(x);
}

module gantry() {
    // gantry is 18 mm thick, 205 mm wide, 300 mm high
    color("BurlyWood") rotate([0,0,90]) import("Y Gantry X side Panel.STL");
        
    translate([-18,0,79.5]) rotate([0,-90,0])    
    x_mount();
    
    translate([0,2,94.8]) rotate([90,0,0])motion_link();
    
    translate([0,76.5,77.5]) rotate([90,0,0])y_bearing_space();
    
    for(i = [0,1,2], j = [0, 35]) {
        translate([17.2+i*7.1,89+j,90]) rotate([0,90,0]) bearing();
    }

    translate([4+17.2+(7.1*2+7),131.5,82.5]) rotate([90,0,0]) y_bearing_cap();
    
    translate([0,148,133]) rotate([0,90,0]) nema_spacer();
    
    translate([50-2,170,112]) rotate([0,-90,0])nema(); 
  
    translate([40,170,112]) rotate([0,-90,0]) GT2Pulley();  
    
    // belts
    color("black") translate([26,26,112+5]) cube([6,150,1.5]);
    
    color("black") translate([26,26,103]) cube([6,70,1.5]);
    
    color("black") translate([26,116,103]) cube([6,65,1.5]);
    
    color("black") translate([26,-250,77]) cube([6,350,1.5]);
    
    color("black") translate([26,115,77]) cube([6,480,1.5]);
    
}

module nema() {
    motor(Nema17, NemaMedium, false, [0,0,0], [180,0,0]);    
}

module gantry_right_side(y = 200) {
    translate([-2+64,y-75,10.5]) mirror([1,0,0]) gantry();
}

module gantry_left_side(y = 200, len = 500) {
    translate([-2+len,y-75,10.5]) gantry();       
}

module nema_spacer() {
    // 50 mm height, 43 mm width
    import("NEMA17 50mm Spacer.STL");
}

module x_mount() {
    // this is 220,56 mm long and 70 mm wide
    import("X Axis Box Section Mount 25x25mm.STL");
}

module y_bearing_cap() {
    // 4 mm thick
    rotate([0,-90,0]) import("Y Gantry Bearing Cap.STL");
}

module y_bearing_space() {
    // 17,2 mm high
    rotate([0,90,0]) import("Y Gantry Bearing Space.STL");
}

module motion_link() {
    //rotate([0,90,0]) import("Y Gantry Motion Link.STL");
    
    translate([-12,22.1,-80]) rotate([90,90,0]) import("Y Gantry Motion Link Remix.stl");
}

module x_z_carriage(x = 100, y = 100) {
         
    // back
    translate([x+127,116-(200-y),90]) x_z_carriage_plate_back();
    
    // front (carriage is 64 mm thick, wood is 12)
    translate([x+127+130,116+64-(200-y),79]) 
    x_z_carriage_plate_front();
    
    translate([x+167.5,238-(200-y),300]) z_bearing_top();
    translate([x+216,238-(200-y),104]) z_bearing_bottom();
    
    // top
    translate([x+127+108,116-(200-y),363]) nema_mount();
    
    // nema 17
    translate([x+127+65,77-(200-y),322]) nema();
    
    // pulley on top of upper nema
    translate([x+127+65,77-(200-y),334-6]) rotate([0,0,0]) GT2Pulley();
    
    // bottom
    translate([x+127+108,116-(200-y),224]) nema_mount();
    
    // nema 17
    translate([x+127+65,77-(200-y),182]) nema();
    
    // x belt idler
    translate([x+127+22,128-(200-y),178]) x_belt_idler();   
   
    // threaded rod
    color("darkgray") translate([x+127+65,218-(200-y),95.5]) rotate([0,0,0]) cylinder(h = 249, r = 8/2, center = false, $fn=20);
    
    // pulley on top of threaded rod 
    translate([x+127+65,218-(200-y),333-5]) rotate([0,0,0]) GT2Pulley();
    
    // belt
    for (i = [0, 14.5]) {
    color("black") translate([x+127+57+i,72-(200-y),336]) cube([1.5,150,6]);
    }
    
    // rods
    color("lightgray") translate([x+127+16.5,223-(200-y),87]) rotate([0,0,0]) cylinder(h = 242, r = 8/2, center = false, $fn=20);

    color("lightgray") translate([x+127+113.5,223-(200-y),87]) rotate([0,0,0]) cylinder(h = 242, r = 8/2, center = false, $fn=20);
    
    // z linear bearing holder
    //translate([x+127-98,204-(200-y),200]) rotate([-90,0,0]) import("Z Axis Smooth Rod Mount Right.stl");
    
    // spindle mount           
    translate([x+127+25.5,186-(200-y),200]) rotate([-90,0,]) z_spindle_mount(); 
}

module z_spindle_mount() {
    
    //translate([-24,0,20]) import("MGN 12 Spindle mount 52mm (NO Text).STL");
    
    if (true) {
    // spindle_aluminum_holder.stl
    color("gray") import("spindle_aluminum_holder.stl");
    
    %difference() {
        union() {
            translate([-9,-2,22]) cube([97,40,30]);
            
            translate([-9,38,37]) rotate([90,0,0]) cylinder(h = 40, r = 30/2, center = false, $fn=20);
            
            translate([88,38,37]) rotate([90,0,0]) cylinder(h = 40, r = 30/2, center = false, $fn=20);
                    }
        
        // lead scew nut bottom
    nut_depth = 5;
    translate([25,38+epsilon-nut_depth,22-epsilon]) cube([28,nut_depth,30+2*epsilon]);
        
        // lead scew nut top
        translate([25,-12-epsilon+nut_depth,22-epsilon]) cube([28,10,30+2*epsilon]);
        
        // middle lead screw 
        translate([39.5,42,32]) rotate([90,0,0]) cylinder(h = 50, r = 12/2, center = false, $fn=20);    
     
        // left rod
        translate([88,42,37]) rotate([90,0,0]) cylinder(h = 50, r = 12/2, center = false, $fn=20);
        
        // right rod
        translate([-9,42,37]) rotate([90,0,0]) cylinder(h = 50, r = 12/2, center = false, $fn=20);
    
           // screw holes to the spindle holder and indents
           translate([-5.7,36,80]) rotate([90,0,0]) for (i = [10,80], j = [8, 28]) {
               // screw hole
               translate([i,20,j]) rotate([90,0,0]) cylinder(r=3, h=80);  
               
               // screw head indents
              indent_depth = 15;
               translate([i,-58-epsilon+indent_depth,j]) rotate([90,0,0]) cylinder(r=11/2, h=indent_depth);  
          }                                 
        }
    }
    
    // top nut
    //translate([39.5,-2,34]) rotate ([-90,0,0]) import("Lead Screw Nut.stl");
    
    // bottom nut
    color("brown") translate([39.5,37-5,34-2]) rotate ([90,45,0]) import("Lead Screw Nut.stl");

}

module x_z_carriage_plate_back() {
    // plate is 275mm long, 130mm wide, and 12mm thick
    color("BurlyWood") translate([0,12,0]) rotate([90,0,0]) import("X Carriage Wooden Panel Back.STL");   
}

module x_z_carriage_plate_front() {
    // plate is 249mm/224mm long, 130mm wide and 12mm thick
    color("BurlyWood") translate([0,12,0]) rotate([-90,180,0]) import("X Carriage Wooden Panel Front.STL");       
    
    //color("BurlyWood") translate([0,12,11]) rotate([-90,180,0]) import("X Carriage Rework wood pannel BACK & Front Compatible.STL");
}

module z_bearing_bottom() {
    //rotate([90,180,0]) import("Z Axis Bearing Cup Bottom.STL");
    
    translate([-121,15.5,24]) rotate([0,180,0]) import("Z Axis Mount Smooth Rods Bottom.stl");
    
    translate([-24,-20,8]) rotate([0,0,0]) bearing();
}

module z_bearing_top() {
    //rotate([90,0,0]) import("Z Axis Bearing Cup Top.STL");
    
    translate([-91.5,185,-2.5-5]) rotate([0,0,180]) import("Z Axis Mount Smooth Rods Top.stl");
    
    translate([24,-20,26-5]) rotate([0,0,0]) bearing();
}

module nema_mount() {
    rotate([90,180,0]) import("Motor Mount NEMA17.STL");
}

module x_belt_idler() {
    import("X Carriage Belt Idler.STL");
    
    for(i = [0,1,2], j=[0,1]) {
        translate([27+j*32,12,12.5+(7.1*i)]) bearing();
    }      
}

module y_axix_sync(len=200) {
    
    // rod
    color("gray") translate([0,0,0]) rotate([0,90,0]) cylinder(h = len, r = 8/2, center = false, $fn=20);    
    
    // right
    translate([15,0,0]) rotate([0,-90,0]) GT2Pulley();
    translate([20,0,0]) rotate([0,-90,0]) bearing();
    
    // left
    translate([len-15,0,0]) rotate([0,90,0]) GT2Pulley();
    translate([len-20,0,0]) rotate([0,-90,0]) bearing();
}
    

x_len = 800;
y_len = 800;
x_pos = -290;      // from 0(500) or -290(800) to 220
y_pos = 300;    // from 30 to y_len - 160

mount();
translate([30,0,30]) rotate([0,0,90]) rect_tube(y_len);
translate([0,y_len,0]) mirror([0,1,0]) mount();

translate([x_len+60,0,0]) mirror([1,0,0]) mount();
translate([x_len+30,0,30]) rotate([0,0,90]) rect_tube(y_len);
translate([x_len,y_len,0]) mirror([0,1,0]) mount();

y_carriage(y_pos);
translate([x_len,0,0]) y_carriage(y_pos);

gantry_left_side(y_pos, x_len);
gantry_right_side(y_pos);

// lower x rect tube
translate([62+18,y_pos-40,105]) rect_tube(x_len-100);

// y axix mechanical sync
translate([62+18-50,y_pos-40,105+17]) y_axix_sync(x_len);

// upper x  rect tube
translate([62+18,y_pos-40,105+155.5]) rect_tube(x_len-100);

x_carriage(x_pos, y_pos);
translate([0,0,155]) x_carriage(x_pos, y_pos);
x_z_carriage(199-x_pos, y_pos);


//!z_spindle_mount();