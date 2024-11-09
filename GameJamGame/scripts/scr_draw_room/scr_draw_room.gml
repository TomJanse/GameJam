/// @param	{Id.TileMapElement} _tiles_map		The id of the tiles map to draw on
/// @param	{Asset.GMRoom}		_room			The room to draw
/// @param	{Real}				_tile_start_x	Tile grid x of top left of where to draw the room
/// @param	{Real}				_tile_start_y	Tile grid y of top left of where to draw the room
/// @description								Draws the tiles of a room at given tile coordinates
/// @returns	{Array<[Real, Real]>}			Returns the X and Y coordinates of all enemy spawn tiles
function draw_room_tiles(_tiles_map, _room, _tile_start_x, _tile_start_y) {
	// Get room to draw tile and instance information
	var _room_info = room_get_info(_room, false, false, true, true, true)
	var _room_tiles = _room_info.layers[0].elements[0].tiles
	
	var _enemy_spawn_tiles = []
	
	var _current_tile_x_count = 0
	var _current_tile_y_count = 0	
	for(var _i = 0; _i < array_length(_room_tiles); _i++) {
		// Calculate X and Y of current tile
		var _tile_x = _tile_start_x + _current_tile_x_count
		var _tile_y = _tile_start_y +_current_tile_y_count
		
		var _tile_index = _room_tiles[_i]
		
		// Store enemy spawn tile locations
		if(_tile_index == global.spawn_tile_index) array_push(_enemy_spawn_tiles, [_tile_x, _tile_y])
			
		// Place tile
		tilemap_set(_tiles_map, _tile_index, _tile_x, _tile_y)
				
		// Increment X and wrap for Y when exceeding bounds
		_current_tile_x_count++
		if(_current_tile_x_count >= global.room_cell_width_in_tiles) {
			_current_tile_y_count++
			_current_tile_x_count = 0
		}
	}
	
	return _enemy_spawn_tiles
}

/// @param	{Array<[Real, Real]>}	_enemy_spawn_tiles	An array of arrays of X and Y coordinates where to spawn enemies
/// @description					Spawns a random group of enemies on the given spawn tiles
function spawn_random_enemies(_enemy_spawn_tiles) {
	// Shuffle spawn tiles to get more random spawning
	_enemy_spawn_tiles = array_shuffle(_enemy_spawn_tiles)
	
	// Retrieve random assortment of enemies
	var _random_index = irandom(array_length(global.enemy_spawn_groups) - 1)
	var _enemy_group = global.enemy_spawn_groups[_random_index]
	
	// Spawn enemies on each tile
	// Cuts off enemy group when no spawn tiles are left
	for(var _i = 0; _i < array_length(_enemy_spawn_tiles); _i++) {
		if(_i > array_length(_enemy_group) - 1) break
		var _enemy = _enemy_group[_i]
		
		var _spawn_tile = _enemy_spawn_tiles[_i]
		var _half_tile_size = global.tile_size / 2
		var _spawn_tile_x = (_spawn_tile[0] * global.tile_size) + _half_tile_size
		var _spawn_tile_y = (_spawn_tile[1] * global.tile_size) + _half_tile_size
		instance_create_layer(_spawn_tile_x, _spawn_tile_y, "Instances", _enemy)
	}
}

/// @param	{Id.TileMapElement} _tiles_map		The id of the tiles map to draw on
/// @param	{Asset.GMRoom}		_room			The room to draw
/// @param	{Real}				_tile_start_x	Tile grid x of top left of where to draw the room
/// @param	{Real}				_tile_start_y	Tile grid y of top left of where to draw the room
/// @description								Draws a room at given tile coordinates and spawns enemies
function place_room(_tiles_map, _room, _tile_start_x, _tile_start_y) {
	// Draw the tiles of the room
	var _enemy_spawn_tiles = draw_room_tiles(_tiles_map, _room, _tile_start_x, _tile_start_y)
	
	// Spawn a random set of enemies
	spawn_random_enemies(_enemy_spawn_tiles)
	
}

/// @function									place_random_room(_tiles_map, _tile_start_x, _tile_start_y)
/// @param	{Id.TileMapElement} _tiles_map		The id of the tiles map to draw on
/// @param	{Real}				_tile_start_x	Tile grid x of top left of where to draw the room
/// @param	{Real}				_tile_start_y	Tile grid y of top left of where to draw the room
/// @description								Draws a random room at given tile coordinates and spawns enemies
function place_random_room(_tiles_map, _tile_start_x, _tile_start_y) {
	var _random_index = irandom(array_length(global.rooms) - 1)
	
	// Draw the tiles of the room
	var _enemy_spawn_tiles = draw_room_tiles(_tiles_map, global.rooms[_random_index], _tile_start_x, _tile_start_y)
	
	// Spawn a random set of enemies
	spawn_random_enemies(_enemy_spawn_tiles)
}
	





