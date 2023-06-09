extends CharacterBody2D
class_name Player

@export var speed := 100.0

@export var weapon: WeaponRes

@export var swing_animation: PackedScene

@onready var swinging := false
@onready var qte = $qte
@onready var animationTree := $AnimatorTree
@onready var swordSlash = $SwordSlash
@onready var playback: AnimationNodeStateMachinePlayback = animationTree.get("parameters/playback")

@onready var deathScreen = owner.get_node("GUI/DeathScreen")
@onready var hud = owner.get_node("GUI/HUD")
@export var slash_sound: AudioStreamPlayer


var input_direction: Vector2
var is_slashing: bool
var health: int = 100
var can_get_hit := true
var coins: int = 5
var can_move := true
@export var can_do_stuff := false

var paused: bool = false


func _ready() -> void:
	qte.qte_done.connect(_on_qte_done)


######################################################################################
#---------------------------------the main stuff--------------------------------------
######################################################################################
func _physics_process(delta):
	if not can_do_stuff:
		input_direction = Vector2.ZERO
		return
		
	#first getting alllll the inputs from the player
	input_direction = Input.get_vector(
		"keyboard_left",
		"keyboard_right",
		"keyboard_up",
		"keyboard_down"
	)
	
	is_slashing = (
		Input.is_action_just_pressed("keyboard_space")
	)

	#a tiny function to make the player move!!!
	move(input_direction, delta, is_slashing)
	is_slashing = slash(is_slashing)  #a tiny function that communicates with the QTE stuff, and do the QTE game

	#ANIMATION FUNCIONS
	walk_animation(input_direction)  #this function makes does all of the player "Walk animation"
	slash_animation(is_slashing)  #this one's for the slash animations

	update_health()
	update_coins()


func move(_input_direction: Vector2, _delta: float, _is_slashing: bool) -> void:
	if qte.is_in_progress() or paused:
		return  #is the player slashing?. then don't move.
	if can_move:
		velocity = lerp(velocity, _input_direction.normalized() * speed, _delta * 15)
	else:
		velocity = Vector2.ZERO
	move_and_slide()


#is da player slashing???. bring the slash thingy from the edge of the map and make it visible
func slash(_is_slashing: bool) -> bool:
	#is the player slashing?. and the qte is not being used?. use it!!!
	if _is_slashing && !qte.is_in_progress() && !qte.is_on_cooldown():
		qte.init_qte()
		can_move = false
		return true
	return false


func _on_qte_done(is_success: bool):
	#yayy!!!, is the QTE is successful, reset it. and animate stuffs

	# zoom out to default zoom position
	var camera: PlayerCamera = get_viewport().get_camera_2d()
	camera.reset_zoom()
	
	hud.regen_qte(qte.cooldown_time) # Reset qte timer
	
	if is_success:  # show slash animation on qte success, aoe attack
		slash_sound.play()
		slash_sound.pitch_scale = randf_range(0.9, 1.1)
		slash_sound.volume_db = -10
		camera.start_shaking(2, 0.018, 0.15)
		swordSlash.visible = true
		swordSlash.attack_all(weapon.group_damage)
		qte.reset()
		await animationTree.animation_finished
		swordSlash.visible = false
	else:  # hide slash animation on qte fail, single target attack
		slash_sound.play()
		slash_sound.pitch_scale = randf_range(0.9, 1.1)
		slash_sound.volume_db = -25
		swordSlash.visible = false
		swordSlash.attack_nearest(weapon.single_damage)
		playback.travel("Idle", false)


func walk_animation(_input_direction) -> void:
	if qte.is_in_progress() or is_slashing:
		return
	if _input_direction.x != 0 or _input_direction.y != 0:
		animationTree.set("parameters/Walk/blend_position", _input_direction.normalized())
		animationTree.set("parameters/Idle/blend_position", _input_direction.normalized())


func slash_animation(_is_slashing: bool) -> void:
	if _is_slashing:
		%PreSlashSound.play()
		%PreSlashSound.pitch_scale = randf_range(0.9, 1.1)
		var camera: PlayerCamera = get_viewport().get_camera_2d()
		camera.change_zoom(camera.default_zoom * 3.0, qte.time)
		hud.use_qte(qte.time * qte.time_factor)
		# start slash animation
		playback.travel("Mele")
	# attack direction is the latest move direction that is not zero,
	# and player can't change attack direction while attacking
	if input_direction != Vector2.ZERO and playback.get_current_node() != "Mele":
		animationTree.set("parameters/Mele/blend_position", input_direction.normalized())


func update_health():
	hud.set_health(health, 100.0)


func update_coins():
	hud.set_coin_count(coins)


func _on_regen_timer_timeout():
	if health < 100:
		health += 5
		if health > 100:
			health = 100
	if health == 0:
		health = 0


func die():
	self.hide()
	get_tree().paused = true
	deathScreen.visible = true
	deathScreen.sfx.play()


func take_damage():
	health -= 25
	%TakeDamageSound.play()
	%TakeDamageSound.pitch_scale = randf_range(0.9, 1.1)
	blink()
	if health <= 0:
		die()
		update_health()


func blink() -> void:
	%PlayerSprite.modulate = Color.RED
	await get_tree().create_timer(0.2).timeout
	%PlayerSprite.modulate = Color.WHITE
	await get_tree().create_timer(0.2).timeout
	%PlayerSprite.modulate = Color.RED
	await get_tree().create_timer(0.2).timeout
	%PlayerSprite.modulate = Color.WHITE


func get_coin(amount: int):
	coins += amount


func respawn(checkpoint: Node2D) -> void:
	health = 100
	global_position = checkpoint.global_position
	self.show()


func _on_health_checker_body_entered(body: Node2D) -> void:
	if can_get_hit:
		if body is Slime or body is Splash or body is Zombie:
			take_damage()
			can_get_hit = false
			await get_tree().create_timer(0.5).timeout
			can_get_hit = true


func _on_button_button_down() -> void:
	coins = 0


func _on_town_guard_dialogue_finished(_dialogue_name) -> void:
	can_do_stuff = true


func _on_judgement_dialogue_finished(_dialogue_name) -> void:
	can_do_stuff = true


func _on_dark_figure_dialogue_finished(_dialogue_name) -> void:
	await get_tree().create_timer(1.5).timeout
	can_do_stuff = true


func _on_sword_shop_dialogue_finished(_dialogue_name) -> void:
	can_do_stuff = true


func _on_health_checker_area_entered(area: Area2D) -> void:
	if can_get_hit:
		if area is Splash:
			take_damage()
			can_get_hit = false
			await get_tree().create_timer(0.5).timeout
			can_get_hit = true


func _on_village_elder_dialogue_finished(dialogue_name) -> void:
	can_do_stuff = true


func _on_potion_seller_dialogue_finished(dialogue_name) -> void:
	can_do_stuff = true
