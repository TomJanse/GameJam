event_inherited();

#region // Variables
dir = -1
end_x = 0
end_y = 0
laser_max_length = infinity
collision_tiles = layer_tilemap_get_id("Tiles_C")
length = 0
#endregion

function set_length() {
	for(var _i = 0; _i < laser_max_length; _i++) {
	end_x = x + lengthdir_x(_i, dir)
	end_y = y + lengthdir_y(_i, dir)

	if(collision_point(end_x, end_y, collision_tiles, false, true) != noone) {
		break;	
	}
}

	length = point_distance(x, y, end_x, end_y)	
}

function cleanup() {
	if(image_index >= image_number - 1) instance_destroy()	
}