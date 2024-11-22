if(length != 0) {
	// Start laser animation
	draw_sprite_ext(
	    spr_laser_beam,
	    -1,
	    x,         
	    y,
	    length / sprite_width, 
	    1,          
	    dir,         
	    c_white, 
	    1      
	)
	
	// Start laser collide animation
	draw_sprite(
		spr_laser_collide,
		-1,
		end_x - 8,
		end_y - 8
	)
	
}