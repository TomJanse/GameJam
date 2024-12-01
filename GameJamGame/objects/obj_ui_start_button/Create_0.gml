// Inherit the parent event
event_inherited();

button_width = sprite_get_width(spr_ui_start_button) * scale;
button_height = sprite_get_height(spr_ui_start_button) * scale;
start_x = gui_width / 1.95;  
start_y = gui_height / 2.45;  

// Initialize button sprite
button_sprite = 0;
start_timer = 60;
start_timer_ticking = false;

// If game started, set to true
started = false;

// Main menu music
audio_play_sound(ost_and_then_so_clear_alien_contact_7_floating_in_space, 0, true);

function start_game()
{
	// Check if player hovers
	if point_in_rectangle(gui_mouse_x, gui_mouse_y, start_x, start_y, start_x + button_width, start_y + button_height) 
	{
		// Click the start button, start start_timer
	    if (mouse_check_button_pressed(mb_left)) 
		{
			button_sprite = 2;
			start_timer_ticking = true;
			audio_play_sound(snd_click_start, 0, false);
	    }
		
		// If button has not been clicked, set sprite to hover
		else if button_sprite != 2 button_sprite = 1;
	}
	// Idle sprite set as reset
	else if button_sprite != 2 button_sprite = 0;
	
	// After half a second, start the game
	if start_timer_ticking = true
	{
		if (start_timer > 0) start_timer--
		else if started == false
		{
			audio_stop_sound(ost_and_then_so_clear_alien_contact_7_floating_in_space)
			
			// Actually start game by starting rm_floor script.
			// TODO: CHANGE TO TUTORIAL!
			fade(rm_tutorial);
			started = true;
		}
	}
}