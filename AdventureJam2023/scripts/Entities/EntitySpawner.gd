@tool
extends Node
"""
A node that will try to spawn entities on Marker2D child nodes at a given time interval
"""


@export var spawn_time: float = 10.0:
	set(value):
		spawn_time = value
		if !Engine.is_editor_hint() && is_inside_tree():
			$Timer.wait_time = value

@export_file("*.tscn") var entity: String:
	set(value):
		entity = value
		update_configuration_warnings()

@export var max_entity_count: int = 10

var current_entity_count: int = 0

var Entity: PackedScene


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	$Timer.wait_time = spawn_time
	
	Entity = ResourceLoader.load(entity, "PackedScene")


func spawn() -> void:
	# Don't spawn if there are too many entities managed by this spawner
	if current_entity_count >= max_entity_count:
		return
	
	var spawn_pos := get_spawn_positions()
	var index := randi() % spawn_pos.size() # Choose random position
	
	# Add entity to scene
	var e: Node2D = Entity.instantiate()
	e.global_position = spawn_pos[index].global_position
	add_child(e)
	
	# Keep count
	current_entity_count += 1
	e.tree_exited.connect(func():
		current_entity_count -= 1
	)
	


func get_spawn_positions() -> Array[Marker2D]:
	var pos: Array[Marker2D] = []
	for c in get_children():
		if c is Marker2D:
			pos.push_back(c)
	return pos


func _get_configuration_warnings() -> PackedStringArray:
	var warn := PackedStringArray()
	if get_spawn_positions().is_empty():
		warn.push_back("Spawner has no spawning positions (add Marker2D child to add a spawn pos)")
	if entity.is_empty():
		warn.push_back("No entity to spawn")
	return warn
