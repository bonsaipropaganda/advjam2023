extends CharacterBody2D

class_name Boss

signal boss_defeated

@export var max_hp = 15

@onready var player: Object = get_tree().get_nodes_in_group("Player")[0]
@onready var alive = true
@onready var hp: int = max_hp

@onready var sprite: Sprite2D = $AnimatedSprite2D

@export_range(0.0, 1.0) var drop_chance: float = 0.3
@export var coin_scene: PackedScene
@export var splash: PackedScene

var speed: float = 1600
var direction: Vector2 = Vector2(-0.5, 0.0)

# Wander stuff
var wander_timer: float = 3

# Chase stuff
var chase_distance: float = 80
var is_chasing: bool = false
# this is used to make the splash effect happen every other time
var just_splashed = false


func _process(delta):
	if alive:
		move(delta)
		$AnimatedSprite2D.flip_h = velocity.x <= 0
		

func move(delta: float) -> void:
	var distance_from_player: float = player.global_position.distance_to(global_position)

	if distance_from_player > chase_distance:
		direction = wander(delta)
	if distance_from_player < chase_distance or is_chasing:
		is_chasing = true
		speed = 2200
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

# For all the death stuff!!!
func take_damage(damage: int) -> void:
	if not alive:
		return
	blink()
	%hit.play()
	%hit.pitch_scale = randf_range(0.9, 1.1)
	hp = clamp(hp-damage, 0, max_hp)
	if hp <= 0:
		die()


func blink() -> void:
	%AnimatedSprite2D.modulate = Color.BLACK
	await get_tree().create_timer(0.1).timeout
	%AnimatedSprite2D.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	%AnimatedSprite2D.modulate = Color.BLACK
	await get_tree().create_timer(0.1).timeout
	%AnimatedSprite2D.modulate = Color.RED


func die() -> void:
	alive = false
	is_chasing = false
	%diesfx.play()
	%diesfx.pitch_scale = randf_range(0.9, 1.1)
	%AnimationPlayer.play("die")
	emit_signal("boss_defeated")
	collision_layer = 0
	
	var despawn_timer := get_tree().create_timer(4.0) # Despawn dead zombies
	despawn_timer.timeout.connect(queue_free)

	if randf() < drop_chance:
		drop_coin()


func drop_coin():
	var coin = coin_scene.instantiate()
	coin.global_position = global_position
	get_tree().current_scene.add_child(coin)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	%FootstepSound.play()
	%FootstepSound.pitch_scale = randf_range(0.9, 1.1)


func spawn_splash():
	var _splash = splash.instantiate()
	if just_splashed == false:
		add_child(_splash)
		just_splashed = true
	else: just_splashed = false
	pass
