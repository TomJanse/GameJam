if (global.fade_in or global.fade_out)
{
   draw_set_alpha(alpha);
   draw_rectangle(camx, camy,
   camx + camw, camy + camh, false); 
   draw_set_alpha(1);
}