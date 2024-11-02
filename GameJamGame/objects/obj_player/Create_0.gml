// Move to camera object when making camera
fullscreen();

#region Variables
move_speed = 2;

hsp = 0;
vsp = 0;

collision_layer = layer_tilemap_get_id("tiles_collision");
#endregion

// Handles sprite when idle
function idle()
{
	if (hsp == 0 and vsp == 0) sprite_index = spr_player;
}

// Handles horizontal and vertical movement and collision with tilemap layer "tiles_collision"
function move()
{
	// Horizontal speed
	hsp = keyboard_check(ord("D")) - keyboard_check(ord("A"));
	hsp *= move_speed;
	
	// Vertical speed
	vsp = keyboard_check(ord("S")) - keyboard_check(ord("W"));
	vsp *= move_speed;
	
	// If moving diagonal, scale movement to 1/sqrt(2), smt with Pythagoras
	if (hsp != 0) and (vsp != 0) hsp *= 0.707107; vsp *= 0.707107; 
	
	// Handle vertical and horizontal movement seperately because this solves shit down the line
	move_and_collide(hsp, 0, collision_layer, 4, 0, 0, move_speed, move_speed);
	move_and_collide(0, vsp, collision_layer, 4, 0, 0, move_speed, move_speed);
	
	// Set walking sprite
	if vsp != 0
	{
		sprite_index = spr_player_walk;
		
		// Only flip sprite if moving horizontally (for now)
		if (hsp != 0) image_xscale = sign(hsp);
	}
}