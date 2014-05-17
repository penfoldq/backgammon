/* bg_2d.scad
 * ==========
 * 2D cutlist for a backgammon board.
 * Absolutely no attempt to render 3D for this file.
 * This is to output a DXF for lasercutting the parts only!
 */

include <bg_config.scad>
include <bg_debug.scad>

//dump_config();

// part_space : the space between parts on the 2D layout.
part_space = 10;



// is_even : true if val is even
//           false if val is odd
function is_even(val) = ((val % 2) == 0);

// is_odd : true if val is odd
//          false if val is even
function is_odd(val) = !is_even(val);

// finger_type : for boards to mesh, need to be one of each type
//               true  = outside remains     (1)
//               false = outside is shoulder (0)
function finger_type(type) = (type == true) ? 1 : 0;

// num_fingers : how many times does "tab_sz" fit into "length"?
function num_fingers(length,tab_sz) = floor(length/tab_sz);

// num_odd_fingers : force num_fingers() to be odd to distribute
//                   the tabs uniformly
function num_odd_fingers(length,tab_sz)
         = is_even(num_fingers(length,tab_sz))
           ? num_fingers(length,tab_sz) - 1
           : num_fingers(length,tab_sz) ;

// finger_remainder : what's left of "length" after we have discounted
//                    "num_odd_fingers()" of "tab_sz"?
function finger_remainder(length,tab_sz)
         = (length - ( tab_sz * ( num_odd_fingers(length,tab_sz) ) ) );

// part_finger : what's the remainder on each side?
function part_finger(length,tab_sz) 
         = finger_remainder(length,tab_sz)/2;

// marker_color_tab : what color to use for tabs based on the finger_type?
//                    true  = color for remaining material
//                    false = color for material to remove
function marker_color_tab(type) = (finger_type(type)) ? "white"     : "red";

// marker_color_pin : what color to use for pins based on the finger_type?
//                    true  = color for remaining material
//                    false = color for material to remove
function marker_color_pin(type) = (finger_type(type)) ? "lightgray" : "red";



/*
  fingers_x()

  length - the length of the entire joint
  tab_sz - how big is each tab
  thick  - how deep to cut each tab
           (the thickness of the other piece in the joint)
  type   - 'true'  the outside is a shoulder
           'false' the outside is a pin

  Generates objects in the positions of the material to be removed from an
  object to create finger joints. This should then be differenced away from
  the original object to create the correct outline.

  Different thicknesses of materials can be jointed with this module. The
  "thick" parameter is the thickness of the other material in the joint, not
  necessarily this piece. This module does not need to be placed at an edge
  of the piece, interior dividers will work just as well. 

  This is the x-axis version, all the logic for the creation of the markers is
  here. This is then rotated and moved for the other axis versions. 
*/
module fingers_x(length, tab_sz, thick, type)
{
        translate([part_finger(length,tab_sz),0,0])
        {
                for (finger_lp = [is_even(num_fingers(length,tab_sz)) ? 0 : 1
                                  : num_odd_fingers(length,tab_sz) ])
                {
                        if ( finger_type(type) 
                             ? !is_even(finger_lp) 
                             : is_even(finger_lp) )
                        {
                                translate([((finger_lp-1) * tab_sz),0,0])
                                {
                                        color("red")
                                        square([tab_sz,thick]);
                                }
                        }
                }
        }
        
        // extra cutouts for type 0 - shoulders on outside
        if (!finger_type(type))
        {
                color("blue")
                square([part_finger(length,tab_sz),thick]);
        
                translate([(tab_sz*(num_odd_fingers(length,tab_sz))
                            +part_finger(length,tab_sz)),0,0])
                {
                        color("blue")
                        square([part_finger(length,tab_sz),thick]);        
                }
        }

}; // end module fingers_x()


