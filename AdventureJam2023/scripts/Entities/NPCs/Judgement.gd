extends NPC


func _action(act_name: String) -> void:
	match act_name:
		"look_up":
			SpriteAnimator.play("look_up")
		"look_down":
			SpriteAnimator.play("look_down")
		"play_default_anim":
			await(SpriteAnimator.animation_finished)
			SpriteAnimator.play("default")


func _on_sword_sold() -> void:
	queue_free()
