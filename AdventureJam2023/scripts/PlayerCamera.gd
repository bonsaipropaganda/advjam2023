class_name PlayerCamera
extends Camera2D

@export var default_zoom: float = 4.0

var zoom_tween: Tween
var shake_tween: Tween # TODO


func _ready() -> void:
	zoom = Vector2(default_zoom, default_zoom)


# Animates zooming in/out (-1 resets to default zoom)
func change_zoom(new_zoom: float = -1, time: float = 0.2) -> void:
	if zoom_tween:
		zoom_tween.kill()
	if new_zoom == -1:
		new_zoom = default_zoom
	
	zoom_tween = create_tween()
	zoom_tween.tween_property(self, ^"zoom", Vector2(new_zoom, new_zoom), time)


func reset_zoom() -> void:
	change_zoom()
