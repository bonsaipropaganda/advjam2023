extends Control

@onready var sword = %Sword

var health_tween: Tween
var qte_timer_tween: Tween


func _ready() -> void:
	visible = true
	
	set_coin_count(0)
	set_health(1, 1)
	%QteTimer.value = 100.0
	%QteTimerUnder.value = 100.0


func set_coin_count(count: int) -> void:
	%CoinLabel.text = "x {count}".format({&"count": count})


func set_health(health: float, max_health: float, anim_time: float = 0.2) -> void:
	var value: float = (health / max_health) * 100.0
	%Health.value = value
	
	if health_tween:
		health_tween.kill()
	health_tween = create_tween()
	health_tween.tween_property(%HealthUnder, ^"value", value, anim_time)


func use_qte(time: float) -> void:
	%QteTimer.value = 0.0
	%QteTimerUnder.value = 100.0
	
	if qte_timer_tween:
		qte_timer_tween.kill()
	qte_timer_tween = create_tween()
	qte_timer_tween.tween_property(%QteTimerUnder, ^"value", 0.0, time)


# Yes there are other (waaaay better) ways to write this
func regen_qte(time: float = 0.0) -> void:
	# mhh with twines it could get desync with real value if more mechanics are added... (unlikely)
	%QteTimerUnder.value = 0.0
	%QteTimer.value = 0.0
	
	if qte_timer_tween:
		qte_timer_tween.kill()
	qte_timer_tween = create_tween()
	qte_timer_tween.tween_property(%QteTimer, ^"value", 100.0, time)
	


func _on_sword_shop_sold() -> void:
	sword.show()


func _on_button_button_down() -> void:
	set_coin_count(0)
