// Draw walking / idle animations if alive
if state == "alive"
{
	if (dx == 0 and dy == 0) sprite_index = spr_guard_blue_idle 
	else sprite_index = spr_guard_blue_walk
}

// Inherit the parent event
event_inherited();

