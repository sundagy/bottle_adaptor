include <BOSL/constants.scad>

use <oSCAD_mods/sweep.scad>
use <NopSCADlib/utils/bezier.scad>
use <BOSL/metric_screws.scad>
use <BOSL/threading.scad>

g_fn = 60;
$fn = g_fn;

module bottle(){
    color([0.9,0.4,0.4])
    translate([0,0,-0.3])
    difference(){
        union(){
            rotate_extrude()
            translate([55/2-3,0,0])
            circle(d=6);

            translate([0,0,-50])
            cylinder(50, r=50/2);

            hull(){
                translate([0,0, -18])
                rotate_extrude()
                translate([55/2-3,0,0])
                circle(d=6);
                
                translate([0,0, -18-13])
                rotate_extrude()
                translate([55/2-3,0,0])
                circle(d=6);
            }
        }
        translate([0,0,-140])
        cylinder(150, r=45/2);
        
        translate([-140,0,-80])
        cube([200, 50, 120]);
    }
};

*bottle();
adaptor();

top_wall=1.8;
inner_ofs=1.2;
tube_x=-34;
tube_z=-23.5;
nose_angle=40;
nose_len=20;
nose_size=26;
skrew_h=3.6;
root_len=30;
segments=80;
gap_size = 1;

module screw_body(x, z){
    translate([x, 0, z]) rotate([90,0,0]) cylinder(skrew_h, d=6.7);
}

module screw_hole(x, z){
    translate([x, -skrew_h, z]) rotate([90,0,0]) cylinder(20, d=6.7);
    translate([x, 1, z]) rotate([90,0,0]) cylinder(20, d=4.6);
    //translate([x, 1, z]) rotate([90,0,0]) threaded_rod(d=4.9, l=12, pitch=1.2);
}

module adaptor(){

    *translate([40, 0, 0]) metric_nut(size=5.9, pitch=2, details=true, orient=ORIENT_Y, align=V_FWD);

    difference(){
        union(){
            difference(){
                rotate([0,0,180/segments])
                translate([0,0,-11.15+top_wall])
                hull(){
                    rotate_extrude($fn=segments)
                    translate([45.6/2,0,0])
                    rotate([0,0,-11])
                    scale([0.8,1.6,1])
                    circle(d=18, $fn=g_fn);
                };
                
                inner_r = 56.3;
                
                rotate([0,0,180/segments])
                union(){
                    hull(){
                        rotate_extrude($fn=segments)
                        translate([56.2/2-3.4,-0.4,0])
                        circle(d=7, $fn=g_fn);
                        
                        translate([0,0,-4.1])
                        cylinder(1, r=inner_r/2-inner_ofs, $fn=segments);
                    }
                    translate([0,0,-12])
                    cylinder(8, r=inner_r/2-inner_ofs, $fn=segments);
                    
                    rad=inner_r/2+4;
                    translate([0,0,-12])
                        rotate_extrude($fn=segments)
                        difference(){
                            translate([-rad,-20,0]) square([rad, 20]);
                            translate([-inner_r/2-5+inner_ofs,0,0]) circle(d=10, $fn=g_fn);
                        };
                };

                translate([tube_x,0,tube_z])
                rotate([90,0,0])
                rotate_extrude()
                translate([40,0,0])
                circle(d=21.5);
            };

            translate([tube_x,0,tube_z]) {
                difference(){
                    union(){
                        rotate([90,0,0])
                        rotate_extrude()
                        translate([40,0,0])
                        circle(d=22);
                        
                        screw_body(27, 42);
                    }
                    
                    rotate([90,0,0])
                    rotate_extrude()
                    translate([40,0,0])
                    circle(d=14.6);
                    
                    translate([0,-19,0])
                    rotate([0,90,0])
                    cube([60, 20, 60]);
                    
                    translate([0,-19,0])
                    rotate([0,180+nose_angle,0])
                    translate([-45,0,0])
                    cube([100, 20, 60]);
                    
                    screw_hole(27, 42);
                };
                
                translate([40,0,-root_len])
                difference(){
                    union(){
                        cylinder(root_len, d=22);
                        screw_body(-11.6, root_len/2);
                        screw_body(11.6, root_len/2);
                    }
                    translate([0,0,-1]) cylinder(root_len+2, d=17.4);
                    screw_hole(-11.6, root_len/2);
                    screw_hole(11.6, root_len/2);
                }
                
                rotate([0,180+nose_angle,0])
                translate([40,0,0])
                difference() {
                    union(){
                        translate([0,0,-8]) cylinder(8, d1=0, d2=nose_size);
                        cylinder(nose_len, d=nose_size);
                        translate([0,0,nose_len]) cylinder(8, d1=nose_size, d2=0);
                        screw_body(10, nose_len/2);
                        screw_body(-10, nose_len/2);
                    }
                    translate([0,0,-10]) cylinder(55, d=14.6);
                    screw_hole(10, nose_len/2);
                    screw_hole(-10, nose_len/2);
                }
            };

            screw_body(26, 6.7);
            screw_body(-29, 5.5);
        }
        
        translate([-140,0,-80])
        cube([200, 50, 120]);
        
        screw_hole(26, 6.7);
        screw_hole(-29, 5.5);
    };

    
};

module sweep_bottle(){
    p = [
            [1,0],
            [2,0],
            [10,1], 
            [0,16], 
            [1,0],
    ];
    path = bezier_path(p, $fn);

    polygon(path);

    rotate_extrude()
    translate([51/2-3, 0, 0])
    polygon(path);

    sweep(path, circle_points(1));
};