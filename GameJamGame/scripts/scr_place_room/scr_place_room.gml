/// @param	{Id.TileMapElement} _tiles_map		The id of the tiles map to draw on
/// @param	{Array<Real>}		_tiles			The tiles to draw
/// @param	{Real}				_tile_start_x	Tile grid x of top left of where to draw the room
/// @param	{Real}				_tile_start_y	Tile grid y of top left of where to draw the room
/// @description								Draws the tiles of a room at given tile coordinates
/// @returns	{Struct}						Returns the X and Y coordinates of all enemy spawn tiles and door tiles
function draw_room_tiles(_tiles_map, _tiles, _tile_start_x, _tile_start_y) {
	var _enemy_spawn_tiles = []
	var _door_tiles = []
	
	var _current_tile_x_count = 0
	var _current_tile_y_count = 0	
	for(var _i = 0; _i < array_length(_tiles); _i++) {
		// Calculate X and Y of current tile
		var _tile_x = _tile_start_x + _current_tile_x_count
		var _tile_y = _tile_start_y +_current_tile_y_count
		
		var _tile_index = _tiles[_i]
		
		// Store enemy spawn tile locations and door tile locations and types
		if(_tile_index == global.spawn_tile_index) array_push(_enemy_spawn_tiles, [_tile_x, _tile_y])
		else if (array_contains(global.door_index.door_down, _tile_index) ||
		 array_contains(global.door_index.door_up, _tile_index) ||
		 array_contains(global.door_index.door_left, _tile_index) ||
		 array_contains(global.door_index.door_right, _tile_index)) {
			array_push(_door_tiles, [_tile_x, _tile_y, _tile_index])	
		}
			
		// Place tile
		tilemap_set(_tiles_map, _tile_index, _tile_x, _tile_y)
				
		// Increment X and wrap for Y when exceeding bounds
		_current_tile_x_count++
		if(_current_tile_x_count >= global.room_cell_width_in_tiles) {
			_current_tile_y_count++
			_current_tile_x_count = 0
		}
	}
	
	return {
		enemy_spawn_tiles: _enemy_spawn_tiles,
		door_tiles: _door_tiles
	}
}

/// @param		{Array<[Real, Real]>}	_enemy_spawn_tiles	An array of arrays of X and Y coordinates where to spawn enemies
/// @description						Calculates the spawn data for a random group of enemies.
/// @returns	{Array<Struct>}			Returns an array of enemy data structs containing spawn X and Y and enemy type object.
function calculate_random_enemies(_enemy_spawn_tiles) {
	var _enemies = []
	
	// Shuffle spawn tiles to get more random spawning
	_enemy_spawn_tiles = array_shuffle(_enemy_spawn_tiles)
	
	// Retrieve random assortment of enemies
	var _random_index = irandom(array_length(global.enemy_spawn_groups) - 1)
	var _enemy_group = global.enemy_spawn_groups[_random_index]
	
	// Spawn enemies on each tile
	// Cuts off enemy group when no spawn tiles are left
	for(var _i = 0; _i < array_length(_enemy_spawn_tiles); _i++) {
		if(_i > array_length(_enemy_group) - 1) break
		
		var _spawn_tile = _enemy_spawn_tiles[_i]
		var _half_tile_size = global.tile_size / 2
		var _spawn_x = (_spawn_tile[0] * global.tile_size) + _half_tile_size
		var _spawn_y = (_spawn_tile[1] * global.tile_size) + _half_tile_size
		var _enemy_data = {
			spawn_x: _spawn_x,
			spawn_y: _spawn_y,
			enemy: _enemy_group[_i]
		}
		
		array_push(_enemies, _enemy_data)
	}
	
	return _enemies
}

/// @param		{Asset.GMRoom}		_room					The room to draw
/// @param		{Real}				_tile_start_x			Tile grid x of top left of where to draw the room
/// @param		{Real}				_tile_start_y			Tile grid y of top left of where to draw the room
/// @description											Draws a room at given tile coordinates and calculates a set of enemies to spawn there.
/// @returns	{Struct}									Returns an array of enemy data structs containing spawn X and Y and enemy type object and an array of door tiles.
function place_room(_room, _tile_start_x, _tile_start_y) {
	// Get room to draw tile and instance information
	var _room_info = room_get_info(_room, false, false, true, true, true)
	var _room_tiles_col = _room_info.layers[1].elements[0].tiles
	var _room_tiles_dec = _room_info.layers[0].elements[0].tiles
	
	// Draw the collision tiles
	draw_room_tiles(global.tiles_map_collision, _room_tiles_col, _tile_start_x, _tile_start_y)
	
	// Draw the decorative tiles and return enemy spawn locations
	var _room_data = draw_room_tiles(global.tiles_map_decorative, _room_tiles_dec, _tile_start_x, _tile_start_y)
	
	var _enemies = calculate_random_enemies(_room_data.enemy_spawn_tiles)
	// Calculate and return a random set of enemies
	return {
		enemies: _enemies,
		door_tiles: _room_data.door_tiles
	}
}




