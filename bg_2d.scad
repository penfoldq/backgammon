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



/*

|                             | <- type = 0 (false)
+----+   +---+   +---+   +----+ /\
|    |   |   |   |   |   |    |  "thick"
|    +---+   +---+   +---+    | \/
|                             | <- type = 1 (true)

|                        | <- type = 0 (false)
+----+   +---+   +---+   + /\
|    |   |   |   |   |   |  "thick"
|    +---+   +---+   +---+ \/
|                        | <- type = 1 (true)

< a  >   < c >   < e >   < g  >
     < b >   < d >   < f >

<        "length"             >

a == g == "part_finger()"
b == c == d == e == f == "tab_sz"

for the above example:
    length = 31
    num_fingers = 7
    part_finger = 1.5
    tab_sz = 4


// how many times does "tab_sz" fit into "len"
function num_fingers(len,tab_sz) = floor(len/tab_sz);

// what's the remainder on each side?
function part_finger(len,tab_sz) = (len-(tab_sz*num_fingers))/2;

// start with type 1
translate([part_finger(len,tab_sz),0,0])
for i = 1 to num_fingers(len,tab_sz)
    if is_even(i)
       translate([i*tab_sz,0,0])
       square([tab_sz,thick]);

// now type 0
translate([part_finger(len,tab_sz),0,0])
for i = 1 to num_fingers(len,tab_sz)
    if !is_even(i)
       translate([i*tab_sz,0,0])
       square([tab_sz,thick]);


// extras for type 0
square([tab_sz+part_finger(len,tab_sz),thick]);
translate([tab_sz*(num_fingers(len,tab_sz)-1)
           +part_finger(len,tab_sz),0,0])
square([tab_sz+part_finger(len,tab_sz),thick]);


*/




// is_even : true if val is even
//           false if val is odd
function is_even(val) = ((val % 2) == 0);

// is_odd : true if val is odd
//          false if val is even
function is_odd(val) = !is_even(val);

// finger_type : true  = outside remains     (1)
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
//                    "num_fingers()" of "tab_sz"?
function finger_remainder(length,tab_sz)
         = (length - ( tab_sz * ( num_odd_fingers(length,tab_sz) ) ) );

// part_finger : what's the remainder on each side?
function part_finger(length,tab_sz) 
         = finger_remainder(length,tab_sz)/2;

module fingers_x(length, tab_sz, thick, type)
{

echo(str("length"),length);
echo(str("tab_sz"),tab_sz);
echo(str("thick"),thick);
echo(str("num_fingers"),num_fingers(length,tab_sz));
echo(str("num_odd_fingers"),num_odd_fingers(length,tab_sz));
echo(str("type"),type);
echo(str("finger_type"),finger_type(type),
        finger_type(type) ? str("pin") : str("shoulder"));
echo(str("part_finger"),part_finger(length,tab_sz,type));


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
        
        // extra cutouts for type 0
        if (!finger_type(type))
        {
                color("blue")
                square([part_finger(length,tab_sz),thick]);
        
                translate([(tab_sz*(num_odd_fingers(length,tab_sz))
                            +part_finger(length,tab_sz)),0,0])
                {
                        color("yellow")
                        square([part_finger(length,tab_sz),thick]);        
                }
        }

}; // end module fingers_x()

function marker_color_tab(type) = (type) ? "white"     : "red";
function marker_color_pin(type) = (type) ? "lightgray" : "red";

module finger_markers_x(length, tab_sz, thick, type)
{

        /* small markers to see the calculated positions */

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
                color(marker_color_tab(is_even(finger_lp) ? type : !type))
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

module fingers_y(length, tab_sz, thick, type)
{
        translate([thick,0,0])
        rotate([0,0,90])
        fingers_x(length, tab_sz, thick, type);
};

module finger_markers_y(length, tab_sz, thick, type)
{
        translate([-thick*3,0,0])
        rotate([0,0,90])
        finger_markers_x(length, tab_sz, thick, type);
};


module hinge_side()
{
//        difference()
        {
                square([side_height,
                        hinge_side_length]);

                fingers_x(side_height,
                          (frame_thick*2),
                          frame_thick,
                          true);

                fingers_y(hinge_side_length,
                          (frame_thick*2),
                          frame_thick,
                          true);


                finger_markers_x(side_height,
                                 (frame_thick*2),
                                 1,
                                 true);

                finger_markers_y(hinge_side_length,
                                 (frame_thick*2),
                                 1,
                                 true);
        }
};

module bg_2d()
{
        // just do a single hinge_side while I get it right.
        hinge_side();
};


// do it!
bg_2d();

