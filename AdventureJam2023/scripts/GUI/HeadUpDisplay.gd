extends Control


var health_tween: Tween
var qte_timer_tween: Tween


func _ready() -> void:
	set_coin_count(0)
	set_health(1, 1)
	set_qte_timer(1, 1)


func set_coin_count(count: int) -> void:
	%CoinLabel.text = "x {count}".format({&"count": count})


func set_health(health: float, max_health: float, anim_time: float = 0.2) -> void:
	var value: float = (health / max_health) * 100.0
	%Health.value = value
	
	if health_tween:
		health_tween.kill()
	health_tween = create_tween()
	health_tween.tween_property(%HealthUnder, ^"value", value, anim_time)


# Yes there are other (waaaay better) ways to write this
func set_qte_timer(time: float, total_time: float, anim_time: float = 0.0) -> void:
	# mhh with twines it could get desync with real value if more mechanics are added... (unlikely)
	var value: float = (time / total_time) * 100.0
	%QteTimer.value = value
	
	if qte_timer_tween:
		qte_timer_tween.kill()
	qte_timer_tween = create_tween()
	qte_timer_tween.tween_property(%QteTimerUnder, ^"value", value, anim_time)
