extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_boss_boss_defeated() -> void:
	await get_tree().create_timer(4).timeout
	self.visible = true
	$AnimationPlayer.play("fade")
	await get_tree().create_timer(16).timeout
	queue_free()
