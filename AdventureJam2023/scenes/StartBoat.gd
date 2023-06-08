extends Node2D

var timer: float

func _process(delta: float) -> void:
	timer += delta/2
	%Sprite.rotation_degrees = 0 + (sin(timer)*5)
	%Sprite.position.y = 0 + (sin(timer*2)*3)
