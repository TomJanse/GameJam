// Get mouse x and y on gui, taking into account current window size
gui_mouse_x = display_mouse_get_x() - window_get_x();  
gui_mouse_y = display_mouse_get_y() - window_get_y(); 