/* bg_2d.scad
 * ==========
 * 2D cutlist for a backgammon board.
 * Absolutely no attempt to render 3D for this file.
 * This is to output a DXF for lasercutting the parts only!
 */

include <bg_config.scad>
include <bg_debug.scad>
include <bg_fingers.scad>

//dump_config();

// part_space : the space between parts on the 2D layout.
part_space = 2;

/*
  hinge_side_a()

  no parameters

  Creates a single side for the box along the "hinge side".
  Interfaces to the hinge along one long edge (no plans to use a living hinge
  for this), to the base along the other long edge and to the "points sides"
  on the remaining two (short) sides.
*/

module hinge_side_a()
{
        difference()
        {
                // the side itself
                square([side_height,
                        hinge_side_length]);

                // joint the sides together...
                fingers_x(side_height,       // length
                          hinge2point_mark,  // tab_sz
                          hinge2point_space, // space
                          0,                 // offset
                          frame_thick,       // thick
                          true);             // type

                // ...on both sides
                translate([0,
                           hinge_side_length - frame_thick,
                           0])
                {
                        fingers_x(side_height,       // length
                                  hinge2point_mark,  // tab_sz
                                  hinge2point_space, // space
                                  0,                 // offset
                                  frame_thick,       // thick
                                  true);             // type
                }
                
                // and the holes for the base
                translate([side_height - base_gap - base_thick,
                           0,
                           0])
                {
                        fingers_y(hinge_side_length, // length
                                  base2hinge_mark,   // tab_sz
                                  base2hinge_space,  // space
                                  frame_thick,       // offset
                                  base_thick,        // thick
                                  true);             // type
                }

        }
};

module hinge_side_b()
{
        difference()
        {
                translate([side_height,
                           0,
                           0])
                rotate([0,180,0])
                {
                        hinge_side_a();
                }

                translate([base_thick + base_gap,
                           ((counter_thick + counter_gap)
                            * counters_per_player
                            + counter_gap),
                           0])
                {
                        fingers_x(side_height
                                  - base_gap
                                  - base_thick,      // length
                                  hinge2point_mark,  // tab_sz
                                  hinge2point_space, // space
                                  0,                 // offset
                                  frame_thick,       // thick
                                  true);             // type

                }

                translate([base_thick + base_gap,
                           hinge_side_length
                           - ((counter_thick + counter_gap)
                              * counters_per_player
                              + counter_gap),
                           0])
                {
                        fingers_x(side_height
                                  - base_gap
                                  - base_thick,      // length
                                  hinge2point_mark,  // tab_sz
                                  hinge2point_space, // space
                                  0,                 // offset
                                  frame_thick,       // thick
                                  true);             // type

                }
        }
}

module point_side_a()
{
        difference()
        {
                square([point_side_length,
                        side_height]);

                translate([0,
                           base_gap,
                           0])
                {
                        fingers_x(point_side_length, // length
                                  base2point_mark,   // tab_sz
                                  base2point_space,  // space
                                  frame_thick,       // offset
                                  base_thick,        // thick
                                  true);             // type
                }

                translate([0,0,0])
                {
                        fingers_y(side_height,       // length
                                  hinge2point_mark,  // tab_sz
                                  hinge2point_space, // space
                                  0,                 // offset
                                  frame_thick,       // thick
                                  false);            // type
                }

                translate([point_side_length - frame_thick,
                           0,
                           0])
                {
                        fingers_y(side_height,       // length
                                  hinge2point_mark,  // tab_sz
                                  hinge2point_space, // space
                                  0,                 // offset
                                  frame_thick,       // thick
                                  false);            // type
                }

                translate([frame_thick + quadrant_width,
                           base_gap + base_thick,
                           0])
                {
                        fingers_y(side_height
                                  - base_gap
                                  - base_thick,      // length
                                  hinge2point_mark,  // tab_sz
                                  hinge2point_space, // space
                                  0,                 // offset
                                  frame_thick,       // thick
                                  true);             // type
                }
        }
}

module point_side_b()
{
        translate([0,side_height,0])
        rotate([180,0,0])
        {
                point_side_a();
        }
}

