check_for_damage(obj_damage_enemy, false, hit_sound)
if (hp <= 0) state = "dead"
if (state == "dead") death()