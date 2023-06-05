extends Node2D

func _on_texture_button_button_down():#Play
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_texture_button_3_button_down():#credits
	get_tree().change_scene_to_file("res://scenes/GUI/menus/credits.tscn")

func _on_texture_button_2_button_down():# quit
	get_tree().quit()
