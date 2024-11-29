// See scr_damage for all functions!
check_for_damage_create()

// Default hp is 3
hp = 3

// Default state is alive. If at 0 hp
state = "alive"

// Handles default enemy death (instance_destroy)
function death()
{
	instance_destroy();
}