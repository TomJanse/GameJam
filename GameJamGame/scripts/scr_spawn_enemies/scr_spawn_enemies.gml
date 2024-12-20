/// @description					Spawns instances of enemies in the provided array on the Entities layer.
/// @param {Array<Struct>} _enemies	Array of enemy spawn info containing X and Y and enemy Object.
function spawn_enemies(_enemies) {
	var _ids = []
	for(var _i = 0; _i < array_length(_enemies); _i++) {
		var _e = _enemies[_i]
		var _id = instance_create_layer(_e.spawn_x, _e.spawn_y, "Entities", _e.enemy)
		array_push(_ids, _id)
	}
	
	return _ids
}