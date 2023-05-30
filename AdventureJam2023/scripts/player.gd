extends CharacterBody2D

@export var speed:float = 200
@export var swing_animation: PackedScene

#Used to remember the previous direction of player - to prevent changing animation every frame
#Only changes animation when previous input direction does not match current
@onready var previous_input_direction:Vector2 = Vector2(0,0)

@onready var swinging:bool = false
@onready var sword:Area2D = $SwordSlash
@onready var deathScreen = $DeathScreen

var health:int = 100


func _ready():
	sword.set_visible(false)#sets the sword as invisible. duh. don't wanna see it.
	deathScreen.visible = false


######################################################################################
#---------------------------------the main stuff--------------------------------------
######################################################################################
func _physics_process(delta):
	#first getting alllll the inputs from the player as a dictinary
	var user_input:Dictionary = _user_input()
	var input_direction:Vector2 = user_input["input_direction"]
	var _slash:bool = user_input["slash"]
	
	#a tiny function to make the player move!!!
	move(input_direction, delta, _slash)
	slash(_slash)#a tiny function that communicates with the QTE stuff, and do the QTE game

	#ANIMATION FUNCIONS
	walk_animation(input_direction, delta)#this function makes does all of the player "Walk animation"
	slash_animation(_slash, delta)#this one's for the slash animations
	
	#the previous input directionsss.
	previous_input_direction = input_direction
	update_health()
	print(health)
#pause doesnt work
#	if Input.is_action_just_pressed("ui_cancel"):
#		if get_tree().paused == true:
#			get_tree().paused = false
#			$pause.visible = false
#		else:
#			$pause.visible = true
#			get_tree().paused = true
		


#getting all the input from the player!!!
func _user_input() -> Dictionary:
	var input_direction:Vector2 = Input.get_vector("keyboard_left", "keyboard_right", "keyboard_up", "keyboard_down")
	var _slash:bool = Input.is_action_just_pressed("keyboard_space")
	
	return {"input_direction":input_direction, "slash":_slash}
#moving the player!!!
func move(input_direction:Vector2, _delta:float,  is_slashing:bool) -> void:
	if is_slashing:#is the player slashing?. then don't move.
		return
	velocity = input_direction.normalized() * speed
	move_and_slide()
#is da player slashing???. bring the slash thingy from the edge of the map and make it visible
func slash(is_slashing:bool) -> void:
	
	#is the player slashing?. and the qte is not being used?. use it!!!
	if is_slashing and $qte.is_qte==false:
		$qte.init_qte()
	
	#yayy!!!, is the QTE is successful, reset it. and teleport the sword from the edge of the map to the player
	if $qte.is_success():
		sword.set_visible(true)
		sword.position = Vector2(0,0)
		$qte.reset()
#the walk animation-manager stuff. mhm
func walk_animation(input_direction:Vector2, delta:float) -> void:
	if delta==0:#if time has stopped, no animation.
		return
	
	#horizontal flip!
	if(velocity.x != 0):
		$AnimatedSprite2D.flip_h = velocity.x < 0
	
	#Only change animation if direction of player has changed
	if previous_input_direction != input_direction:
		# Set animation based on direction moving
		if Input.is_action_pressed("keyboard_right") or Input.is_action_pressed("keyboard_left"):
			$AnimatedSprite2D.set_animation("walk_side")
			
		if Input.is_action_pressed("keyboard_down"):
			$AnimatedSprite2D.set_animation("walk_down")
			
		if Input.is_action_pressed("keyboard_up"):
			$AnimatedSprite2D.set_animation("walk_up")
			
		# If not moving, check animation and set idle version of it
		if input_direction == Vector2(0,0):
			match $AnimatedSprite2D.animation:
				"walk_down":
					$AnimatedSprite2D.set_animation("idle_down")
				"walk_up":
					$AnimatedSprite2D.set_animation("idle_up")
				"walk_side":
					$AnimatedSprite2D.set_animation("idle_side")

		$AnimatedSprite2D.play()

func slash_animation(is_slashing:bool, delta:float) -> void:
	if delta==0:
		return
	
	if is_slashing:
		var animation:AnimatedSprite2D = sword.get_node("Animation")#get the animation stuff from the slash object
		
		# Change the player's animation
		match $AnimatedSprite2D.animation:
			"walk_down":
				$AnimatedSprite2D.set_animation("swing_down")
			"idle_down":
				$AnimatedSprite2D.set_animation("swing_down")
				
			"walk_up":
				$AnimatedSprite2D.set_animation("swing_up")
			"idle_up":
				$AnimatedSprite2D.set_animation("swing_up")
			
			"walk_side":
				$AnimatedSprite2D.set_animation("swing_side")
			"idle_side":
				$AnimatedSprite2D.set_animation("swing_side")
		
		
		#set the sword's horizontal and vertical flip
		sword.get_node("Animation").flip_h = not $AnimatedSprite2D.flip_h

		sword.get_node("Animation").flip_v = ($AnimatedSprite2D.animation == "swing_up" )
		sword.set_z_index(z_index-2*int($AnimatedSprite2D.animation == "swing_up" ))

		# Position collision box of slash according to direction of player
		match $AnimatedSprite2D.animation:
			"swing_down":
				sword.get_node("CollisionShape2D").position = Vector2(0,16)
			
			"swing_up":
				sword.get_node("CollisionShape2D").position = Vector2(0,-16)
			
			"swing_side":
				if(sword.get_node("Animation").flip_h == true):
					sword.get_node("CollisionShape2D").position = Vector2(16,0)
				else:
					sword.get_node("CollisionShape2D").position = Vector2(-16,0)
			
		sword.get_node("CollisionShape2D").position = Vector2(0,0)
		animation.play()

func update_health():
	var healthBar = $HealthBar
	healthBar.value = health
	
	if health >= 100: healthBar.visible = false
	else: healthBar.visible = true
	if health == 0:
		die()
	
func _on_regen_timer_timeout():
	if health < 100: 
		health += 20
		if health>100:
			health = 100
	if health == 0:
		health = 0
func die():
	if health<=0:
		get_tree().paused = true
		deathScreen.visible = true


func _on_area_2d_body_entered(body):
	health -= 10


