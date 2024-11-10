event_inherited();

#region Variables
dir = 0;
spd = 2.5;

hsp = 0;
vsp = 0;

max_dist = 200;
destroy = false;

collision_layer = layer_tilemap_get_id("Tiles_C");
#endregion

// Moves the bullet in direction dir
function move()
{
	hsp = lengthdir_x(spd, dir);
	vsp = lengthdir_y(spd, dir);
	
	x += hsp;
	y += vsp;
}

// Destroy bullets that have served their purpose
function cleanup()
{
	// Destroy bullet upon hitting "tiles_collision"
	if place_meeting(x, y, collision_layer) destroy = true;
	
	// Destroy bullet upon traveling too far
	if (point_distance(xstart, ystart, x, y) > max_dist) destroy = true;
	
	// Actually destroy bullet
	if (destroy == true) instance_destroy();
}