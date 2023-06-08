extends Control


var pause: bool = false:
	set(value):
		pause = value
		
		if is_inside_tree():
			get_tree().paused = pause
			visible = pause


func _ready() -> void:
	get_tree().paused = pause
	visible = pause


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		pause = !pause


func _on_resume() -> void:
	pause = false


func _on_quit() -> void:
	get_tree().change_scene_to_file("res://scenes/GUI/menus/main_menu.tscn")

