// GameMaker random values are based on initial seed. This function randomizes seed so
//		that actual random values are generated.
randomize()

// These variables exist to measure out the placement of rooms on the floor.
//		The room cell in tiles assumes a room it can draw has 240 width and 160 height.
//		The drawing of these rooms will not function if given a room size that doesn't
//		match with the given sizes in tiles and tile_size.
global.tile_size = 8
global.room_cell_width_in_tiles = 30
global.room_cell_height_in_tiles = 20
var _room_cell_width = global.room_cell_width_in_tiles * global.tile_size
var _room_cell_height = global.room_cell_height_in_tiles * global.tile_size

var _generation_passes = 4

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
global.enemy_spawn_groups = [
	[obj_enemy, obj_enemy, obj_enemy],
	[obj_enemy, obj_enemy, obj_enemy, obj_enemy, obj_enemy, obj_enemy],
]

enum DIRECTION {
	RIGHT,
	UP,
	LEFT,
	DOWN
}

// Get the tile layer map id
var _tiles_map = layer_tilemap_get_id("Tiles")

// Calculate width and height in cells
var _width = room_width div _room_cell_width //8
var _height = room_height div _room_cell_height //8

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

// Set start grid X and Y
var _start_x = irandom(_width - 1)
var _start_y = irandom(_height - 1)

// Set exit grid X and Y
var _end_x 
var _end_y 
do {
    _end_x = irandom(_width - 1)
	_end_y = irandom(_height - 1)
} until (_end_x != _start_x || _end_y != _start_y)

var _room_count = 0
var _target_x = _start_x
var _target_y = _start_y
for(var _i = 0; _i < _generation_passes; _i++) {
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
	
	// Generate a new random start point for the next pass and ensure
	//		that start point is a location on the blueprint that has
	//		not been covered yet.
	var _position_connections = []
	do {
	    _start_x = irandom(_width - 1)
	    _start_y = irandom(_height - 1)
	    _position_connections = blueprint[# _start_x, _start_y]
	} until array_equals(_position_connections, [false, false, false, false])
	
	
	// Generate a new random end point for the next pass and ensure
	//		that end point is a location on the blueprint that has
	//		been visited so the new pass is connected to the previous ones.
	do {
	    _end_x = irandom(_width - 1)
	    _end_y = irandom(_height - 1)
	    _position_connections = blueprint[# _end_x, _end_y]
	} until !array_equals(_position_connections, [false, false, false, false])

	// Set new target X and Y for the next pass
	_target_x = _start_x
	_target_y = _start_y
}

//var _room_grid = ds_grid_create(_width, _height)
for(var _i = 0; _i < _width; _i++) {
	for(var _j = 0; _j < _height; _j++) {
			var _start_tile_room_x = _i * global.room_cell_width_in_tiles
			var _start_tile_room_y = _j * global.room_cell_height_in_tiles
			var _current_room_connections = blueprint[# _i, _j]
			
			if(array_equals(_current_room_connections, [false, false, false, false])) {
				// Empty room
			} else {
				var _room = get_random_room_based_on_connections(_current_room_connections)
				place_room(_tiles_map, _room, _start_tile_room_x, _start_tile_room_y)
			}
	}
}



