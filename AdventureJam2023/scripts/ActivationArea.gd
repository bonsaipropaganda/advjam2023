extends Area2D
"""
A node that activates it's parent if and only if it contains the player.
"""

@onready var parent: Node = get_parent()

var active: bool = false:
	set(value):
		active = value
		
#		if !is_inside_tree():
#			return
		
		if active:
			parent.process_mode = Node.PROCESS_MODE_INHERIT
		else:
			parent.process_mode = Node.PROCESS_MODE_DISABLED


func _ready() -> void:
	collision_mask = 0
	set_collision_mask_value(2, true)
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	body_entered.connect(_on_body_enter)
	body_exited.connect(_on_body_exit)
	
	await get_tree().physics_frame
	await get_tree().process_frame
	active = has_overlapping_bodies()


func _on_body_enter(_body: Node2D) -> void:
	active = true


func _on_body_exit(_body: Node2D) -> void:
	active = false
