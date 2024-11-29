// Inherit the parent event
event_inherited();

#region // Variables
hp = 3

// Move variables
walk_distance_max = 30
walk_distance_min = 20
walk_speed = 0.4
walk_cooldown = 20
walk_cooldown_shoot_prep = 120
walk_cooldown_timer = 0
if (can_see_player(id)) walk_cooldown_timer = walk_cooldown_shoot_prep
dx = 0
dy = 0
move_angle = 0

// Shoot variables
idle_aimdir = 340
aimdir = idle_aimdir
aim_time = 20
shoot_cooldown = 0 // Update in children
shoot_cooldown_timer = 15
shots_per_burst = 0 // Update in children
shot_count = 0

// Weapon offset variables for draw_weapon()
x_weapon_offset = 0;
y_weapon_offset = 2;
center_y_offset = 7;
updown_offset = 5;

collision_tiles = layer_tilemap_get_id("Tiles_C")
player = instance_nearest(0, 0, obj_player)
#endregion

function walk() {
	// Do not walk if on walk cooldown
	if (walk_cooldown_timer) return walk_cooldown_timer--
	
	// Reset aimdir to idle position
	aimdir = idle_aimdir
	
	// If no walk relative destination specified, randomize a new one
	if (dx == 0 && dy == 0) {
		// Ensure the guard does not walk into walls
		do {
			var _distance = random_range(walk_distance_min, walk_distance_max)
			move_angle = random(359)
			dx = lengthdir_x(_distance, move_angle)
			dy = lengthdir_y(_distance, move_angle)
		} until collision_line(x, y - 1, x + dx, y + dy, collision_tiles, false, true) == noone
	} 
	
	// Calculate x and y to move to
	var _move_x = lengthdir_x(walk_speed, move_angle);
    var _move_y = lengthdir_y(walk_speed, move_angle);
	
	// Move max of walk_speed units to destination
	move_and_collide(_move_x, _move_y, collision_tiles, 10, 0, 0, walk_speed, walk_speed)
	
	// Decrease relative destination to reflect having moved closer
	if (abs(dx) > abs(_move_x)) dx -= sign(_move_x) * abs(_move_x)
    else dx = 0
    if (abs(dy) > abs(_move_y)) dy -= sign(_move_y) * abs(_move_y)
    else dy = 0
	
	// If arrived at relative destination, set walk_cooldown_timer
	if(dx == 0 && dy == 0) {
		if (can_see_player(id)) {
			// If can see the player, prep to shoot
			walk_cooldown_timer = walk_cooldown_shoot_prep
			shoot_cooldown_timer = aim_time
			shot_count = 0
		}  else {
			// If cannot see the player, wait shortly
			walk_cooldown_timer = walk_cooldown
			shoot_cooldown_timer = aim_time
		}
	}
}

function shoot() {
	// If not on walk cooldown, do not shoot
	if(!walk_cooldown_timer) return
	// If shots per burst have been shot, do not shoot again
	if(shot_count == shots_per_burst) return
	// If on shoot cooldown, do not shoot
	if(shoot_cooldown_timer) return shoot_cooldown_timer--
	
	// Calculate aim direction to center of player
	aimdir = point_direction(x, y - (sprite_height / 2), player.x, player.y - (player.sprite_height / 2));
	
	// Play shot sound
	audio_play_sound(snd_guard_gun, 0, 0, 1, 0, random_range(0.9, 1))
	
	// Create bullet and give it direction
	var _red_bullet = instance_create_layer(x, y - (sprite_height / 2), "Entities", obj_red_bullet);
	with(_red_bullet) dir = other.aimdir;
	
	// Set shoot_cooldown_timer and increment shot_count
	shoot_cooldown_timer = shoot_cooldown
	shot_count++
}