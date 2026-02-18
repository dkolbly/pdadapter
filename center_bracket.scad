use <bottom_bracket.scad>;

total_length = 290; // requires build volume 300
mounting_screw_distance = 110;

inner_track_width = 12.6;
inner_track_depth = 6.5; // should this be same as seal_depth?  measured as 6.5

hardware_allowance = 250;

module inner_track() {
  // center our coord system along the length
  translate([total_length/2, 0, 0]) {
    translate([-125, -inner_track_width/2, 0]) {
        cube([25, inner_track_width, inner_track_depth]);
    }
    translate([-25/2, -inner_track_width/2, 0]) {
        cube([25, inner_track_width, inner_track_depth]);
    }
    translate([125-25, -inner_track_width/2, 0]) {
        cube([25, inner_track_width, inner_track_depth]);
    }
  }
}

module main_segment(l, ts) {
  rotate([0, 90, 0])
    main_body(h=l, ts=ts);
}

edge_length = (total_length - hardware_allowance) / 2;

module center_bracket() {
  translate([0, 0, -(18+20)]) {
    seal(l=total_length, h=20+10); // the 10 is the overhang
  }

  inner_track();

  // the x=0 end cap
  main_segment(edge_length, true);

  // the x-max end cap
  translate([total_length - edge_length, 0, 0]) main_segment(edge_length, true);

  // the long body (note this part does not have the trapezoidal seal part)
  translate([edge_length, 0, 0]) main_segment(hardware_allowance, false);
}


//  center_bracket();

intersection() {
  center_bracket();
  translate([0, -50, -50]) cube([60, 100, 100]);
}
