// Name room_cell_<> refers to a placed room in a cell on the map as to differentiate with the room object
//		in GameMakerStudio.
tile_size = 8
room_cell_width_in_tiles = 20
room_cell_height_in_tiles = 15
room_cell_width = room_cell_width_in_tiles * tile_size
room_cell_height = room_cell_height_in_tiles * tile_size

// Get the tile layer map id
var _tiles_map = layer_tilemap_get_id("Tiles")

// Calculate width and height in cells
var _width = room_width div room_cell_width //8
var _height = room_height div room_cell_height //8

// Create room grid
grid = ds_grid_create(_width, _height)

ds_grid_set_region(grid, 0,0, _width -1 , _height -1, 0)
//randomize()

for(var _i = 0; _i < _width; _i++) {
	for(var _j = 0; _j < _height; _j++) {
		if(random(100) < 50) {
			var _room_info = room_get_info(rm_basic, true, true, true, true, true)
			var _room_tiles = _room_info.layers[0].elements[0].tiles
			var _room_x = _i * room_cell_width_in_tiles
			var _room_y = _j * room_cell_height_in_tiles
			
			var _current_tile_x_count = 0
			var _current_tile_y_count = 0
			
			for(var _k = 0; _k < array_length(_room_tiles); _k++) {
				var _tile_x =  _room_x + (_current_tile_x_count)
				var _tile_y = _room_y + (_current_tile_y_count)
				
				tilemap_set(_tiles_map, _room_tiles[_k], _tile_x, _tile_y)
				
				_current_tile_x_count++
				if(_current_tile_x_count >= room_cell_width_in_tiles) {
					_current_tile_y_count++
					_current_tile_x_count = 0
				}
			}
			
		}
		
	}
}

