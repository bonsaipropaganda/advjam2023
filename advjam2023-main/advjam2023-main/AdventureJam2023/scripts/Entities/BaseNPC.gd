extends NPC

func set_action_index():
	add_action_to_index(0, func(): 
		dialogue(0, 1)
		pass
	)
