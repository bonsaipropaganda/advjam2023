extends Control


func _ready() -> void:
	set_coin_count(0)
	set_health(1, 1)
	set_qte_timer(1, 1)


func set_coin_count(count: int) -> void:
	%CoinLabel.text = "x {count}".format({&"count": count})


func set_health(health: float, max_health: float) -> void:
	%Health.value = (health / max_health) * 100.0


func set_qte_timer(time: float, total_time: float) -> void:
	%Health.value = (1.0 - time / total_time) * 100.0
