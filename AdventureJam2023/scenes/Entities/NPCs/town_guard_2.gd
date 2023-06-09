extends NPC

func _on_boss_boss_defeated() -> void:
	self.current_dialogue = "BossDefeated"
