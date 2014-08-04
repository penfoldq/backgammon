/* bg_fingers.scad
 * ===============
 * Routines to generate "finger joints".
 * And lots of helper functions for this process.
 *
 * Primary routines in this file are:
 * => fingers_x
 * => fingers_y
 */


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

// num_ms_fingers : how many fingers can we fit if we specify the tab_sz and
//                  the spacing between the tabs (interior) and the offset
//                  (minimum exterior gap for not running into holes on an
//                  adjacent side that has tabs)
//                  NOTE : ODD NOT NECESSARY here because we force the extra
//                  tab_sz into the offset calculation
function num_ms_fingers(length,tab_sz,space,offset)
         = floor((length - (2*offset) - tab_sz)/(tab_sz+space));

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

// part_ms_finger : what's the actual offset on each side?
function part_ms_finger(length,tab_sz,space,offset)
         = ( length -
             ( ( num_ms_fingers(length,tab_sz,space,offset)
                 * (tab_sz + space) )
               + tab_sz ) ) / 2; 

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
  space  - gap between tabs
  offset - extra space top and bottom
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
module fingers_x(length, tab_sz, space, offset, thick, type)
{
        if (!finger_type(type))
        {
                /* first the pin at the start */
                translate([0,0,0])
                color(marker_color_pin(type))
                square([part_ms_finger(length,tab_sz,space,offset),
                        thick]);
        }
        
        /* now the tabs */
        translate([part_ms_finger(length,tab_sz,space,offset),
                   0,0])
        for (finger_lp
             = [1 : num_ms_fingers(length,tab_sz,space,offset)])
        {
                translate([((finger_lp-1) * (tab_sz + space)),
                           0,0])
                {
                        if (finger_type(type))
                        {
                                color(marker_color_tab(!type))
                                square([tab_sz,thick]);
                        }
                        else
                        {
                                translate([tab_sz,0,0])
                                color(marker_color_tab(type))
                                square([space,thick]);
                        }
                }
        }

        if (finger_type(type))
        {
                /* now the odd tab */
                translate([( (num_ms_fingers(length,tab_sz,space,offset))
                             * (tab_sz+space) )
                           + (part_ms_finger(length,tab_sz,space,offset)),
                           0,0])
                {
                                color(marker_color_tab(!type))
                                square([tab_sz,thick]);
                }
        }
        else
        {
                
                /* and finally the pin at the end */
                translate([( ( (num_ms_fingers(length,tab_sz,space,offset))
                               * (tab_sz+space) )
                             + (part_ms_finger(length,tab_sz,space,offset))
                             + (tab_sz) ),
                           0,0])
                {
                        color(marker_color_pin(type))
                        square([part_ms_finger(length,tab_sz,space,offset),
                                thick]);
                }

        }
}

/*
  fingers_y()

  length - the length of the entire joint
  tab_sz - how big is each tab
  space  - gap between tabs
  offset - extra space top and bottom
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
module fingers_y(length, tab_sz, space, offset, thick, type)
{
        translate([thick,0,0])
        rotate([0,0,90])
        fingers_x(length, tab_sz, space, offset, thick, type);
}


