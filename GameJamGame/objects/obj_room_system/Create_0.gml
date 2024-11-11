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
var _room_cell_width = global.room_cell_width_in_tiles * global.tile_size
var _room_cell_height = global.room_cell_height_in_tiles * global.tile_size

// Calculate width and height in cells
var _width = room_width div _room_cell_width //9
var _height = room_height div _room_cell_height //9

// Get the collision and decorative tilemaps
var _tiles_map_collision = layer_tilemap_get_id("Tiles_C")
var _tiles_map_decorative = layer_tilemap_get_id("Tiles_D")

// Room generation places a continuous path of rooms every pass. The number of passes
//		increases the potential complexity, but also the potential for clusters of rooms.
//		The population percent (0-1) breaks generation off if more than the given percent
//		rooms are already generated to limit floor size.
var _generation_passes = 4
var _max_population_percent = 0.1
#endregion

#region // Rooms
global.current_room = {}
global.spawn_tile_index = 1
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
	[obj_enemy, obj_enemy, obj_enemy],
	[obj_enemy, obj_enemy, obj_enemy, obj_enemy, obj_enemy, obj_enemy],
]
#endregion

enum DIRECTION {
	RIGHT,
	UP,
	LEFT,
	DOWN
}

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
		var _enemies = place_room(_tiles_map_collision, _tiles_map_decorative, _room, _start_tile_room_x, _start_tile_room_y)
		
		// Calculate bounds
		var _bound_x_left = _start_tile_room_x * global.tile_size
		var _bound_y_top = _start_tile_room_y * global.tile_size
		var _bound_x_right = _bound_x_left + (global.room_cell_width_in_tiles * global.tile_size)
		var _bound_y_bottom = _bound_y_top + (global.room_cell_height_in_tiles * global.tile_size)
		
		// Create and store room data
		var _room_data = { 
			enemies: _enemies,
			bounds: [_bound_x_left, _bound_y_top, _bound_x_right, _bound_y_bottom],
			cleared: false
		}
		array_push(rooms, _room_data) 
				
		// Place player in start room
		if(_i == _start_x && _j == _start_y) {
			var _start_room_center_x = (_start_tile_room_x + (global.room_cell_width_in_tiles / 2)) * global.tile_size + global.tile_size / 2
			var _start_room_center_y = (_start_tile_room_y + (global.room_cell_height_in_tiles / 2)) * global.tile_size + global.tile_size / 2
			instance_create_layer(_start_room_center_x, _start_room_center_y, "Instances", obj_player)
		}
	}
}

/// @description	Tracks which room the player is in and makes the data of that room globally accessable.
/// @throws			Throws a runtime exception when player is not inside any of the stored rooms.
function globalize_current_room() {
	var _player = instance_find(obj_player, 0)
	for(var _i = 0; _i < array_length(rooms); _i++) {
		var _bounds = rooms[_i].bounds
		if(point_in_rectangle(_player.x, _player.y, _bounds[0], _bounds[1], _bounds[2], _bounds[3])) {
			global.current_room = rooms[_i]
			return
		}
	}
	
	throw ("Player out of expected bounds")
}