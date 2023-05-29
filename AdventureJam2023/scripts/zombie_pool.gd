extends Node2D


var zombie_pool: Array[Zombie]
func _ready():
		zombie_pool.append_array(get_children())


func _physics_process(delta):
	
	if randi_range(0,35) == 1 and true: # removes Zombie husks over time
		
		await get_tree().create_timer(1).timeout
		var zombie : Zombie = zombie_pool.pick_random()
		if not zombie.alive:
			zombie_pool.erase(zombie)
			zombie.queue_free() 
			
	if randi_range(0,100) == 1 and false: # sorta spawns extra Zombies
		
		var zombie = zombie_pool.pick_random()
		var newZombie = load("res://scenes/zombie.tscn").instantiate()
		zombie_pool.append(newZombie)
		add_child(newZombie)
		
	if randi_range(0,100) == 1:
		pass
