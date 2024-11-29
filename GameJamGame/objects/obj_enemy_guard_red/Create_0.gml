// Inherit the parent event
event_inherited();

// Medium spray
shoot_cooldown = 20
shots_per_burst = 5

// Override death function for death animation
function death() {
	if(sprite_index != spr_guard_red_death && sprite_index != spr_guard_red_dead) {
		sprite_index = spr_guard_red_death
	} else if (sprite_index == spr_guard_red_death && image_index >= image_number - 1) {
		sprite_index = spr_guard_red_dead
	}
	
	// Bonk sound when head hits the floor
	if (image_index == 5) audio_play_sound(snd_bonk, 0, false, 1, 0, random_range(0.9, 1.1));
	
	state = "dead"
	hit_sound = snd_bullet_destroy;
}