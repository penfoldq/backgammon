/* bg_debug.scad
 * =============
 * Debugging routines for Backgammon.
 * Keeps debug code out of view to keep code cleaner.
 */

//include <bg_config.scad>

module dump_config() 
{
	echo(str("counter_dia"),counter_dia);  
	echo(str("counter_thick"),counter_thick);
	echo(str("die_size"),die_size);
	echo(str("doubl_size"),doubl_size);
	echo(str("counter_gap"),counter_gap);
	echo(str("point_spacing"),point_spacing);
	echo(str("frame_thick"),frame_thick);
	echo(str("base_thick"),base_thick);
	echo(str("felt_thick"),felt_thick);
	echo(str("base_gap"),base_gap);
	echo(str("num_fingers"),num_fingers);
	echo(str("counters_per_player"),counters_per_player);
	echo(str("points_per_quadrant"),points_per_quadrant);
	echo(str("counters_per_point"),counters_per_point);
	echo(str("point_width"),point_width);
	echo(str("eff_point_width"),eff_point_width);
	echo(str("point_height"),point_height);
	echo(str("eff_point_height"),eff_point_height);
	echo(str("quadrant_width"),quadrant_width);
	echo(str("side_height"),side_height);
	echo(str("hinge_side_length"),hinge_side_length);
	echo(str("point_side_length"),point_side_length);
};

//dump_config();