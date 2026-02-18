
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
depth = 11;

// the depth of the latch plate
latch_plate_depth = 3.25;

// the width of the enclosure for the human door side
hd_enclosure_width = 45;

// the depth of the enclosure for the human door side
hd_enclosure_depth = 10 * 2.5 + latch_plate_depth;

// the width of the indoor overhang
overhang_indoor_width = 6;

// the width of the outdoor overhang
overhang_outdoor_width = 6;

// the total height
total_height = 50; // 290

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

// pins
pin_diameter = 5;
pin_length = 5;