/*
  finger_markers_x()

  length - the length of the entire joint
  tab_sz - how big is each tab
  thick  - how deep to cut each tab
           (the thickness of the other piece in the joint)
  type   - 'true'  the outside is a shoulder
           'false' the outside is a pin

  Generates informational markers to show the calculations of the placement
  of the cutouts to make the pins and holes for finger joints. These are
  shifted a small distance from the piece for enhanced clarity.

  This is the x-axis version, all the logic for the creation of the markers is
  here. This is then rotated and moved for the other axis versions. The logic
  here is mostly a duplication of the fingers_x() logic but it is deliberately
  repeated because the differences make it easier to show the intention. 

  NOTE: This is NOT intended to form part of the final design, this is for
  informational/debug purposes only.
*/
module finger_markers_x(length, tab_sz, thick, type)
{

        /* small markers to see the calculated positions */

        /* move everything off from the part to make it easier to see */
        translate([0,-thick*2,0])
        {
       
                /* first the pin at the start */
                translate([0,0,0])
                color(marker_color_pin(type))
                square([part_finger(length,tab_sz),thick]);

                /* now the tabs */
                translate([part_finger(length,tab_sz),0,0])
                for (finger_lp = [is_even(num_fingers(length,tab_sz)) ? 0 : 1
                                  : num_odd_fingers(length,tab_sz) ])
                {
                        translate([((finger_lp-1) * tab_sz),0,0])
                        color(marker_color_tab(is_even(finger_lp)
                              ? type : !type))
                        square([tab_sz,thick]);
                }

                /* and finally the pin at the end */
                translate([(tab_sz*(num_odd_fingers(length,tab_sz))
                           +part_finger(length,tab_sz)),
                           0,0])
                {
                        color(marker_color_pin(type))
                        square([part_finger(length,tab_sz),thick]);
                }

        } // end translate to move markers away from object

}; // end module finger_markers_x()

/*
  fingers_y()

  length - the length of the entire joint
  tab_sz - how big is each tab
  thick  - how deep to cut each tab
           (the thickness of the other piece in the joint)
  type   - 'true'  the outside is a shoulder
           'false' the outside is a pin

  Generates objects in the positions of the material to be removed from an
  object to create finger joints. This should then be differenced away from
  the original object to create the correct outline.

  Different thicknesses of materials can be jointed with this module. The
  "thick" parameter is the thickness of the other material in the joint, not
  necessarily this piece. This module does not need to be placed at an edge
  of the piece, interior dividers will work just as well. 

  This is the y-axis version, produced by rotating and moving the x-axis
  version.
*/
module fingers_y(length, tab_sz, thick, type)
{
        translate([thick,0,0])
        rotate([0,0,90])
        fingers_x(length, tab_sz, thick, type);
};

/*
  finger_markers_y()

  length - the length of the entire joint
  tab_sz - how big is each tab
  thick  - how deep to cut each tab
           (the thickness of the other piece in the joint)
  type   - 'true'  the outside is a shoulder
           'false' the outside is a pin

  Generates informational markers to show the calculations of the placement
  of the cutouts to make the pins and holes for finger joints. These are
  shifted a small distance from the piece for enhanced clarity.

  This is the y-axis version, produced by rotating and moving the x-axis
  version.

  NOTE: This is NOT intended to form part of the final design, this is for
  informational/debug purposes only.
*/
module finger_markers_y(length, tab_sz, thick, type)
{
        translate([-thick*3,0,0])
        rotate([0,0,90])
        finger_markers_x(length, tab_sz, thick, type);
};


/*
  hinge_side()

  no parameters

  Creates a single side for the box along the "hinge side".
  Interfaces to the hinge along one long edge (no plans to use a living hinge
  for this), to the base along the other long edge and to the "points sides"
  on the remaining two (short) sides.
*/
module hinge_side()
{
        difference()
        {
                square([side_height,
                        hinge_side_length]);

                fingers_x(side_height,
                          (frame_thick*0.5),
                          frame_thick,
                          true);

                fingers_y(hinge_side_length,
                          (frame_thick*2),
                          frame_thick,
                          true);

        }
        
                finger_markers_x(side_height,
                                 (frame_thick*2),
                                 1,
                                 true);

                finger_markers_y(hinge_side_length,
                                 (frame_thick*2),
                                 1,
                                 true);

};

/*
  bg_2d()

  no parameters

  Entry point for the 2D file.
*/
module bg_2d()
{
        // just do a single hinge_side while I get it right.
        hinge_side();
};


// do it!
bg_2d();

