class_name PlayerCamera
extends Camera2D

@export var default_zoom: float = 4.0

var zoom_tween: Tween

var shake_intensity: float # Distance the camera can travel while shaking
var shake_interval : float
var shaking        : bool = false
var shake_tween: Tween


func _ready() -> void:
	zoom = Vector2(default_zoom, default_zoom)


func _process(_delta: float) -> void:
	if shaking && !shake_tween.is_running():
		_shake()


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


func start_shaking(intensity: float, interval: float, time: float = -1.0) -> void:
	shaking = true
	shake_intensity = intensity
	shake_interval = interval
	_shake()
	
	if time >= 0.0:
		get_tree().create_timer(time, true, false, true).timeout.connect(stop_shaking)


func stop_shaking() -> void:
	if shake_tween:
		shake_tween.kill()
	shaking = false
	shake_tween = create_tween()
	shake_tween.tween_property(self, ^"offset", Vector2.ZERO, shake_interval)


func _shake() -> void:
	if shake_tween:
		shake_tween.kill()
	shake_tween = create_tween()
	var pos := shake_intensity * Vector2(randf_range(-1, 1), randf_range(-1, 1))
	shake_tween.tween_property(self, ^"offset", pos, shake_interval)
