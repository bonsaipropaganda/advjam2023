extends Node2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("get_coin"):
		body.get_coin(1)
		queue_free()
