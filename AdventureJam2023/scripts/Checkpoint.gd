extends Area2D


func reset_checkpoint() -> void:
	remove_from_group(&"CurrentCheckpoint")


# Body can only be the player because mask is player only
func _on_player_entered(_player: Node2D) -> void:
	get_tree().call_group(&"CurrentCheckpoint", &"reset_checkpoint")
	add_to_group(&"CurrentCheckpoint")
