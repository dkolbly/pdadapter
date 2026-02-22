include <dimensions.scad>;
use <bottom_bracket.scad>;

total_length = adjust_length_error(280);

difference() {
  rotate([0, 90, 0])
    main_body(h=total_length);
  union() {
    translate([total_length, 0, 0])
      rotate([0, 90, 0])
      joiner_pins_female();
    translate([0,
               -seal_large_width/2,
               seal_floor_offset - latch_plate_over_depth])
    # cube([latch_plate_over_extension,
      seal_large_width,
      seal_depth + latch_plate_over_depth]);
  }
}
  

translate([-pin_length, 0, 0]) {
  rotate([0, 90, 0]) {
    joiner_pins_male();
  }
}

simple_hd_seal();
