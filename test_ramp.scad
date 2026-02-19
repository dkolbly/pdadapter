include <dimensions.scad>

module full_seal3(l=20, falloff=false) {
  x0 = 0;
  x1 = -seal_floor_offset;
  x2 = -(seal_depth + seal_floor_offset);

  y0 = -seal_small_width / 2;
  y1 = seal_small_width / 2;
  y2 = -seal_large_width / 2;
  y3 = seal_large_width / 2;
  y4 = -hd_enclosure_width / 2;
  y5 = hd_enclosure_width / 2;

  z0 = 0;
  z1 = l - seal_depth;
  z2 = l;

  function zofx(x) = falloff ? 0 : z1;
  function xend(x) = falloff ? 1 : x;
  
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

module full_seal(l=20, falloff=false) {
  x0 = 0;
  x1 = -seal_floor_offset;
  x2 = -(seal_depth + seal_floor_offset);

  y0 = -seal_small_width / 2;
  y1 = seal_small_width / 2;
  y2 = -seal_large_width / 2;
  y3 = seal_large_width / 2;
  y4 = -hd_enclosure_width / 2;
  y5 = hd_enclosure_width / 2;

  module poly() {
    polygon(points=[[x0, y4],
                    [x1, y4],
                    [x1, y2],
                    [x2, y0],
                    [x2, y1],
                    [x1, y3],
                    [x1, y5],
                    [x0, y5]]);
  }

  linear_extrude(height=l) poly();
}

full_seal3(l=10, falloff=true);

