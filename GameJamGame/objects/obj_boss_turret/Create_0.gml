// Inherit the parent event
event_inherited();

#region // Variables
hp = 100

walk_distance = 50
walk_speed = 1
walk_cooldown = 120
walk_cooldown_timer = 0
walk_direction = 0
dx = 0
dy = 0

shoot_cooldown = 120
shoot_cooldown_timer = shoot_cooldown
number_of_attacks = 4
aimdir = 0
attack_ongoing = -1

attack_cone_angle = 60
attack_cone_angle_step = 1

attack_spray_angle = 120
attack_spray_shots = 40
attack_spray_shot_count = 0

attack_laser_shots_per_burst = 60
attack_laser_shot_count = 0
attack_laser_bursts = 3
attack_laser_burst_count = 0
attack_laser_cooldown = 15

attack_spiral_angle = 0
attack_spiral_angle_step_min = 30
attack_spiral_angle_step_max = 35
attack_spiral_shots = 120
attack_spiral_shot_count = 0

collision_tiles = layer_tilemap_get_id("Tiles_C")
player = instance_nearest(0, 0, obj_player)
#endregion

function move() {
	if(!shoot_cooldown_timer) return
	if(walk_cooldown_timer) return walk_cooldown_timer--
	
	// If no walk relative destination specified, randomize a new one
	if (dx == 0 && dy == 0) {
		// Ensure the boss does not walk into walls
		do {
			walk_direction = random_range(0, 359)
			dx = lengthdir_x(walk_distance, walk_direction)
			dy = lengthdir_y(walk_distance, walk_direction)
		} until collision_line(x, y - 1, x + dx, y + dy, collision_tiles, false, true) == noone
	} 
	
	// Calculate x and y to move to
	var _move_x = lengthdir_x(walk_speed, walk_direction);
    var _move_y = lengthdir_y(walk_speed, walk_direction);
	
	// Move max of walk_speed units to destination
	move_and_collide(_move_x, _move_y, collision_tiles, 10, 0, 0, walk_speed, walk_speed)
	
	// Decrease relative destination to reflect having moved closer
	if (abs(dx) > abs(_move_x)) dx -= sign(_move_x) * abs(_move_x)
    else dx = 0
    if (abs(dy) > abs(_move_y)) dy -= sign(_move_y) * abs(_move_y)
    else dy = 0
	
	// If arrived at relative destination, set walk_cooldown_timer
	if(dx == 0 && dy == 0) {
		walk_cooldown_timer = walk_cooldown
	}
}

function shoot() {
	if (shoot_cooldown_timer) return shoot_cooldown_timer--	
	if (!walk_cooldown_timer) return
	
	if(!can_see_player(id)) return
	
	var _attack = irandom(number_of_attacks - 1)
	if(attack_ongoing != -1) _attack = attack_ongoing
	switch(_attack) {
		case 0: 
			attack_cone()
			break
		case 1: 
			attack_spray()
			break
		case 2:
			attack_laser()
			break
		case 3:
			attack_spiral()
			break
	}
	
	if(attack_ongoing == -1) shoot_cooldown_timer = shoot_cooldown
}

function set_aim_direction() {
	// Calculate aim direction to center of player
	aimdir = point_direction(x, y - (sprite_height / 2), player.x, player.y - (player.sprite_height / 2));	
}

function create_bullet(_dir) {
	var _red_bullet = instance_create_layer(x, y - (sprite_height / 2), "Entities", obj_red_bullet);
	with(_red_bullet) dir = _dir;
}

function attack_cone() {
	var _cone_angle_min = aimdir - (attack_cone_angle / 2)
	if(_cone_angle_min < 0) _cone_angle_min += 360
	
	var _cone_angle_max = aimdir + (attack_cone_angle / 2)
	if (_cone_angle_max >= 360) _cone_angle_max -= 360
	
	var _i = _cone_angle_min
	repeat(ceil(attack_cone_angle / attack_cone_angle_step)) {
		create_bullet(_i)
		
		_i += attack_cone_angle_step
		_i = _i mod 360
	}		
}

function attack_spray() {
	if(attack_spray_shot_count >= attack_spray_shots) {
		attack_ongoing = -1
		attack_spray_shot_count = 0
		return
	}
	
	attack_ongoing = 1
	
	var _spray_angle_min = aimdir - (attack_spray_angle / 2)
	if(_spray_angle_min < 0) _spray_angle_min += 360
	
	var _direction = (_spray_angle_min + random(attack_spray_angle)) mod 360
	create_bullet(_direction)
	
	attack_spray_shot_count++
}

function attack_laser() {
	if(attack_laser_burst_count >= attack_laser_bursts) {
		attack_ongoing = -1
		attack_laser_burst_count = 0
		return
	}
	
	if(attack_laser_shot_count >= attack_laser_shots_per_burst) {
		shoot_cooldown_timer = attack_laser_cooldown
		attack_laser_burst_count++
		attack_laser_shot_count = 0
		return
	}
	
	attack_ongoing = 2	
	
	create_bullet(aimdir)
	
	attack_laser_shot_count++
}

function attack_spiral() {
	if(attack_spiral_shot_count >= attack_spiral_shots) {
		attack_ongoing = -1
		attack_spiral_shot_count = 0
		attack_spiral_angle = 0
		return
	}
	
	attack_ongoing = 3
	
	create_bullet(attack_spiral_angle)
	attack_spiral_angle += irandom_range(attack_spiral_angle_step_min, attack_spiral_angle_step_max)
	
	
	attack_spiral_shot_count++
}