module counter_divider()
{
        difference()
        {
                square([side_height - base_gap,
                        hinge_side_length]);

                translate([base_gap + base_thick,
                           0,
                           0])
                {
                        fingers_x(side_height
                                  - base_gap
                                  - base_thick,      // length
                                  hinge2point_mark,  // tab_sz
                                  hinge2point_space, // space
                                  0,                 // offset
                                  frame_thick,       // thick
                                  false);            // type

                        translate([-(base_gap+base_thick),
                                   0,
                                   0])
                        square([base_gap + base_thick,
                                frame_thick]);

                }
                
                translate([base_gap + base_thick,
                           hinge_side_length - frame_thick,
                           0])
                {
                        fingers_x(side_height
                                  - base_gap
                                  - base_thick,      // length
                                  hinge2point_mark,  // tab_sz
                                  hinge2point_space, // space
                                  0,                 // offset
                                  frame_thick,       // thick
                                  false);            // type

                        translate([-(base_gap+base_thick),
                                   0,
                                   0])
                        square([base_gap + base_thick,
                                frame_thick]);

                }
                
                translate([0,0,0])
                {
                        fingers_y(hinge_side_length, // length
                                  base2hinge_mark,   // tab_sz
                                  base2hinge_space,  // space
                                  frame_thick,       // offset
                                  frame_thick,       // thick
                                  false);            // type

                }

                translate([base_thick,
                           ((counter_thick + counter_gap)
                            * counters_per_player
                            + counter_gap),
                           0])
                {
                        fingers_x(side_height
                                  - base_gap
                                  - base_thick,      // length
                                  hinge2point_mark,  // tab_sz
                                  hinge2point_space, // space
                                  0,                 // offset
                                  frame_thick,       // thick
                                  true);             // type

                }

                translate([base_thick,
                           hinge_side_length
                           - ((counter_thick + counter_gap)
                              * counters_per_player
                              + counter_gap),
                           0])
                {
                        fingers_x(side_height
                                  - base_gap
                                  - base_thick,      // length
                                  hinge2point_mark,  // tab_sz
                                  hinge2point_space, // space
                                  0,                 // offset
                                  frame_thick,       // thick
                                  true);             // type

                }

        }
}

module base()
{
        difference()
        {
                square([point_side_length,
                        hinge_side_length]);

                translate([0,0,0])
                {
                        fingers_x(point_side_length, // length
                                  base2point_mark,   // tab_sz
                                  base2point_space,  // space
                                  frame_thick,       // offset
                                  frame_thick,       // thick
                                  false);            // type

                }

                translate([0,
                           hinge_side_length - frame_thick,
                           0])
                {
                        fingers_x(point_side_length, // length
                                  base2point_mark,   // tab_sz
                                  base2point_space,  // space
                                  frame_thick,       // offset
                                  frame_thick,       // thick
                                  false);            // type

                }

                translate([0,0,0])
                {
                        fingers_y(hinge_side_length, // length
                                  base2hinge_mark,   // tab_sz
                                  base2hinge_space,  // space
                                  frame_thick,       // offset
                                  base_thick,        // thick
                                  false);            // type

                }

                translate([point_side_length - frame_thick,
                           0,
                           0])
                {
                        fingers_y(hinge_side_length, // length
                                  base2hinge_mark,   // tab_sz
                                  base2hinge_space,  // space
                                  frame_thick,       // offset
                                  frame_thick,       // thick
                                  false);            // type

                }

                translate([quadrant_width + frame_thick,
                           0,
                           0])
                {
                        fingers_y(hinge_side_length, // length
                                  base2hinge_mark,   // tab_sz
                                  base2hinge_space,  // space
                                  frame_thick,       // offset
                                  frame_thick,       // thick
                                  true);             // type

                }

                translate([frame_thick + quadrant_width,
                           ((counter_thick + counter_gap)
                            * counters_per_player
                            + counter_gap),
                           0])
                {
                        fingers_x(point_side_length
                                  - quadrant_width
                                  - frame_thick,     // length
                                  hinge2point_mark,  // tab_sz
                                  hinge2point_space, // space
                                  frame_thick,       // offset
                                  frame_thick,       // thick
                                  true);             // type

                }

                translate([frame_thick + quadrant_width,
                           hinge_side_length
                           - ((counter_thick + counter_gap)
                              * counters_per_player
                              + counter_gap),
                           0])
                {
                        fingers_x(point_side_length
                                  - quadrant_width
                                  - frame_thick,     // length
                                  hinge2point_mark,  // tab_sz
                                  hinge2point_space, // space
                                  frame_thick,       // offset
                                  frame_thick,       // thick
                                  true);             // type

                }

        }
}

