check_for_damage(obj_damage_enemy)
if (hp <= 0) state = "dead"
if (state == "dead") death()