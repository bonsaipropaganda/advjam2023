extends Node2D
@onready var test_sound = %TestSound

func _ready(): # Setup default sound values
	_on_music_volume_value_changed($Control/MusicVolume.value)
	_on_sound_volume_value_changed($Control/SoundVolume.value)
	get_tree().paused = false


func _on_play_button_down():#Play
	test_sound.play()
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_credits_button_down():#credits
	test_sound.play()
	$Credits.show()


func _on_quit_button_down():# quit
	get_tree().quit()


func _on_music_volume_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value * 0.05))


func _on_sound_volume_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sounds"), linear_to_db(value * 0.05))
	test_sound.play()


func _on_fullscreen_item_selected(index: int) -> void:
	if index == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	if index == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
