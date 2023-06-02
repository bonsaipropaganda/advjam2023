extends CharacterBody2D

class_name Zombie

@onready var player: Object = get_tree().get_nodes_in_group("Player")[0]

@onready var alive = true

var speed: float = 400
var direction: Vector2 = Vector2(-0.5, 0.0)

#wander stuff
var wander_timer: float = 3

#chase stuff
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


#for all the death stuff!!!
func _on_area_2d_area_entered(area):
	if "SwordSlash" in area.name and alive:
		print("OUCH")
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
		set_process(false)

#
#func _on_animated_sprite_2d_animation_finished():
#	$AnimatedSprite2D.pause()
