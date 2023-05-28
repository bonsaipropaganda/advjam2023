extends Node2D


var zombie_pool:Array
func _ready():
	for i in range(get_child_count()):
		zombie_pool.append(get_child(i))


func _physics_process(delta):
	
	
	pass
