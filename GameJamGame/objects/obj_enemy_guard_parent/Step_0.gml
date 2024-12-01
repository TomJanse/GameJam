// Inherit the parent event
event_inherited();

if (state == "alive") 
{
	spawn_timer();
	
	if spawn_timer() == true
	{
		shoot()
		walk()
	}
	
	// While alive, randomly generate oof sound
	hit_sound = choose(snd_oof_1, snd_oof_2, snd_oof_3);
}