#region Variables
move_speed = 1.8;

hsp = 0;
vsp = 0;

is_aiming_left = false

shoot_timer = 0;
shoot_cooldown = 29;

collision_layer = layer_tilemap_get_id("Tiles_C");
instance_layer = layer_tilemap_get_id("Instances");

// Variables for scr_draw
x_weapon_offset = 1;
y_weapon_offset = 2;
center_y_offset = 7;
updown_offset = 5;

// Variables for bullet and weapon length
bullet = obj_green_bullet;
weapon_length = sprite_get_bbox_right(spr_ray_gun) - sprite_get_xoffset(spr_ray_gun);
#endregion

// Handles sprite when idle
function idle()
{
	if hsp == 0 and vsp == 0
	{
		if (sprite_index == spr_player_left_walk) sprite_index = spr_player_left;
		else if (sprite_index == spr_player_right_walk) sprite_index = spr_player_right;
		else if (sprite_index == spr_player_front_walk) sprite_index = spr_player_front;
		else if (sprite_index == spr_player_back_walk) sprite_index = spr_player_back;

	}
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
	if (hsp < 0) sprite_index = spr_player_left_walk;
	else if (hsp > 0) sprite_index = spr_player_right_walk;
	else if (vsp > 0) sprite_index = spr_player_front_walk;
	else if (vsp < 0) sprite_index = spr_player_back_walk;

}

// Handles shooting bullets
function shoot() 
{
	// Aim where mouse is
	//TODO fix aim direction X origin.
	aimdir = point_direction(x, y  - (sprite_height / 2), mouse_x, mouse_y);
	
	// Shoot timer handling
	if (shoot_timer > 0) shoot_timer--
	
	// Shoot
	if mouse_check_button(mb_left) and shoot_timer == 0
	{
		// Reset timer to cooldown
		shoot_timer = shoot_cooldown;
		
		// Sprite offsets based on weapon length
		var _x_offset = lengthdir_x(weapon_length, aimdir) 
		var _y_offset = lengthdir_y(weapon_length, aimdir) - center_y_offset
		
		// Sprite offset edits based on facing direction
		if sprite_index = spr_player_back or sprite_index = spr_player_back_walk 
		or sprite_index = spr_player_front or sprite_index = spr_player_front_walk
		if (aimdir > 90 and aimdir < 270) _x_offset += -updown_offset
		else _x_offset += updown_offset
		
		// Create instance of obj_green_bullet
		var _green_bullet = instance_create_layer(x + _x_offset, y + _y_offset, "Instances", bullet);
		with(_green_bullet) dir = other.aimdir;
	}
}













