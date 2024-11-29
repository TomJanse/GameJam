// Inherit the parent event
event_inherited();

// Get sprite dimensions and calculate position for music toggle
mus_width = sprite_get_width(spr_ui_music) * scale;
mus_height = sprite_get_height(spr_ui_music) * scale;
mus_x = gui_width - scale_space - mus_width;  
mus_y = scale_space;  

// Initialize the music toggle state
playing_music = true; 
music_toggle_sprite = 0;
audio_play_sound(ost_amethyst_cockpit, 0, true);

function music_toggle()
{
	// Get mouse x and y on gui, taking into account current window size
	gui_mouse_x = display_mouse_get_x() - window_get_x();  
	gui_mouse_y = display_mouse_get_y() - window_get_y(); 

	// Check if the player clicked on the music toggle button
	if point_in_rectangle(gui_mouse_x, gui_mouse_y, mus_x, mus_y, mus_x + mus_width, mus_y + mus_height) 
	{
		// Click the music toggle button
	    if (mouse_check_button_pressed(mb_left)) 
		{
	       
		   // Turn music on / off
	        if (playing_music == true)
			{
	            playing_music = false;
				audio_stop_sound(ost_amethyst_cockpit);
			}
			else if (playing_music == false)
			{
				playing_music = true;
				audio_play_sound(ost_amethyst_cockpit, 0, true);
			}
	    }
		
		// If not clicking, its hovering, thus hover sprite
		else music_toggle_sprite = 1;
	}
	
	// Set sprite if not hovering
	else if (playing_music == true) music_toggle_sprite = 0;
	else if (playing_music == false) music_toggle_sprite = 2;
}