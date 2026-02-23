include <dimensions.scad>;
use <bottom_bracket.scad>;

total_length = adjust_length_error(176); // requires build volume 300

screw_carveout_depth = 4;
screw_carveout_inset_offset = 7;
screw_carveout_length_offset = 9;
screw_carveout_diameter = 8;

module expansion_carveout() {
  w = (top_bracket_pd_expansion_width - pd_enclosure_width)/2;
  
  rotate([180, 0, 0]) {
    translate([0,
               -top_bracket_pd_expansion_width/2,
               depth-pd_enclosure_depth]) {
      cube([top_bracket_pd_expansion_length,
              w,
              pd_enclosure_depth]);
    }
    translate([0,
               pd_enclosure_width/2,
               depth-pd_enclosure_depth]) {
      cube([top_bracket_pd_expansion_length,
              w,
              pd_enclosure_depth]);
    }
  }
}

module carveouts() {
    expansion_carveout();

    translate([total_length, 0, 0])
      rotate([0, 90, 0])
      joiner_pins_female();

    w = (top_bracket_pd_expansion_width - pd_enclosure_width)/2;

    // right side
    translate([top_bracket_pd_expansion_length - screw_carveout_length_offset,
               top_bracket_pd_expansion_width/2 + screw_carveout_depth,
               -screw_carveout_inset_offset]) {
      rotate([90, 0, 0])
        # cylinder(r=screw_carveout_diameter/2, h=screw_carveout_depth, $fn=36);
      translate([-screw_carveout_diameter/2, -screw_carveout_depth, -screw_carveout_diameter])
        # cube([screw_carveout_diameter,
               screw_carveout_depth,
               screw_carveout_inset_offset]);
        }
}

if (true) {
  difference() {
    rotate([0, 90, 0]) {
      main_body(h=total_length);
    }
    carveouts();
  }
} else {
  carveouts();
 }

translate([top_bracket_frame_depth, 0, 0])
simple_hd_seal(l=total_length - top_bracket_frame_depth);

