/* bg_config.scad
 * ==============
 * Configuration file for Backgammon.
 * Provides all the configurable parameters for the backgammon model.
 */

	// Note: All sizes in mm unless otherwise specified.

	// MATERIAL DEFINITIONS
	// --------------------

	// counter_dia : counter diameter
	counter_dia = 40;  

	// counter_thick : counter thickness
	counter_thick = 5;

	// die_size : size of one side of a die
	die_size = 10;

	// doubl_size : size of one side of doubling cube
	doubl_size = 30;

	// counter_gap : gap between counters
	counter_gap = 1;

	// point_spacing : gap between points facing each other
	point_spacing = 2 * (counter_dia + counter_gap);

	// frame_thick : thickness of material used for frame
	frame_thick = 5;

	// base_thick : thickness of material used for base
	base_thick = 5;

	// felt_thick : thickness of felt on top of base
	felt_thick = 1.2;

	// base_gap : gap below base to hold base into sides
	base_gap = 5;	

	// num_fingers : how many fingers to make the box joints from
	num_fingers = 9;

	// GAMEPLAY DEFINITIONS
	// --------------------

	// counters_per_player : number of counters for each player
	counters_per_player = (15 * 2);

	// points_per_quadrant : points in each quadrant
	points_per_quadrant = 6;

	// counters_per_point : height of point in counters (can be fractional)
	counters_per_point = 5;

	// DERIVED SIZES
	// -------------

	// point_width : width of each point (fabric)
	point_width = counter_dia - counter_gap;

	// eff_point_width : effective width of each point (for dimensions)
	eff_point_width = counter_dia + counter_gap;

	// point_height : height of each point (fabric)
	point_height = counters_per_point * (counter_dia + counter_gap);

	// eff_point_height : effective height of each point (for dimensions)
	eff_point_height = counters_per_point * (counter_dia + counter_gap);

	// quadrant_width : width of the quadrant
	quadrant_width = points_per_quadrant * eff_point_width
                         + (2 * counter_gap);

	// side_height : width of the frame side pieces
	side_height = base_gap 
                + base_thick 
                + felt_thick 
                + (counter_dia / 2) 
                + counter_gap;

	// hinge_side_length : length of frame side pieces parallel to hinge
	hinge_side_length = ( (1 * frame_thick) + eff_point_height ) * 2
                      + point_spacing;

	// point_side_length : length of frame side pieces perpendicular to 
	//                     hinge
	point_side_length = (1 * frame_thick)
                      + quadrant_width 
                      + (1 * frame_thick)
                      + counter_dia
                      + counter_gap
                      + (1 * frame_thick);

        // mark-space sizes for the finger joints
        // note: pins (type = false) on base and points sides.
        base2hinge_mark   = (base_thick  * 3.0);
        base2hinge_space  = (base_thick  * 1.0);
        base2point_mark   = (base_thick  * 3.0);
        base2point_space  = (base_thick  * 1.0);
        hinge2point_mark  = (frame_thick * 0.5);
        hinge2point_space = (frame_thick * 0.5);


// note this currently assumes the points (i.e. counters lying flat) are bigger
// than the storage area (i.e. counters upright). If the ratio of counter 
// diameter to counter thickness is too low, or other non-standard dimensions
// are used (e.g. for the dice) the storage area may be larger and the code 
// should handle this by calculating the size of the storage area and the size
// of the playing field and choosing the larger to determine the box size.
