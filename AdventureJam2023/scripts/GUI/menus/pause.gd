extends Node

func _on_button_button_down():
	get_tree().paused = false
	owner.get_node("GUI/pause").visible = false

func _on_button_2_button_down():
	get_tree().quit()
