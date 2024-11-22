/// @param		{Id.Instace} _enemy	The enemy for whom to check line of sight to player
/// @returns	{Bool}				True if _enemy can see the player
function can_see_player(_enemy){
	var _player = instance_nearest(_enemy.x, _enemy.y, obj_player)
	var _collision_tiles = layer_tilemap_get_id("Tiles_C")
	return collision_line(x, y - (sprite_height / 2), _player.x, _player.y - (_player.sprite_height / 2), _collision_tiles, false, true) == noone
}