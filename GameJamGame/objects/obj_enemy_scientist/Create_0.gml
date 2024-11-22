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
move_angle_noise_range = 10

// Shoot variables
shooting = false
aimdir = 0
aim_inaccuracy = 10
aim_time = 20
shoot_cooldown = 180
shoot_duration = 180
shoot_cooldown_timer = shoot_cooldown

collision_tiles = layer_tilemap_get_id("Tiles_C")
player = instance_nearest(0, 0, obj_player)
#endregion

function move() {
	// Do not walk when shooting
	if(shooting) return
	
	var _can_see = can_see_player(id)
	
	// Do not walk if on walk cooldown, but override if can see the player
	if (walk_cooldown_timer && !_can_see) return walk_cooldown_timer--
	
	// If can see player, run away. Else, wander
	if(_can_see) {
		// Run in opposite direction of player with noise
		var _player_direction = point_direction(x, y - (sprite_height /2), player.x, player.y - (player.sprite_height /2))
		_player_direction += random_range(-move_angle_noise_range, move_angle_noise_range)
		if(_player_direction < 0) _player_direction += 360
		
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
	// Shooting is false when shoot cooldown is through its shoot_duration phase
	if(shoot_cooldown_timer < shoot_cooldown) shooting = false
	
	// If can not see player, do not shoot or decrease shoot cooldown
	if(!can_see_player(id)) return
	
	// If on shoot cooldown, do not shoot
	if(shoot_cooldown_timer) return shoot_cooldown_timer--
	
	// Set shooting true
	shooting = true
	
	// Calculate aim direction to center of player
	aimdir = point_direction(x, y - (sprite_height / 2), player.x, player.y - (player.sprite_height / 2));
	
	// Add aim inaccuracy
	var _accuracy_modifier = random_range(-aim_inaccuracy, aim_inaccuracy)
	aimdir += _accuracy_modifier
	
	// Create bullet and give it direction
	var _laser = instance_create_layer(x, y - (sprite_height / 2), "Entities", obj_scientist_laser);
	with(_laser) dir = other.aimdir;
	
	// Set shoot_cooldown_timer
	shoot_cooldown_timer = shoot_cooldown + shoot_duration
}

function death() {
	//if(sprite_index != spr_scientist_death && sprite_index != spr_scientist_dead) {
	//	sprite_index = spr_scientist_death
	//} else if (sprite_index == spr_scientist_death && image_index >= image_number - 1) {
	//	sprite_index = spr_scientist_dead
	//}
}