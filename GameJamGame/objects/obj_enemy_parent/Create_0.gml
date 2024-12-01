// See scr_damage for all functions!
check_for_damage_create()

// Default hp is 3
hp = 3

// Default hit sound is snd_bullet_destroy
hit_sound = snd_bullet_destroy

// Default state is alive. If at 0 hp
state = "alive"

// Amount of time before the enemy can act when spawned
spawn_time = 100

// Handles default enemy death (instance_destroy)
function death()
{
	instance_destroy();
}

// Use to prevent enemies to act before spawn_time is over
function spawn_timer()
{
	if (spawn_time > 0) spawn_time--
	else if spawn_time == 0 return true
}