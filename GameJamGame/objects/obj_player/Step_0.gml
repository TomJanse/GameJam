if state == "Alive"
{
	idle()
	move()
	shoot()
	check_for_damage(obj_damage_player, true, snd_taking_damage)
	check_for_death()
}
else if state == "Dead"
{
	death()
}