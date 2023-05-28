extends Node2D


func _on_animation_animation_looped():#after a loop, stop the animation
	$Animation.stop()
	set_visible(false)
	position = Vector2(-1000, -1000)#move the sword slash to the edge of the map.
