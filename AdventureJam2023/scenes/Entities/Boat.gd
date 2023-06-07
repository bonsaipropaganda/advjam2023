extends Node2D

var timer :float = 0
@onready var best_boat = $Boat
@onready var boat_sprite = $Boat/BestBoat
@onready var target = $Boat/BestBoat/target
@onready var key = $Boat/InteractionRange/Key
@onready var animation_player = $AnimationPlayer
@onready var color_rect = $Boat/ColorRect
@onready var remote_transform: RemoteTransform2D = $Boat/RemoteTransform2D

var flipped :bool = false
var is_travelling :bool = false
var can_interact :bool = false
@onready var player = get_tree().get_nodes_in_group("Player")[0]

func _physics_process(_delta):
	if can_interact and Input.is_action_just_pressed("Interact") and not is_travelling:
		start_travel()


func _process(delta):	# Animates the boat movement using sin waves
	timer += delta/2
	if is_travelling:
		timer+=delta # Speedup animation a little while traveling
	boat_sprite.rotation_degrees = 0 + (sin(timer)*5)
	boat_sprite.position.y = 0 + (sin(timer*2)*3)
	
	key.visible = can_interact
	if flipped:
		key.scale.x = -1
	else:
		key.scale.x = 1


func _on_interaction_range_body_entered(body):
	if body.name == "Player":
		can_interact = true


# this is to exit the interaction
func _on_interaction_range_body_exited(body):
	if body.name == "Player":
		can_interact = false


func start_travel() -> void:
	is_travelling = true
	if flipped:
		animation_player.play_backwards("new_animation")
	else:
		animation_player.play("new_animation")
	flipped = !flipped
	player.get_node("HitBox").disabled = true
	remote_transform.remote_path = player.get_path()
	player.global_position = target.global_position
	player.show_behind_parent = true
	player.paused = true



# HORRIBLE way to move the player and return him
# Edit: I think I made it a bit better !
func _on_animation_player_animation_finished(_anim_name):
	remote_transform.remote_path = ""
	player.global_position = target.global_position
	is_travelling = false
	player.get_node("HitBox").disabled = false
	player.show_behind_parent = false
	player.paused = false
