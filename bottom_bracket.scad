include <dimensions.scad> 

module screw_slot() {
  $fn=32;
  
  cylinder(h=total_height+1, d=screw_body_clearance);
  cylinder(h=total_height - screw_body_depth - screw_angle_depth, d=screw_head_clearance);
  translate([0, 0, total_height - screw_body_depth - screw_angle_depth]) {
    cylinder(h=screw_angle_depth, d1=screw_head_clearance, d2=screw_body_clearance);
  }
}

// Z should be set to the surface that is being joined to
module joiner_pins_male() {
  translate([depth/2, (hd_enclosure_width/2) - pin_diameter, 0]) {
    cylinder(d=pin_diameter, h=pin_length, $fn=24);
  }
  translate([depth/2, -((hd_enclosure_width/2) - pin_diameter), 0]) {
    cylinder(d=pin_diameter, h=pin_length, $fn=24);
  }
}

module cylinder_outer(height,radius,fn){
  fudge = 1/cos(180/fn);
  cylinder(h=height,r=radius*fudge,$fn=fn);
}

module sphere_outer(r,fn){
  fudge = 1/cos(180/fn);
  sphere(r=r*fudge,$fn=fn);
}

module octahedron(r=10) {
    polyhedron(
        points=[
            [r,0,0], [-r,0,0], [0,r,0], [0,-r,0], // Equator
            [0,0,r], [0,0,-r]                      // Poles
        ],
        faces=[
            [0,2,4], [2,1,4], [1,3,4], [3,0,4],    // Top faces
            [0,3,5], [3,1,5], [1,2,5], [2,0,5]     // Bottom faces
        ]
    );
}

module joiner_pins_female() {
  module pin() {
    cylinder_outer(radius=pin_diameter/2, height=pin_length, fn=24);
    translate([0, 0, pin_length]) {
      sphere(r=pin_diameter/2, $fn=8);
    }
  }
  
  translate([depth/2, (hd_enclosure_width/2) - pin_diameter, -pin_length]) {
    pin();
  }
  translate([depth/2, -((hd_enclosure_width/2) - pin_diameter), -pin_length]) {
    pin();
  }
}

module main_body(ts=true, h=total_height) {

  // the radius of the little fold in the PD side
  pd_enclosure_mini_radius = 0.8;
  dfloor = (ts ? seal_floor_offset : 0);
    
  difference() {
    
    translate([-dfloor, -hd_enclosure_width/2, 0]) {
      cube([dfloor + depth,hd_enclosure_width, h]);
    }

    translate([depth - pd_enclosure_depth, -pd_enclosure_width/2, 0]) {
      cube([pd_enclosure_depth, pd_enclosure_width, h]);
      rotate([0, 0, 90]) {
        translate([pd_enclosure_mini_radius, 0, 0]){
          cylinder(r=pd_enclosure_mini_radius, h=h, $fn=20);
        }
        translate([pd_enclosure_width - pd_enclosure_mini_radius, 0, 0]) {
          cylinder(r=pd_enclosure_mini_radius, h=h, $fn=20);
        }
      }
    }
  }

  if (ts) {
    translate([-dfloor, 0, 0])
    trapezoid_seal(h=h);
  }
}

// the trapezoidal seal
module trapezoid_seal(h=total_height) {
  x0 = -seal_depth;

  y0 = -seal_small_width / 2;
  y1 = seal_small_width / 2;
  y2 = -seal_large_width / 2;
  y3 = seal_large_width / 2;
  
  linear_extrude(height=h) {
    polygon(points=[[x0, y0], [x0, y1], [0, y3], [0, y2]]);
  }
}

module track_slot() {
  translate([-seal_depth, 0, 0]) {
    rotate(a=[0,90,0]) {
      cylinder(h=(seal_depth+depth), d=track_diameter, $fn=32);
    }
  }
}

module seal(h=overhang_height, l=hd_enclosure_depth + depth) {

  // the indoor overhang
  translate([0,
             -hd_enclosure_width/2 - overhang_indoor_width,
             track_height]) {
    cube([l,
          overhang_indoor_width,
          h]);
  }

  // the outdoor overhang
  translate([0,
             hd_enclosure_width/2,
             track_height]) {
    cube([l,
          overhang_outdoor_width,
          h]);
  }
}

module seal_overhang(l=hd_enclosure_depth + depth) {
  translate([-hd_enclosure_depth, 0, 0])
    seal(l=l);
}


screw_y_offset = total_width / 4 + 1;
screw_x_offset = screw_body_clearance + 2;

module screw_slots() {
  translate([screw_x_offset, screw_y_offset, 0])
    screw_slot();
  
  translate([screw_x_offset, -screw_y_offset, 0])
    screw_slot();
}

// some little dots to help grip the petdoor side
module grippies(l=total_length) {
  grippy_radius = 0.75;
  
  for (x=[10, l-10, l/2]) {
    translate([x, 0, 0]) {
      translate([0, pd_enclosure_width/2, pd_enclosure_depth/2 - depth]) {
        sphere(r=grippy_radius, $fn=8);
      }
      translate([0, -pd_enclosure_width/2, pd_enclosure_depth/2 - depth]) {
        sphere(r=grippy_radius, $fn=8);
      }
    }
  }
}

module bottom_bracket() {
  
  seal_overhang();

  // screw_slots();

  difference() {
    main_body();
    track_slot();

    translate([0, 0, total_height-pin_length]) {
      joiner_pins_male();
    }
  }
}

// rotate([0, 180, 0])
translate([0, 0, -total_height]) bottom_bracket();
