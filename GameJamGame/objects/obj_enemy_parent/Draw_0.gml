draw_self();

// Debug: show hp
draw_text(x, y, string(hp));

// Debug: show size of damage list (cleanup check)
// draw_text(x, y-32, string(ds_list_size(damage_list)));