hp = 3;

// Handles taking damage
function take_damage()
{
	if place_meeting(x, y, obj_damage_enemy)
	{
		// Get instance which damages enemy
		var _inst = instance_place(x, y, obj_damage_enemy);
		
		// Take damage
		hp -= _inst.damage;
		
		// Tell instance to destroy itself
		_inst.destroy = true;
	}
}

function death()
{
	if (hp <= 0) instance_destroy();
}