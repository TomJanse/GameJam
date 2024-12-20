// Handles taking damage
event_inherited();
hp = 5;

// Handles speed and movement
move_speed = 0.8;
reset_speed = move_speed;

hsp = 0;
vsp = 0;

chasing_distance = 200
bite_distance = 10

// Check player location
if (obj_player != noone)
player = instance_nearest(x, y, obj_player);

// Warning when player close to bite range
bite_warning_distance = 30

// Determine where collision is
collision_layer = layer_tilemap_get_id("Tiles_C");

// Bite timer default
timer = 0;
max_timer = 20;

// Set standart distance to zero
distance = 0

// Handles sprite when idle
function idle()
{
	if hsp == 0 and vsp == 0
	{
		if (sprite_index == spr_dog_back) sprite_index = spr_dog_idle;
		else if (sprite_index == spr_dog_front) sprite_index = spr_dog_idle;
		else if (sprite_index == spr_dog_side) sprite_index = spr_dog_idle;
	}
}

function move()
{
	if (timer > 0) return;
	
	
	if (!instance_exists(id)) return
	var _direction_to_player = direction_of_player(id, player)

// Direction towards the player and update position
	hsp = lengthdir_x(move_speed, _direction_to_player);
    vsp = lengthdir_y(move_speed, _direction_to_player);
    if hsp != 0 image_xscale = -sign(hsp);
    if space_free_x(obj_guard_dog, hsp, collision_layer) x += hsp
    if space_free_y(obj_guard_dog, vsp, collision_layer) y += vsp

// Set walking sprite
	if (abs(vsp) > abs(hsp)) 
	{
		if (vsp < 0 and bite_warning_distance > 30) sprite_index = spr_dog_back;
		else sprite_index = spr_dog_front;
	} 
	else 
	{
		if (hsp < 0 and bite_warning_distance > 30) sprite_index = spr_dog_side;
	}
	
	// Stops chasing when enemy is too far	
	if (distance > chasing_distance) 
	{
		hsp = 0;
		vsp = 0;
		move_speed = 0;
	}
}

function bite()
{ 
// Determine what distance means
	distance = point_distance(x, y, player.x, player.y-7);

// Check if player is in bite distance
	if (distance < bite_distance) 
	{
		move_speed = 0;
		timer = max_timer;
	}

// Set bite sprite
	if (abs(vsp) > abs(hsp)) 
	{
		if (vsp > 0 and distance < bite_warning_distance) sprite_index = spr_dog_front_bite;
		else if (vsp < 0 and distance < bite_warning_distance) sprite_index = spr_dog_back_bite; 
	} 
	else 
	{
		if (hsp < 0 and distance < bite_warning_distance) sprite_index = spr_dog_side_bite;
		if (hsp > 0 and distance < bite_warning_distance) sprite_index = spr_dog_side_bite;
    }

// Timer counting down after bite
	if (timer > 0) 
	{
		timer -= 1;
	}

// Chase player again		
	if (distance > 15 and timer == 0) 
	{
		move_speed = reset_speed; 
	}
}

function death() {
	if(sprite_index != spr_dog_death && sprite_index != spr_dog_dead) {
		sprite_index = spr_dog_death
	} else if (sprite_index == spr_dog_death && image_index >= image_number - 1) {
		sprite_index = spr_dog_dead
	}
	
	// Bonk sound when head hits the floor
	if (image_index == 5) audio_play_sound(snd_bonk, 0, false, 1, 0, random_range(0.9, 1.1));

	hit_sound = snd_bullet_destroy
}
