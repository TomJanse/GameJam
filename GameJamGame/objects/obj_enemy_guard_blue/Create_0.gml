// Inherit the parent event
event_inherited();

#region // Variables
walk_distance_max = 30
walk_distance_min = 20
walk_speed = 0.4
walk_cooldown = 180
walk_cooldown_timer = 30
dx = 0
dy = 0
move_angle = 0

aimdir = 0
aim_time = 30
shoot_cooldown = 10
shoot_cooldown_timer = aim_time
shots_per_burst = 3
shot_count = 0

collision_tiles = layer_tilemap_get_id("Tiles_C")
player = instance_nearest(0, 0, obj_player)
#endregion


function shoot() {
}

function walk() {
	if (walk_cooldown_timer) return walk_cooldown_timer--
	
	if (dx == 0 && dy == 0) {
		var _distance = random_range(walk_distance_min, walk_distance_max)
		move_angle = random(359)
		dx = lengthdir_x(_distance, move_angle)
		dy = lengthdir_y(_distance, move_angle)
	} 
	
	var _move_x = lengthdir_x(walk_speed, move_angle);
    var _move_y = lengthdir_y(walk_speed, move_angle);
	
	move_and_collide(dx, dy, collision_tiles, 10, 0, 0, walk_speed, walk_speed)
	
	if (abs(dx) > abs(_move_x)) dx -= sign(_move_x) * abs(_move_x);
    else dx = 0;

    if (abs(dy) > abs(_move_y)) dy -= sign(_move_y) * abs(_move_y);
    else dy = 0;
	
	if(dx == 0 && dy == 0) {
		walk_cooldown_timer = walk_cooldown
		shoot_cooldown_timer = aim_time
		shot_count = 0
	}
}

function shoot() {
	if(!walk_cooldown_timer) return
	if(shot_count == shots_per_burst) return
	if(shoot_cooldown_timer) return shoot_cooldown_timer--
	
	aimdir = point_direction(x, y, player.x, player.y - (player.sprite_height / 2));
	
	audio_play_sound(snd_ray_gun, 0, 0, 1, 0, random_range(0.9, 1))
	var _green_bullet = instance_create_layer(x, y - (sprite_height / 2), "Entities", obj_red_bullet);
	with(_green_bullet) dir = other.aimdir;
	
	shoot_cooldown_timer = shoot_cooldown
	shot_count++
}

