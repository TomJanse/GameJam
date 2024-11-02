// Move to camera object when making camera
fullscreen();

#region Variables
move_speed = 2;

hsp = 0;
vsp = 0;

aimdir = 0;

shoot_timer = 0;
shoot_cooldown = 14;

collision_layer = layer_tilemap_get_id("tiles_collision");
instance_layer = layer_tilemap_get_id("instances");
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

// Handles shooting bullets
function shoot() 
{
	// Aim where mouse is
	aimdir = point_direction(x, y, mouse_x, mouse_y);
	
	// Shoot timer handling
	if (shoot_timer > 0) shoot_timer--
	
	// Shoot
	if mouse_check_button(mb_left) and shoot_timer == 0
	{
		// Reset timer to cooldown
		shoot_timer = shoot_cooldown;
		
		// Create instance of obj_green_bullet and gives instance current mouse position as direction
		var _green_bullet = instance_create_layer(x, y, "instances", obj_green_bullet);
		with(_green_bullet) dir = other.aimdir;
	}
}













