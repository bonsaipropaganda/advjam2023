extends NPC

var talked = false
signal sold

func _on_dialogue_finished(dialogue: String) -> void:
		talked = true
		if dialogue == "CheckIn":
			pass

#func _process(delta: float) -> void:
#	if talked == true:
#		self.current_dialogue = "CheckIn"

func _action(act_name: String) -> void:
	match act_name:
		"check_in":
			if player_reference.coins >= 5:
				player_reference.coins -= 5
				continue_dialogue("Bought")
			else:
				continue_dialogue("NotEnoughMoney")
