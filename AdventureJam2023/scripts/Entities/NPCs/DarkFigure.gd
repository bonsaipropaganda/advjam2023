extends NPC


func _on_dialogue_finished(dialogue_name: String) -> void:
	if dialogue_name == "Meeting":
		key.visible = false
		$InteractionRange.monitoring = false
		SpriteAnimator.play("disappear")
		get_parent().get_node("ForceField").get_node("AnimatedSprite2D").play("disappear")
		$AudioStreamPlayer2D.play(0)
		await SpriteAnimator.animation_finished
		get_parent().get_node("ForceField").queue_free()
		$AudioStreamPlayer2D.stop()
		queue_free() # TODO ?
