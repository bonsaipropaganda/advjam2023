extends Node2D
@onready var test_sound = $Control/SoundVolume/TestSound


func _ready(): # Setup default sound values
	_on_music_volume_value_changed($Control/MusicVolume.value)
	_on_sound_volume_value_changed($Control/SoundVolume.value)


func _on_texture_button_button_down():#Play
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_texture_button_3_button_down():#credits
	get_tree().change_scene_to_file("res://scenes/GUI/menus/credits.tscn")


func _on_texture_button_2_button_down():# quit
	get_tree().quit()


func _on_music_volume_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))


func _on_sound_volume_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sounds"), linear_to_db(value))
	test_sound.play()
