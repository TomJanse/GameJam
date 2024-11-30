// Draw walking / idle animations if alive
if state == "alive"
{
	if (dx == 0 and dy == 0) sprite_index = spr_scientist_idle 
	else sprite_index = spr_scientist_walk

}

if (shooting && aimdir < 180 && aimdir > 0) draw_weapon(spr_ray_gun)
draw_self()
if (shooting && (aimdir <= 360 && aimdir >= 180) || aimdir == 0) draw_weapon(spr_ray_gun)	