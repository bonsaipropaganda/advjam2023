extends NPC

func set_action_index():
	add_action_to_index(0, func(): 
		dialogue(0, 1)
		SpriteAnimator.play("look_up")
	)
	add_action_to_index(13, func():
		dialogue(13, 14)
		# Character animation
		SpriteAnimator.play("look_down")
		switch_dialogue_option(1)
		await(SpriteAnimator.animation_finished)
		SpriteAnimator.play("default")
		clear_action_index()
	)
