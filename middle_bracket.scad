include <dimensions.scad>;
use <bottom_bracket.scad>;

// the Creality Max prints about 0.3% smaller, so if the model is
// 280mm long, it comes out to about 279mm actual
total_length = 280; // requires build volume 300

difference() {
  rotate([0, 90, 0])
    main_body(h=total_length);
  translate([total_length, 0, 0])
    rotate([0, 90, 0])
    joiner_pins_female();
}
  

translate([-pin_length, 0, 0]) {
  rotate([0, 90, 0]) {
    joiner_pins_male();
  }
}

simple_hd_seal();
