include <dimensions.scad>;
use <bottom_bracket.scad>;

total_length = adjust_length_error(277);

module trapezoid_seal_ramp(l=seal_depth+seal_floor_offset) {
  x0 = 0;
  x1 = seal_floor_offset;
  x2 = (seal_depth + seal_floor_offset);

  y0 = -seal_small_width / 2;
  y1 = seal_small_width / 2;
  y2 = -seal_large_width / 2;
  y3 = seal_large_width / 2;
  y4 = -hd_enclosure_width / 2;
  y5 = hd_enclosure_width / 2;

  z0 = 0;
  z1 = (l - seal_depth);
  z2 = l;

  polyhedron(points=[[x0, y4, z0],
                     [x0, y5, z0],
                     [x1, y5, z0],
                     [x1, y3, z0],
                     [x2, y1, z0],
                     [x2, y0, z0],
                     [x1, y2, z0],
                     [x1, y4, z0],
                     [x0, y4, z1],
                     [x0, y2, z1],
                     [x0, y0, z2],
                     [x0, y1, z2],
                     [x0, y3, z1],
                     [x0, y5, z1]],
             faces=[
                    [0, 7, 8], // left side
                    [8, 7, 6, 9], // top (left)
                    [9, 6, 5, 10],
                    [10, 5, 4, 11],
                    [11, 4, 3, 12],
                    [12, 3, 2, 13], // top (right)
                    [13, 2, 1], // right side,
                    [0, 1, 2, 3, 4, 5, 6, 7], // back
                    [0, 8, 9, 10, 11, 12, 13, 1] // bottom
                    ]);
}

difference() {
  rotate([0, 90, 0])
    main_body(h=total_length);
  union() {
    translate([total_length, 0, 0])
      rotate([0, 90, 0])
      joiner_pins_female();
    translate([total_length - latch_plate_over_extension - setback,
               -seal_large_width/2,
               seal_floor_offset - latch_plate_over_depth])
    cube([latch_plate_over_extension + setback,
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

setback = 12;

translate([total_length - latch_plate_over_extension - setback,
           0, 0])
trapezoid_seal_ramp();
