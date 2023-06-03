extends NPC

@export var small_sword: WeaponRes

func set_action_index():
	add_action_to_index(6, func(): 
		if player_reference.coins >= 10:
			player_reference.coins -= 10
			player_reference.weapon = small_sword
			dialogue(6, 10)
		else:
			dialogue(6, 7)
	)
	add_action_to_index(9, func(): 
		dialogue(9, 0)
		
		key.visible = false
		textBox.visible = false
		can_interact = false
		
		switch_dialogue_option(1)
		clear_action_index()
		secondary_action_index()
	)
	add_action_to_index(17, func(): 
		dialogue(17, 0)
		
		key.visible = false
		textBox.visible = false
		can_interact = false
		
		switch_dialogue_option(1)
		clear_action_index()
		secondary_action_index()
	)

func secondary_action_index():
	add_action_to_index(2, func(): 
		if player_reference.coins >= 10:
			player_reference.coins -= 10
			player_reference.weapon = small_sword
			dialogue(2, 6)
		else:
			dialogue(2, 3)
	)
	add_action_to_index(5, func(): 
		dialogue(5, -1)
		
		key.visible = false
		textBox.visible = false
		can_interact = false
	)
	add_action_to_index(13, func():
		dialogue(13, 0)
		key.visible = false
		textBox.visible = false
		can_interact = false
	)
	
