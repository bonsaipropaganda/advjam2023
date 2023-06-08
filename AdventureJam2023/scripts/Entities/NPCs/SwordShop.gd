extends NPC

@export var small_sword: WeaponRes


signal sold() # So that judgement knows the sword has been taken


func _action(act_name: String) -> void:
	match act_name:
		"check_in":
			if player_reference.coins >= 10:
				player_reference.coins -= 10
				player_reference.weapon = small_sword
				continue_dialogue("Bought")
				sold.emit()
			else:
				continue_dialogue("NotEnoughMoney")


func _on_dialogue_finished(dialogue: String) -> void:
	if dialogue == "Bought":
		queue_free()


func _on_sold() -> void:
	%GotSword.play()
