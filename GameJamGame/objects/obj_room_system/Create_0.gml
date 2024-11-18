/// @description
// GameMaker random values are based on initial seed. This function randomizes seed so
//		that actual random values are generated.
randomize()

#region // Room generation variables
// These variables exist to measure out the placement of rooms on the floor.
//		The room cell in tiles assumes a room it can draw has 240 width and 160 height.
//		The drawing of these rooms will not function if given a room size that doesn't
//		match with the given sizes in tiles and tile_size.
global.tile_size = 8
global.room_cell_width_in_tiles = 30
global.room_cell_height_in_tiles = 20
room_cell_width = global.room_cell_width_in_tiles * global.tile_size
room_cell_height = global.room_cell_height_in_tiles * global.tile_size

// Calculate width and height in cells
var _width = room_width div room_cell_width //9
var _height = room_height div room_cell_height //9

// Get the collision and decorative tilemaps
global.tiles_map_collision = layer_tilemap_get_id("Tiles_C")
global.tiles_map_decorative = layer_tilemap_get_id("Tiles_D")

// Room generation places a continuous path of rooms every pass. The number of passes
//		increases the potential complexity, but also the potential for clusters of rooms.
//		The population percent (0-1) breaks generation off if more than the given percent
//		rooms are already generated to limit floor size.
var _generation_passes = 4
var _max_population_percent = 0.1

enum DIRECTION {
	RIGHT,
	UP,
	LEFT,
	DOWN
}
#endregion

#region // Rooms
global.current_room = -1
// TODO: Change tile indexes to correct values when tile map is complete
global.spawn_tile_index = 1
global.door_left_tile_index = 2
global.door_right_tile_index = 2
global.door_up_tile_index = 2
global.door_down_tile_index = 2
global.rooms = [
	[rm_basic, false, false, false, true],
	[rm_basic, false, false, true, false],
	[rm_basic, false, false, true, true],
	[rm_basic, false, true, false, false],
	[rm_basic, false, true, false, true],
	[rm_basic, false, true, true, false],
	[rm_basic, false, true, true, true],
	[rm_basic, true, false, false, false],
	[rm_basic, true, false, false, true],
	[rm_basic, true, false, true, false],
	[rm_basic, true, false, true, true],
	[rm_basic, true, true, false, false],
	[rm_basic, true, true, false, true],
	[rm_basic, true, true, true, false],
	[rm_basic, true, true, true, true]
]
#endregion

#region // Enemy spawn groups
global.enemy_spawn_groups = [
	[obj_enemy_guard, obj_enemy_guard],
]
#endregion

#region // Initialize camera
view_camera[0] = camera_create()
camera_set_view_size(view_camera[0], room_cell_width, room_cell_height)
#endregion

#region // Generate floor

// Create floor blueprint
//		The blueprint will contain an array of four booleans at each possible room location
//		To record the connections between rooms these booleans represent the following:
//			0: Right
//			1: Up
//			2: Left
//			3: Down
blueprint = ds_grid_create(_width, _height)

