extends Node2D

@onready var sfx = $sfx

func _on_button_button_down():
	get_tree().paused = false
	visible = false
	
	var checkpoint: Node2D = get_tree().get_first_node_in_group(&"CurrentCheckpoint")
	if checkpoint:
		var player: Node2D = get_tree().get_first_node_in_group(&"Player")
		player.respawn(checkpoint)
	else:
		get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_button_2_button_down():
	get_tree().change_scene_to_file("res://scenes/GUI/menus/main_menu.tscn")
