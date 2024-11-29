if state == "alive"
{
	if (aimdir < 180 && aimdir > 0) draw_weapon(spr_guard_gun)

	// Draw the sprite
	draw_self()

	if ((aimdir <= 360 && aimdir >= 180) || aimdir == 0) draw_weapon(spr_guard_gun)
}

// Don't draw gun if dead
else draw_self();