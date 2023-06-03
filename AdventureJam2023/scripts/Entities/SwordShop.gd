extends NPC

@export var small_sword: WeaponRes

func set_action_index():
	add_action_to_index(5, func(): 
		if player_reference.coins >= 10:
			player_reference.coins -= 10
			player_reference.weapon = small_sword
			dialogue(5, 10)
		else:
			dialogue(5, 6)
	)
	add_action_to_index(8, func(): 
		# This is the end of one dialogue path, so just jump to the last index.
		# 16 is the last index that has a dialogue option, so 17 will be the one to close the dialogue box
		dialogue(8, 17)
	)
	add_action_to_index(17, func(): 
		# End of the dialogue_action file
		switch_dialogue_option(1)
		clear_action_index(second_action_index)
		close_dialogue()
	)

# additional way to set items in the dialogue_action_index
var second_action_index = {
	2: func(): 
		if player_reference.coins >= 10:
			player_reference.coins -= 10
			player_reference.weapon = small_sword
			dialogue(2, 6)
		else:
			dialogue(2, 3),
	5: func(): 
		# dialogue index 5 should jump to the end, since it's the end of a path
		# jumping to 15 instead of 14 because the path that ends on 14 is a special
		#  dialogue case, and the NPC class naturally resets the dialogue index
		#  at any value greater than the json file length
		dialogue(5, 15),
	14: func():
		switch_dialogue_option(2)
		clear_action_index()
		close_dialogue()
}
