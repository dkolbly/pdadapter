include <dimensions.scad>;
use <bottom_bracket.scad>;

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
/*rotate([0, 90, 0])
translate([-hd_enclosure_depth, 0, 0])
translate([0, 0, -track_height])
seal();
*/
