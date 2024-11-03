// Draw weapon behind player (see scr_draw)
if (aimdir > 0 and aimdir < 180) draw_weapon(spr_ray_gun);

// Draw player
draw_self();

// Draw weapon in front of player (see scr_draw)
if (aimdir > 180 and aimdir < 360) draw_weapon(spr_ray_gun);