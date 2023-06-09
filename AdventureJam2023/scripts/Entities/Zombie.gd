extends CharacterBody2D

class_name Zombie

@export var max_hp = 3

@onready var player: Object = get_tree().get_nodes_in_group("Player")[0]
@onready var alive = true
@onready var hp: int = max_hp
@onready var anim: AnimationPlayer = $AnimationPlayer

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@export_range(0.0, 1.0) var drop_chance: float = 0.3
@export var coin_scene: PackedScene

var speed: float = 400
var direction: Vector2 = Vector2(-0.5, 0.0)

# Wander stuff
var wander_timer: float = 3

# Chase stuff
var chase_distance: float = 80
var is_chasing: bool = false


func _process(delta):
	if alive:
		move(delta)
		walk_animation()


func move(delta: float) -> void:
	var distance_from_player: float = player.global_position.distance_to(global_position)

	if distance_from_player > chase_distance:
		direction = wander(delta)
	if distance_from_player < chase_distance or is_chasing:
		is_chasing = true
		speed = 700
		direction = chase()

	velocity = direction * speed * delta
	move_and_slide()


func wander(delta: float) -> Vector2:
	if wander_timer < 0:
		var random_angle: float = randf_range(0, 2 * PI)
		wander_timer = randf_range(1, 2)
		return Vector2(cos(random_angle), sin(random_angle))
	wander_timer -= delta
	return direction


func chase() -> Vector2:
	return (player.global_position - global_position).normalized()


func walk_animation() -> void:
	$AnimatedSprite2D.flip_h = velocity.x < 0
	if abs(direction.y) >= abs(direction.x):
		if direction.y < 0:
			$AnimatedSprite2D.set_animation("walk_up")
		else:
			$AnimatedSprite2D.set_animation("walk_down")
	else:
		$AnimatedSprite2D.set_animation("walk_side")


# For all the death stuff!!!
func take_damage(damage: int) -> void:
	if not alive:
		return
	blink()
	hp = clamp(hp-damage, 0, max_hp)
	if hp <= 0:
		die()


func blink() -> void:
	material.set_shader_parameter("is_blinking", true)
	await get_tree().create_timer(0.7).timeout
	material.set_shader_parameter("is_blinking", false)


func die() -> void:
	alive = false
	is_chasing = false
	match $AnimatedSprite2D.animation:
		"idle_down", "walk_down":
			$AnimatedSprite2D.set_animation("death_down")

		"idle_up", "walk_up":
			$AnimatedSprite2D.set_animation("death_up")

		"idle_side", "walk_side":
			$AnimatedSprite2D.set_animation("death_side")
	collision_layer = 0
	
	var despawn_timer := get_tree().create_timer(4.0) # Despawn dead zombies
	despawn_timer.timeout.connect(queue_free)

	if randf() < drop_chance:
		drop_coin()


func drop_coin():
	var coin = coin_scene.instantiate()
	coin.global_position = global_position
	get_tree().current_scene.add_child(coin)
