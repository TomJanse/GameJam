player = instance_nearest(x, y, obj_player);

// Starts the game
function teleport()
{
	if place_meeting(x, y, player) 
	{
		fade(rm_floor);
		audio_stop_all();
	}
}