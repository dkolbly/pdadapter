include <dimensions.scad>;
use <bottom_bracket.scad>;

total_length = 290; // requires build volume 300
mounting_screw_distance = 110;

inner_track_width = 12.6;
inner_track_depth = 6.5 - 0.5;

hardware_allowance = 250;

module prism(l, w, h) {
    polyhedron(// pt      0        1        2        3        4        5
               points=[[0,0,0], [0,w,h], [l,w,h], [l,0,0], [0,w,0], [l,w,0]],
               // top sloping face (A)
               faces=[[0,1,2,3],
               // vertical rectangular face (B)
               [2,1,4,5],
               // bottom face (C)
               [0,3,5,4],
               // rear triangular face (D)
               [0,4,1],
               // front triangular face (E)
               [3,2,5]]
               );
}


latch_bracket_holes = [-111, 0, 111];
latch_bracket_attachment_length = 25;
latch_bracket_attachment_hole_diameter = 5.1;

// a single raised part (i.e., part of the inner track) which is where
// the latch bracket will screw through the bracket assembly into the
// PD frame.  Coordinate system is centered at the X center (i.e.,
// where the screw hole will be), and also in the Y direction.  Z=0
// should be at the rail floor.
module latch_bracket_attachment_point() {
  translate([-latch_bracket_attachment_length/2, -inner_track_width/2, 0]) {
    cube([latch_bracket_attachment_length, inner_track_width, inner_track_depth]);
    translate([(3/2)*latch_bracket_attachment_length, 0, 0]) {
      rotate([0, 0, 90]) {
        prism(inner_track_width, latch_bracket_attachment_length/2, inner_track_depth);
      }
    }
    translate([-(1/2)*latch_bracket_attachment_length, inner_track_width, 0]) {
      rotate([0, 0, -90]) {
        prism(inner_track_width, latch_bracket_attachment_length/2, inner_track_depth);
      }
    }
  }
}

// same coordinate system as latch_bracket_attachment_point
module latch_bracket_screw_hole() {
    translate([0, 0, -depth])
      cylinder_outer(height = depth + inner_track_depth,
                     radius = latch_bracket_attachment_hole_diameter / 2,
                     fn = 4);
}

module inner_track() {
  // center our coord system along the length
  translate([total_length/2, 0, 0]) {
    for (x = latch_bracket_holes) {
      translate([x, 0, 0])
        latch_bracket_attachment_point();
    }
  }
}

module inner_track_holes() {
  // center our coord system along the length
  translate([total_length/2, 0, 0]) {
    for (x = latch_bracket_holes) {
      translate([x, 0, 0])
        latch_bracket_screw_hole();
    }
  }
}

module main_segment(l, ts) {
  rotate([0, 90, 0])
    main_body(h=l, ts=ts);
}

// edge_length = (total_length - hardware_allowance) / 2;
edge_length = 5;

module center_bracket() {
  difference() {
    center_bracket_no_holes();
    inner_track_holes();
  }
}

// this is the ramp from the base layer (z=0) to the trap seal.
// coordinate system ...
module trapezoid_seal_ramp() {
  x0 = 0;
  x1 = seal_floor_offset + seal_depth; // create a 45 degree angle

  z0 = 0;
  z1 = seal_floor_offset + seal_depth;
  z2 = seal_floor_offset;

  y0 = -seal_small_width / 2;
  y1 = -y0;
  y2 = -seal_large_width / 2;
  y3 = -y2;
  y4 = -hd_enclosure_width / 2;
  y5 = -y4;

  #
  polyhedron(points=[[x0, y0, z1],
                     [x0, y1, z1],
                     [x0, y2, z2],
                     [x0, y3, z2],
                     [x0, y2, z2],
                     [x0, y3, z2],
                     [x0, y4, z0],
                     [x0, y5, z0],
                     [x1, y0, z1],
                     [x1, y1, z1],
                     [x1, y2, z2],
                     [x1, y3, z2],
                     [x1, y4, z0],
                     [x1, y5, z0]],
             faces=[[0, 1, 5, 4],
                    [5, 1, 3],
                    [4, 2, 0],
                    [1, 0, 2, 3],
                    [2, 4, 5, 3]]);
}

module center_bracket_no_holes() {
  // indoor HD seal
  translate([0,
             -(hd_enclosure_width/2 + overhang_indoor_width),
             -depth]) {
    cube([total_length,
          overhang_indoor_width,
          depth + hd_enclosure_depth]);
  }

  // outdoor HD seal
  translate([0,
             hd_enclosure_width/2,
             -depth]) {
    cube([total_length,
          overhang_outdoor_width,
          depth + hd_enclosure_depth]);
  }

  //seal(l=total_length, h=hd_enclosure_depth + depth); // the 10 is the overhang

  inner_track();

  // the x=0 end cap
  main_segment(edge_length, true);
  translate([edge_length, 0, 0]) trapezoid_seal_ramp();

  translate([-pin_length, 0, 0]) {
    rotate([0, 90, 0]) {
      joiner_pins_male();
    }
  }

  // the x-max end cap
  translate([total_length - edge_length, 0, 0]) main_segment(edge_length, true);

  // the long body (note this part does not have the trapezoidal seal part)
  translate([edge_length, 0, 0]) main_segment(hardware_allowance, false);

  grippies(l=total_length);
}

//rotate([0, 90, 0])

if (false) {
  center_bracket();
 } else {
  intersection() {
    center_bracket();
    translate([-50, -50, -50]) cube([50+80, 100, 100]);
  }
 }