module point_a()
{
        polygon(points=[[0,0],
                        [point_width,0],
                        [point_width / 2, point_height]
                       ], paths=[[0,1,2]]);
}

module point_b()
{
        translate([point_width,
                   point_height,
                   0])
        {
                rotate([0,0,180])
                {
                        point_a();
                }
        }
}

module pointset(type)
{
        // assumes points_per_quadrant is even.
        // not sure how gameplay would work with odd points per quadrant.

        translate([(eff_point_width - point_width)
                   + frame_thick + counter_gap,
                   counter_gap,0]) // compensate for initial point offset

        for (point_lp = [0 : (points_per_quadrant - 1)])
        {
                translate([(point_lp * (eff_point_width)),
                           frame_thick,0])
                {
                        if (is_even(point_lp) == type)
                        {
                                translate([0,
                                           hinge_side_length
                                           - point_height
                                           - (frame_thick * 2)
                                           - (counter_gap * 2),
                                           0])
                                {
                                        point_b();
                                }
                        }
                        else
                        {
                                point_a();
                        }
                }
        }
}

module base_with_points()
{
        difference()
        {
                base();
        
                color("red")
                pointset(true);

                color("green")
                pointset(false);
        }
}

module counter_stop_a()
{
        difference()
        {
                square([point_side_length
                        - quadrant_width
                        - frame_thick,
                        side_height
                        - base_gap]);

                translate([0,
                           0,
                           0])
                {
                        fingers_y(side_height
                                  - base_gap
                                  - base_thick,      // length
                                  hinge2point_mark,  // tab_sz
                                  hinge2point_space, // space
                                  0,                 // offset
                                  frame_thick,       // thick
                                  false);            // type
                }

                translate([point_side_length
                           - quadrant_width
                           - frame_thick
                           - frame_thick,
                           0,
                           0])
                {
                        fingers_y(side_height
                                  - base_gap
                                  - base_thick,      // length
                                  hinge2point_mark,  // tab_sz
                                  hinge2point_space, // space
                                  0,                 // offset
                                  frame_thick,       // thick
                                  false);            // type
                }

                translate([0,
                           side_height - base_gap - base_thick,
                           0])
                {
                        fingers_x(point_side_length
                                  - quadrant_width
                                  - frame_thick,     // length
                                  hinge2point_mark,  // tab_sz
                                  hinge2point_space, // space
                                  frame_thick,       // offset
                                  frame_thick,       // thick
                                  false);            // type

                }

                translate([((point_side_length
                             - quadrant_width
                             - frame_thick) /2),
                           -((point_side_length
                                     - quadrant_width
                                     - frame_thick
                                     - (frame_thick *2)) /4),
                           0])
                {

                        circle(r = ((point_side_length
                                     - quadrant_width
                                     - frame_thick
                                     - (frame_thick *2)) /2),
                               $fn=50);
                }

                
        }
}

module counter_stop_b()
{
        translate([point_side_length
                   - quadrant_width
                   - frame_thick,
                   side_height
                   - base_gap,
                   0])
        rotate([0,0,180])
        {
                counter_stop_a();
        }

}

module halfbox()
{

        translate([side_height + part_space,
                   hinge_side_length + part_space + side_height + part_space,
                   0])
        {
                point_side_a();
        }

        translate([side_height + part_space,
                   0,
                   0])
        {
                point_side_b();
        }

        translate([0,
                   side_height + part_space,
                   0])
        {
                hinge_side_a();
        }

        translate([side_height + part_space + point_side_length + part_space,
                   side_height + part_space,
                   0])
        {
                hinge_side_b();
        }

        translate([side_height + part_space,
                   side_height + part_space,
                   0])
        {
                base_with_points();
        }

        translate([(side_height + part_space) * 2
                   + point_side_length + part_space,
                   side_height + part_space,
                   0])
        {
                counter_divider();
        }

        translate([side_height + part_space + point_side_length + part_space,
                   0,
                   0])
        {
                counter_stop_a();
        }

        translate([side_height + part_space + point_side_length + part_space,
                   side_height + part_space + hinge_side_length + part_space,
                   0])
        {
                counter_stop_b();
        }


};


/*
  bg_2d()

  no parameters

  Entry point for the 2D file.
*/
module bg_2d()
{

        halfbox();
/*

        counter_stop_b();
*/
}

// do it!
bg_2d();

