include <dimensions.scad>;
use <bottom_bracket.scad>;

total_length = 280;

module latch_plate_carveout() {
  //cube([
}

difference() {
  rotate([0, 90, 0]) {
    main_body(h=total_length);
  }
  union() {
    latch_plate_carveout();
    translate([total_length, 0, 0])
      rotate([0, 90, 0])
      joiner_pins_female();
  }
}

       translate([-pin_length, 0, 0]) {
  rotate([0, 90, 0]) {
    # joiner_pins_male();
  }
}

simple_hd_seal(l=total_length);
