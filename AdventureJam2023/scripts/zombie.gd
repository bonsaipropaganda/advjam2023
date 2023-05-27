extends AnimatableBody2D

@onready var alive = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_area_2d_area_entered(area):
	if area.is_in_group("attack") and alive:
		alive = false
		match $AnimatedSprite2D.animation:
			"idle_down":
				$AnimatedSprite2D.set_animation("death_down")
			"walk_down":
				$AnimatedSprite2D.set_animation("death_down")
			
			"idle_up":
				$AnimatedSprite2D.set_animation("death_up")
			"walk_up":
				$AnimatedSprite2D.set_animation("death_up")
			
			"idle_side":
				$AnimatedSprite2D.set_animation("death_side")
			"walk_side":
				$AnimatedSprite2D.set_animation("death_side")



func _on_animated_sprite_2d_animation_finished():
	$AnimatedSprite2D.pause()
