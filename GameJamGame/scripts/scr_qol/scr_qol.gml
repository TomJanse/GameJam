// Set window to fullscreen
function fullscreen()
{
	window_set_fullscreen(true);
}

// Returns true if horizontal place is free
function space_free_x(_entity, _entity_move_x, _tileset_layer)
{
    if !place_empty(_entity.x + _entity_move_x, _entity.y, _tileset_layer) return false
    return true
}

// Returns true if vertical place is free
function space_free_y(_entity, _entity_move_y, _tileset_layer)
{
    if !place_empty(_entity.x, _entity.y + _entity_move_y, _tileset_layer) return false
    return true
}

function distance_to_player(_entity, _player)
{
    if (_player != noone) return point_distance(_entity.x, _entity.y, _player.x, _player.y)
	return 0 
}
function direction_of_player(_entity, _player)
{
    if (_player != noone) return point_direction(_entity.x, _entity.y, _player.x, _player.y)
	return 0 
}