// Set all values of the blueprint to have no connections
// ds_grid_set_grid_region() not used as unique bool arrays are required
for(var _i = 0; _i < _width; _i++) {
	for(var _j = 0; _j < _height; _j++) {
		blueprint[# _i, _j] = [false, false, false, false]
	}
}

// Set X and Y of start room to center room
var _start_x = 4
var _start_y = 4

var _room_count = 0
for(var _i = 0; _i < _generation_passes; _i++) {
	// Generate a new random end point and ensure that end point is a location 
	//		on the blueprint that has not been visited.
	var _position_connections = []
	do {
	    _end_x = irandom(_width - 1)
	    _end_y = irandom(_height - 1)
	    _position_connections = blueprint[# _end_x, _end_y]
	} until (array_equals(_position_connections, [false, false, false, false]) && _end_x != _start_x && _end_y != _start_y)  
	
	
	var _target_x = _start_x
	var _target_y = _start_y
	
	// Pick random direction equating to the DIRECTION enum values (0 - 3)
	//		(DIRECTION[X] notation is not supported)
	var _direction = irandom(3)

	while (_target_x != _end_x || _target_y != _end_y) {
		var _previous_x = _target_x
		var _previous_y = _target_y
		
		// Step target X and Y based on random direction
		_target_x += (_direction == DIRECTION.RIGHT) - (_direction == DIRECTION.LEFT)
		_target_y += (_direction == DIRECTION.DOWN) - (_direction == DIRECTION.UP)
		
		// Clamp target X and Y within bounds
		_target_x = clamp(_target_x, 0, _width - 1)
		_target_y = clamp(_target_y, 0, _height - 1)
       
		// Choose the next direction
		//		If target X and Y didn't change AND 50% of the time, choose random direction
		//		Else pick X or Y and set direction to approach the exit
		if (_target_x == _previous_x && _target_y == _previous_y) {
           _direction = irandom(3)
		} else {
			if(coin_flip()) {
				if (_target_x < _end_x) {
					_direction = DIRECTION.RIGHT
				} else {
					_direction = DIRECTION.LEFT
				}
			} else {
				if (_target_y < _end_y) {
					_direction = DIRECTION.DOWN
				} else {
					_direction = DIRECTION.UP
				}
			}
		}
		
		// If the target room had no connections it was empty and will increase room count
		var _targetblueprint_location = ds_grid_get(blueprint, _target_x, _target_y)
		if(array_equals(_targetblueprint_location, [false, false, false, false])) _room_count++

		// Update the blueprint connections based on the previous room and the target room
		if (_target_x > _previous_x) {
			blueprint[# _previous_x, _previous_y][DIRECTION.RIGHT] = true
			blueprint[# _target_x, _target_y][DIRECTION.LEFT] = true
		} else if (_target_x < _previous_x) {
			blueprint[# _previous_x, _previous_y][DIRECTION.LEFT] = true
			blueprint[# _target_x, _target_y][DIRECTION.RIGHT] = true
	    } else if (_target_y > _previous_y) {
	        blueprint[# _previous_x, _previous_y][DIRECTION.DOWN] = true
	        blueprint[# _target_x, _target_y][DIRECTION.UP] = true
	    } else {
	        blueprint[# _previous_x, _previous_y][DIRECTION.UP] = true
	        blueprint[# _target_x, _target_y][DIRECTION.DOWN] = true
	    }
	}
	
	// End generation early if room amount is exeeding desired population percentage
	if(_room_count > (_width * _height) / _max_population_percent) break
}

// Floor grid stores for all locations:
//	- an array of coordinates of the four corners of the location;
//	- an array of enemy data structs containing X and Y coordinates for each and enemy type object;
//	- an array of door tile data arrays containing tile X and Y coordinates and tile index;
//	- a bool storing if the room has been cleared;
rooms = []

// Draw random rooms for each given location and connections
for(var _i = 0; _i < _width; _i++) {
	for(var _j = 0; _j < _height; _j++) {
		// Skip locations that have no connections
		var _current_room_connections = blueprint[# _i, _j]
		if(array_equals(_current_room_connections, [false, false, false, false])) continue
		
		var _start_tile_room_x = _i * global.room_cell_width_in_tiles
		var _start_tile_room_y = _j * global.room_cell_height_in_tiles
				
		// Place random room	
		var _room = get_random_room_based_on_connections(_current_room_connections)
		var _room_data = place_room(_room, _start_tile_room_x, _start_tile_room_y)
		
		// Calculate inner bounds of the room (excluding wall and door tiles)
		var _bound_x_left = _start_tile_room_x * global.tile_size
		var _bound_y_top = _start_tile_room_y * global.tile_size
		var _bound_x_right = (_start_tile_room_x + global.room_cell_width_in_tiles) * global.tile_size
		var _bound_y_bottom = (_start_tile_room_y + global.room_cell_height_in_tiles) * global.tile_size
		
		// Create and store room data
		array_push(rooms, { 
			enemies: _room_data.enemies,
			bounds: [_bound_x_left, _bound_y_top, _bound_x_right, _bound_y_bottom],
			door_tiles: _room_data.door_tiles,
			cleared: false
		}) 
				
		// Place player in start room
		if(_i == _start_x && _j == _start_y) {
			var _start_room_center_x = (_start_tile_room_x + (global.room_cell_width_in_tiles / 2)) * global.tile_size + global.tile_size / 2
			var _start_room_center_y = (_start_tile_room_y + (global.room_cell_height_in_tiles / 2)) * global.tile_size + global.tile_size / 2
			instance_create_layer(_start_room_center_x, _start_room_center_y, "Player", obj_player)
		}
	}
}

#endregion

/// @description	Checks if any enemy in the listed enemies of a room still exists.
function is_cleared(_room_data) {
	if(_room_data == -1) return false
	var _enemies = _room_data.enemies

	for(var _j = 0; _j < array_length(_enemies); _j++) {
		if(instance_exists(_enemies[_j].enemy)) return false
	}
	return true
}

/// @description					Check which room the player is in by comparing its position to the room bounds.
/// @param	{Id.Instance} _player	The player instance to use for checking.	
/// @throws							Player outside of expected bounds error.
function get_current_room(_player) {
	for(var _i = 0; _i < array_length(rooms); _i++) {
		var _bounds = rooms[_i].bounds
		if(point_in_rectangle(_player.x, _player.y, _bounds[0], _bounds[1], _bounds[2], _bounds[3])) {
			return rooms[_i]
		}
	}
	
	throw "Player outside of expected bounds!"
}

/// @description							Push the player into a new room by altering their X or Y based on the previous room.
/// @param	{Id.Instance} _player			The player instance to move.
/// @param	{Array<Real>} _previous_bounds	The bounds of the previous room to compare against.
function push_player_into_room(_player, _previous_bounds) {
		// Multiplications are to account for the player's height as they are 2 tiles tall
		//		and their Y coordinate is settled at the bottom of the sprite.
		if (_player.x <= _previous_bounds[0]) _player.x -= global.tile_size * 2 // Entered from the right	
		else if (_player.x >= _previous_bounds[2]) _player.x += global.tile_size * 2 // Entered from the left
		else if (_player.y <= _previous_bounds[1]) _player.y -= global.tile_size // Entered from the bottom
		else  _player.y += global.tile_size * 3 // Entered from the top
}

/// @description					Open or close the doors of a given room.
/// @param	{Struct} _room_data		The room data containing door tiles.
/// @param	{Bool} _open			Whether to open (true) or close (false) the doors.
function change_door_state(_room_data, _open) {
	for (var _i = 0; _i < array_length(_room_data.door_tiles); _i++) {
		var _door = _room_data.door_tiles[_i];
		
		// If opening, clear collision and update decorative layer
		if (_open) {
			tilemap_set(global.tiles_map_collision, 0, _door[0], _door[1]);
			tilemap_set(global.tiles_map_decorative, _door[2], _door[0], _door[1]);
		} 
		// If closing, update collision and clear decorative layer
		else {
			tilemap_set(global.tiles_map_collision, _door[2], _door[0], _door[1]);
			tilemap_set(global.tiles_map_decorative, 0, _door[0], _door[1]);
		}
	}
}

/// @description	Tracks which room the player is in and updates the rooms.
/// @throws			Throws a runtime exception when player is not inside any of the stored rooms.
function update_current_room() {
	// Update room cleared status
	if(is_cleared(global.current_room) && global.current_room.cleared == false) {
		global.current_room.cleared = true
		
		// Open doors
		change_door_state(global.current_room, true)
	}
	
	// Update current room status
	var _player = instance_find(obj_player, 0)
	var _room_data = get_current_room(_player)
	if(_room_data != global.current_room) {
		// Relocate the camera to the next room
		var _bounds = _room_data.bounds
		camera_set_view_pos(view_camera[0],_bounds[0], _bounds[1])
		
		// Clear all entities
		layer_destroy_instances("Entities")
				
		// If room not cleared yet, place enemies, close the doors, and push player
		//		into room to avoid collision with closing doors.
		if(!_room_data.cleared) { 
			spawn_enemies(_room_data.enemies)
			
			// Push player into the new room
			if(global.current_room != -1) push_player_into_room(_player, global.current_room.bounds)
			
			// Close doors
			change_door_state(_room_data, false)
		}
		
		// Update current room
		global.current_room = _room_data
	}
}