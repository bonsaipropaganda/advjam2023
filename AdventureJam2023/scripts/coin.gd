extends Node2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("get_coin"):
		body.get_coin(1)
		%AnimationPlayer.play("Fade")


func play_sfx():
	%sfx.play()
	%sfx.pitch_scale = randf_range(0.9, 1.1)
