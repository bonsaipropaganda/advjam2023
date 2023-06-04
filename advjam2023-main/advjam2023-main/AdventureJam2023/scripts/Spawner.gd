##supposed to make a procedural spawner
extends Node

@onready var timer = $Timer
var zombie = preload("res://scenes/Entities/zombie.tscn")
var spawn_pos = null

## Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	spawn_pos = $Spawner.get_children()
	


func _on_timer_timeout():
	spawn()#calls the spawning function after a time period

func spawn():#the spawn function
	var index = randi() % spawn_pos.size()
	var zom = zombie.instantiate()
	zom.global_position= spawn_pos[index].global_position
	add_child(zom)
