event_inherited();

#region Variables
dir = 0;
spd = 2.5;

hsp = 0;
vsp = 0;

max_dist = 200;
destroy = false;

// Configure whether bullet gets destroyed upon impact or continues traveling
destroy_upon_impact = true;

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
	// Hit confirm destroy
	if (hit_confirm == true and destroy_upon_impact == true) destroy = true;
	
	// Actually destroy bullet
	if (destroy == true) instance_destroy();
	
	// Destroy bullet upon hitting "Tiles_C"
	if place_meeting(x, y, collision_layer) 
	{
		destroy = true;
		audio_play_sound(snd_bullet_destroy, 0, 0, 1, 0, random_range(0.9, 1))
	}
	
	// Destroy bullet upon traveling too far
	if (point_distance(xstart, ystart, x, y) > max_dist) destroy = true;
}