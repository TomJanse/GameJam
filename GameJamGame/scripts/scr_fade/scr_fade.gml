// This function can be used to fade in and out of a room.
function fade(_target_room)
{
	with obj_fade
	{
		global.fade_out = true;
		next_room = _target_room;
	}
}