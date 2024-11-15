/// @param		{Array<Bool>}	_connections	Array denoting connections the room must have based on DIRECTION enum
/// @returns	{Asset.GMRoom}					Returns a random room that matches connections with _connections array.
function get_random_room_based_on_connections(_connections) {
	var _valid_rooms = []
	
	for(var _i = 0; _i < array_length(global.rooms); _i++) {
		var _room_connections = []
		
		// Retrieve only the connections data for the room
		array_copy(_room_connections, 0, global.rooms[_i], 1, 4)
		
		// Store the room at index 0 in _valid_rooms
		if(array_equals(_connections, _room_connections)) array_push(_valid_rooms, global.rooms[_i][0])
	}
	
	var _valid_rooms_length = array_length(_valid_rooms)
	var _random_index = irandom(_valid_rooms_length - 1)
	return _valid_rooms[_random_index]
}