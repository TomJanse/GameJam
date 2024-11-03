// Create a camera and set it to follow the player
cam_x = 0
cam_y = 0
cam_width = 180
cam_height = 135
camera = camera_create_view(cam_x, cam_y, cam_width, cam_height);
view_camera[0] = camera;


function track_room() {
	player_in_room = get_player_in_room()
}


function get_player_in_room() {
	if(obj_player.x + obj_player.sprite_width > cam_x + cam_width) return CAMERA_PLAYER_TRACK.RIGHT
	if(obj_player.x - obj_player.sprite_width < cam_x) return CAMERA_PLAYER_TRACK.LEFT
	if(true) return CAMERA_PLAYER_TRACK.IN
}

enum CAMERA_PLAYER_TRACK {
	LEFT,
	RIGHT,
	BELOW,
	ABOVE,
	IN	
}
