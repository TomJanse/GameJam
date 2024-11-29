global.fade_out = false;
global.fade_in = false;

next_room = room;
alpha = 0;
fade_speed = 0.1;

camx = camera_get_view_x(view_camera[0])
camy = camera_get_view_y(view_camera[0])
camw = camera_get_view_width(view_camera[0])
camh = camera_get_view_height(view_camera[0])

function fade_out_function()
{
	if global.fade_out 
	{
		alpha += fade_speed;
		
		// Room is visible
		if alpha >= 1
		{
			global.fade_out = false;
			global.fade_in = true;
			room_goto(next_room);
		}
	}
}

function fade_in_function()
{
	if global.fade_in
	{
		alpha -= fade_speed;
		
		// Room is black
		if alpha <= 0
		{
			global.fade_in = false;
		}
	}
}