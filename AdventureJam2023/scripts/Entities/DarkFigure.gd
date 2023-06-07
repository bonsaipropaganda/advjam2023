extends NPC

func set_action_index():
	add_action_to_index(11, func(): 
		key.visible = false
		textBox.visible = false
		$CollisionShape2D.disabled = true
		SpriteAnimator.play("disappear")
		get_parent().get_node("ForceField").get_node("AnimatedSprite2D").play("disappear")
		$AudioStreamPlayer2D.play(0)
		await SpriteAnimator.animation_finished
		get_parent().get_node("ForceField").queue_free()
		await $AudioStreamPlayer2D.finished
		queue_free() # FIXME: idk why, this is never called
	)
