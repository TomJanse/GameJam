// See scr_damage for all functions!
check_for_damage_create()

// Handles default enemy death (instance_destroy)
function death()
{
	if (hp <= 0) instance_destroy();
}