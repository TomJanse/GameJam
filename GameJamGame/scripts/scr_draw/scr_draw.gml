// Draw weapon
function draw_weapon(_sprite,)
{
	// Offsets
	var _x_offset = lengthdir_x(x_weapon_offset, aimdir);
	var _y_offset = lengthdir_y(y_weapon_offset, aimdir);
	
	// Offset if front/back
	if sprite_index = spr_player_back or sprite_index = spr_player_back_walk 
	or sprite_index = spr_player_front or sprite_index = spr_player_front_walk
	{
		if (aimdir > 90 and aimdir < 270) _x_offset += -updown_offset
		else _x_offset += updown_offset
	}
	
	// Flip weapon if looking to left
	var _weapon_yscale = 1;
	if (aimdir > 90 and aimdir < 270) _weapon_yscale = -1;

	// Actually draw weapon
	draw_sprite_ext(_sprite, 0, x + _x_offset, (y + _y_offset - center_y_offset), 
	1, _weapon_yscale, aimdir, c_white, 1);
}