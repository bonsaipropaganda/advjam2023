extends StaticBody2D

var sprites := [preload("res://sprites/Tents/tent1.png"), preload("res://sprites/Tents/tent2.png"), preload("res://sprites/Tents/tent3.png")]
func _ready():	# If I don't know what to choose, then lets let Godot do it.
	randomize()
	$Tent0.texture = sprites.pick_random()
