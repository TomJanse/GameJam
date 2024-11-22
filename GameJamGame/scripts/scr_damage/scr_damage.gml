// Add to create event
	// Creates damage list and sets hp (default = 3)
	function check_for_damage_create(_hp = 3, _iframes = false)
	{
		// Set creature hp to configured hp
		hp = _hp
		
		// 
		if _iframes == true
		{
			iframe_timer = 0;
			iframe_number = 90;
			
		}

		// Create damage list for creatures without iframes
		else damage_list = ds_list_create();
	}

// Add to step event
	// _damage_object: Check if something is damaged by _damage_object, and apply damage if true. 
	// _iframes: If the instance uses invincibility frames (i.e. the player), then set _iframes to true when calling the function. Default is false (no iframes)
	// _hit_sound: The sound to play upon dealing damage. Default is snd_bullet_destroy. If you wish to play no sound, set _hit_sound to noone.
	function check_for_damage(_damage_object, _iframes = false, _hit_sound = snd_bullet_destroy)
	{
		// In case of active iframes, don't run damage cycle
		if _iframes == true and iframe_timer > 0
		{
			iframe_timer--;
			
			// Swap between visible and invisible sprite every 4 frames, rounded down
			if iframe_timer mod 4 == 0
			{
				if (image_alpha == 1) image_alpha = 0;
				else image_alpha = 1;
			}
			
			exit;
		}
		
		// Make sure iframe blinking stops
		image_alpha = 1;
		
		// Damage checking cycle
		if place_meeting(x, y, [_damage_object, ])
		{	
			// Get list of damage instances currently hitting enemy
			var _inst_list = ds_list_create();
			instance_place_list(x, y, _damage_object, _inst_list, false);
	
			// Get list size and store it in _list_size
			var _list_size = ds_list_size(_inst_list)
	
			// Loop through list of hits and apply damage
			var _hit_confirm = false;
			for(var _i = 0; _i < _list_size; _i++)
			{
				// Get instance from list
				var _inst = ds_list_find_value(_inst_list, _i);
			
				// Check if instance is already in damage list (check if bullet has already damaged enemy)
				// If invincibility frames are used, this is not necessary
				if (_iframes == true) or ds_list_find_index(damage_list, _inst) == -1
				{
					// Add instance to damage list so it isn't applied twice
					if (_iframes == false) ds_list_add(damage_list, _inst);
				
					// Take damage from specific instance
					hp -= _inst.damage;
					_hit_confirm = true;
			
					// Tell instance it has impacted and play sound
					if (_hit_sound != noone) audio_play_sound(_hit_sound, 0, 0, 1, 0, random_range(0.9, 1.1))
					_inst.hit_confirm = true;
				}
			}
			
			// Give iframes to object
			if (_iframes == true and _hit_confirm == true) iframe_timer = iframe_number;
		
			// Cleanup list instance
			ds_list_destroy(_inst_list);
		}
		
		// Cleanup code (not necessary for iframes)
		if _iframes == false
		{
			var _damage_list_size = ds_list_size(damage_list);
			for(var _i = 0; _i < _damage_list_size; _i++)
			{
				// If not touching the damage instance anymore, remove it from the list and set loop back 1 position
				var _inst = ds_list_find_value(damage_list, _i);
				if !instance_exists(_inst) or !place_meeting (x, y, _inst)
				{
					ds_list_delete(damage_list, _i);
					_i--;
					_damage_list_size--;
				}
			}
		}
	}

// Add to clean up event
	// Cleans up damage list
	// DO NOT NEED for objects with iframes
	function check_for_damage_cleanup()
	{
		ds_list_destroy(damage_list)
	}