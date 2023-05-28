extends Node2D


func _on_animation_animation_looped():
	$Animation.stop()
	set_visible(false)
	position = Vector2(-1000, -1000)
