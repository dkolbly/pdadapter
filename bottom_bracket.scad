
//      +---------------------+
//      |                     |
//      |                     |
//      |                     |
//      |                     |
//      |                     |
//      |                     |
//      |                     |
//      |                     |
//      |                     |
//      |                     |
//   ^  |                     |
//   |  |                     |
//   Y  |                     |
//   |  |                     |
//   |  |                     |
//      +---------------------+
//       --  X (depth) --> 
// 

// the depth of the main body
depth = 20;

// the width of the enclosure for the human door side
hd_enclosure_width = 45;

// the depth of the enclosure for the human door side
hd_enclosure_depth = 10;

// the width of the indoor overhang
overhang_indoor_width = 6;

// the width of the outdoor overhang
overhang_outdoor_width = 6;

// the total height
total_height = 30;

// the width of the enclosure for the pet door side
pd_enclosure_width = 20;

// the depth of the enclosure for the pet door side
pd_enclosure_depth = 10;

seal_small_width = 20;
seal_large_width = 30;
seal_depth = 6.8;

// the height of the track inset area
track_height = 18;

// the diameter of the track
track_diameter = 7;

// the height of the overhang
overhang_height = total_height - track_height;

// the total width
total_width = hd_enclosure_width + overhang_indoor_width + overhang_outdoor_width;

screw_body_clearance = 4.5;
screw_head_clearance = 9;
screw_body_depth = 10;
screw_angle_depth = 3;

module screw_slot() {
  $fn=32;
  
  cylinder(h=total_height+1, d=screw_body_clearance);
  cylinder(h=total_height - screw_body_depth - screw_angle_depth, d=screw_head_clearance);
  translate([0, 0, total_height - screw_body_depth - screw_angle_depth]) {
    cylinder(h=screw_angle_depth, d1=screw_head_clearance, d2=screw_body_clearance);
  }
}

module main_body(ts=true, h=total_height) {
  difference() {
    translate([0, -hd_enclosure_width/2, 0]) {
      cube([depth,hd_enclosure_width,h]);
    }

    translate([depth - pd_enclosure_depth, -pd_enclosure_width/2, 0]) {
      cube([pd_enclosure_depth, pd_enclosure_width, h]);
    }
  }

  if (ts) {
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

// ---

module bracket() {
  
  seal_overhang();

  // screw_slots();

  difference() {
    main_body();
    union() {
      screw_slots();
      track_slot();
    }
  }
}

rotate([0, 180, 0]) translate([0, 0, -total_height]) bracket();
