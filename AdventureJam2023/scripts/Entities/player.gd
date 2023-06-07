extends CharacterBody2D

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
var coins: int = 0

var paused: bool = false


func _ready() -> void:
	qte.qte_done.connect(_on_qte_done)


######################################################################################
#---------------------------------the main stuff--------------------------------------
######################################################################################
func _physics_process(delta):
	#first getting alllll the inputs from the player
	input_direction = Input.get_vector(
		"keyboard_left", "keyboard_right", "keyboard_up", "keyboard_down"
	)
	is_slashing = Input.is_action_just_pressed("keyboard_space")

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
	velocity = _input_direction.normalized() * speed
	move_and_slide()


#is da player slashing???. bring the slash thingy from the edge of the map and make it visible
func slash(is_slashing: bool) -> bool:
	#is the player slashing?. and the qte is not being used?. use it!!!
	if is_slashing && !qte.is_in_progress() && !qte.is_on_cooldown():
		qte.init_qte()
		return true
	return false


func _on_qte_done(is_success: bool):
	#yayy!!!, is the QTE is successful, reset it. and animate stuffs
	slash_sound.play()

	# zoom out to default zoom position
	var camera: PlayerCamera = get_viewport().get_camera_2d()
	camera.reset_zoom()
	
	hud.regen_qte(qte.cooldown_time) # Reset qte timer
	
	if is_success:  # show slash animation on qte success, aoe attack
		camera.start_shaking(2, 0.018, 0.15)
		swordSlash.visible = true
		swordSlash.attack_all(weapon.group_damage)
		qte.reset()
		await animationTree.animation_finished
		swordSlash.visible = false
	else:  # hide slash animation on qte fail, single target attack
		swordSlash.visible = false
		swordSlash.attack_nearest(weapon.single_damage)
		playback.travel("Idle", false)


func walk_animation(_input_direction) -> void:
	if qte.is_in_progress() or is_slashing:
		return
	if _input_direction.x != 0 or _input_direction.y != 0:
		animationTree.set("parameters/Walk/blend_position", _input_direction.normalized())
		animationTree.set("parameters/Idle/blend_position", _input_direction.normalized())


func slash_animation(is_slashing: bool) -> void:
	if is_slashing:
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
	if health == 0:
		die()


func update_coins():
	hud.set_coin_count(coins)


func _on_regen_timer_timeout():
	if health < 100:
		health += 20
		if health > 100:
			health = 100
	if health == 0:
		health = 0


func die():
	if health <= 0:
		get_tree().paused = true
		deathScreen.visible = true


func _on_area_2d_body_entered(_body):
	health -= 10


func get_coin(amount: int):
	coins += amount
