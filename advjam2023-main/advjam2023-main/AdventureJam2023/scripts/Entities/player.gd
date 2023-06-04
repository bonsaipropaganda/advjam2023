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
@export var slash_sound: AudioStreamPlayer

@onready var default_zoom: Vector2 = $Camera2D.zoom

var camera_tween: Tween
var input_direction: Vector2
var is_slashing: bool
var health: int = 100
var coins: int = 0


func _ready() -> void:
	qte.qte_done.connect(_on_qte_done)


func _input(event):
#	pause menu
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused = true
		owner.get_node("GUI/pause").visible = true


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
	slash(is_slashing)  #a tiny function that communicates with the QTE stuff, and do the QTE game

	#ANIMATION FUNCIONS
	walk_animation(input_direction)  #this function makes does all of the player "Walk animation"
	slash_animation(is_slashing)  #this one's for the slash animations

	update_health()
	update_coins()


func move(_input_direction: Vector2, _delta: float, _is_slashing: bool) -> void:
	if qte.is_qte:
		return  #is the player slashing?. then don't move.
	velocity = _input_direction.normalized() * speed
	move_and_slide()


#is da player slashing???. bring the slash thingy from the edge of the map and make it visible
func slash(is_slashing: bool) -> void:
	#is the player slashing?. and the qte is not being used?. use it!!!
	if is_slashing and qte.is_qte == false:
		qte.init_qte()


func _on_qte_done(is_success: bool):
	#yayy!!!, is the QTE is successful, reset it. and animate stuffs
	slash_sound.play()

	# zoom out to default zoom position
	if camera_tween and camera_tween.is_valid():
		camera_tween.kill()
	camera_tween = create_tween()
	camera_tween.tween_property($Camera2D, "zoom", default_zoom, 0.2)

	if is_success:  # show slash animation on qte success, aoe attack
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
	if qte.is_qte or is_slashing:
		return
	if _input_direction.x != 0 or _input_direction.y != 0:
		animationTree.set("parameters/Walk/blend_position", _input_direction.normalized())
		animationTree.set("parameters/Idle/blend_position", _input_direction.normalized())


func slash_animation(is_slashing: bool) -> void:
	if is_slashing:
		# slowly zoom in during qte, a bit exciting ?
		if camera_tween and camera_tween.is_valid():
			camera_tween.kill()
		camera_tween = create_tween()
		camera_tween.tween_property($Camera2D, "zoom", default_zoom * 3.0, qte.qte_timer)
		# start slash animation
		playback.travel("Mele")
	# attack direction is the latest move direction that is not zero,
	# and player can't change attack direction while attacking
	if input_direction != Vector2.ZERO and playback.get_current_node() != "Mele":
		animationTree.set("parameters/Mele/blend_position", input_direction.normalized())


func update_health():
	var healthBar = %HealthBar
	healthBar.value = health
	
	if health >= 100:
		healthBar.visible = false
	else:
		healthBar.visible = true
	if health == 0:
		die()


func update_coins():
	%CoinLabel.text = "x %s" % coins


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


func _on_area_2d_body_entered(body):
	health -= 10


func get_coin(amount: int):
	coins += amount
