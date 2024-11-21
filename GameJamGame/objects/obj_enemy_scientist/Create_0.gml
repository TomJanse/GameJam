// Inherit the parent event
event_inherited();

#region // Variables
hp = 3

// Move variables
walk_distance = 10
walk_speed = 0.4
walk_cooldown = 120
walk_cooldown_shoot_prep = 120
walk_cooldown_timer = 0
dx = 0
dy = 0
move_angle = 0

// Shoot variables
aimdir = 0
aim_inaccuracy = 10
aim_time = 20
shoot_cooldown = 120
shoot_cooldown_timer = 0

collision_tiles = layer_tilemap_get_id("Tiles_C")
player = instance_nearest(0, 0, obj_player)
#endregion

function move() {
	// Do not walk if on walk cooldown
	if (walk_cooldown_timer) return walk_cooldown_timer--
	
	// If can see player, run away. Else, wander
	if(can_see_player(id)) {
		// Run in opposite direction of player
		var _player_direction = point_direction(x, y - (sprite_height /2), player.x, player.y - (player.sprite_height /2))
		move_angle = (_player_direction + 180) % 360
		dx = lengthdir_x(walk_distance, move_angle)
		dy = lengthdir_y(walk_distance, move_angle)
	} else {
		// If no walk relative destination specified, randomize a new one
		if (dx == 0 && dy == 0) {
			// Ensure the scientist does not walk into walls
			do {
				move_angle = random(359)
				dx = lengthdir_x(walk_distance, move_angle)
				dy = lengthdir_y(walk_distance, move_angle)
			} until collision_line(x, y - 1, x + dx, y + dy, collision_tiles, false, true) == noone
			
			// Set walk cooldown
			walk_cooldown_timer = walk_cooldown
		} 
	}
	
	// Calculate x and y to move to
	var _move_x = lengthdir_x(walk_speed, move_angle);
    var _move_y = lengthdir_y(walk_speed, move_angle);
	
	// Move max of walk_speed units to destination
	move_and_collide(_move_x, _move_y, collision_tiles, 4, 0, 0, walk_speed, walk_speed)
	
	// Decrease relative destination to reflect having moved closer
	if (abs(dx) > abs(_move_x)) dx -= sign(_move_x) * abs(_move_x)
    else dx = 0
    if (abs(dy) > abs(_move_y)) dy -= sign(_move_y) * abs(_move_y)
    else dy = 0
}

function shoot() {
	//// If not on walk cooldown, do not shoot
	//if(!walk_cooldown_timer) return
	//// If shots per burst have been shot, do not shoot again
	//if(shot_count == shots_per_burst) return

	
	// If on shoot cooldown, do not shoot
	if(shoot_cooldown_timer) return shoot_cooldown_timer--
	
	// Calculate aim direction to center of player
	aimdir = point_direction(x, y - (sprite_height / 2), player.x, player.y - (player.sprite_height / 2));
	
	// Add aim inaccuracy
	var _accuracy_modifier = random_range(-aim_inaccuracy, aim_inaccuracy)
	aimdir += _accuracy_modifier
	
	// Create bullet and give it direction
	var _laser = instance_create_layer(x, y - (sprite_height / 2), "Entities", obj_scientist_laser);
	with(_laser) dir = other.aimdir;
	
	// Set shoot_cooldown_timer and increment shot_count
	shoot_cooldown_timer = shoot_cooldown
}