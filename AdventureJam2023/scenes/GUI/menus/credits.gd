extends Node2D


func _on_texture_button_button_down():
	get_tree().change_scene_to_file("res://scenes/GUI/menus/main_menu.tscn")
