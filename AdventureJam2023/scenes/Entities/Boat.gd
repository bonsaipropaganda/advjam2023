extends Node2D

var timer :float = 0
@onready var best_boat = $BestBoat

func _process(delta):	# Animates the boat movement using sin waves
	timer += delta/2
	best_boat.rotation_degrees = 0 + (sin(timer)*5)
	best_boat.position.y = 0 + (sin(timer*2)*3)
