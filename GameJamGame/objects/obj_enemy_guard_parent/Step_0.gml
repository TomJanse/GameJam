// Inherit the parent event
event_inherited();

// Choose a random hit sound to play
if (state == "alive") {
	shoot()
	walk()
	
	// While alive, randomly generate oof sound
	hit_sound = choose(snd_oof_1, snd_oof_2, snd_oof_3);
}