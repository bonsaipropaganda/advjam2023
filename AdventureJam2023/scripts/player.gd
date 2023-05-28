extends CharacterBody2D

@export var speed:float = 200
@export var swing_animation: PackedScene


#Used to remember the previous direction of player - to prevent changing animation every frame
#Only changes animation when previous input direction does not match current
@onready var previous_input_direction:Vector2 = Vector2(0,0)

@onready var swinging:bool = false
@onready var sword:Area2D = $SwordSlash

var health:int = 100

func _ready():
	sword.set_visible(false)


######################################################################################
#---------------------------------the main stuff--------------------------------------
######################################################################################
func _physics_process(delta):
	#first getting alllll the inputs from the player as a dictinary
	var user_input:Dictionary = user_input()
	var input_direction:Vector2 = user_input["input_direction"]
	var slash:bool = user_input["slash"]
	
	#a tiny function to make the player move!!!
	move(input_direction, delta, slash)
	slash(slash)

	#ANIMATION FUNCIONS
	walk_animation(input_direction, delta)#this function makes does all of the player "Walk animation"
	slash_animation(slash, delta)#this one's for the slash animations
	
	previous_input_direction = input_direction


#getting all the input from the player!!!
func user_input() -> Dictionary:
	var input_direction:Vector2 = Input.get_vector("keyboard_left", "keyboard_right", "keyboard_up", "keyboard_down")
	var slash:bool = Input.is_action_just_pressed("keyboard_space")
	
	return {"input_direction":input_direction, "slash":slash}


#moving the player!!!
func move(input_direction:Vector2, delta:float,  is_slashing:bool) -> void:
	if is_slashing:
		return
	velocity = input_direction.normalized() * speed
	move_and_slide()


#is da player slashing???. bring the slash thingy from the edge of the map and make it visible
func slash(is_slashing:bool) -> void:
	if is_slashing and $qte.is_qte==false:
		$qte.init_qte()

	if $qte.is_success():
		sword.set_visible(true)
		sword.position = Vector2(0,0)
		$qte.reset()



#the walk animation-manager stuff. mhm
func walk_animation(input_direction:Vector2, delta:float) -> void:
	if delta==0:
		return
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
		print($AnimatedSprite2D.animation,"	", previous_input_direction)
		var animation:AnimatedSprite2D = sword.get_node("Animation")#get the animation stuff from the slash object
		
		sword.get_node("Animation").flip_h = not $AnimatedSprite2D.flip_h

		sword.get_node("Animation").flip_v = ($AnimatedSprite2D.animation == "swing_up" )
		sword.set_z_index(z_index-2*int($AnimatedSprite2D.animation == "swing_up" ))
		
		
		# Change the player's animation
		match $AnimatedSprite2D.animation:
			"walk_down":
				$AnimatedSprite2D.set_animation("swing_down")
				sword.get_node("CollisionShape2D").position = Vector2(0,16)
			"idle_down":
				$AnimatedSprite2D.set_animation("swing_down")
				sword.get_node("CollisionShape2D").position = Vector2(0,16)
				
			"walk_up":
				$AnimatedSprite2D.set_animation("swing_up")
				sword.get_node("CollisionShape2D").position = Vector2(0,-16)
			"idle_up":
				$AnimatedSprite2D.set_animation("swing_up")
				sword.get_node("CollisionShape2D").position = Vector2(0,-16)
			
			"walk_side":
				$AnimatedSprite2D.set_animation("swing_side")
				if(sword.get_node("Animation").flip_h == true):
					sword.get_node("CollisionShape2D").position = Vector2(16,0)
				else:
					sword.get_node("CollisionShape2D").position = Vector2(-16,0)
			"idle_side":
				$AnimatedSprite2D.set_animation("swing_side")
				if(sword.get_node("Animation").flip_h == true):
					sword.get_node("CollisionShape2D").position = Vector2(16,0)
				else:
					sword.get_node("CollisionShape2D").position = Vector2(-16,0)
		
			
		sword.get_node("CollisionShape2D").position = Vector2(0,0)
		
		animation.play()



func _on_animated_sprite_2d_animation_looped():
	swinging = false
	match $AnimatedSprite2D.animation:
		"swing_down":
			$AnimatedSprite2D.set_animation("idle_down")
		"swing_up":
			$AnimatedSprite2D.set_animation("idle_up")
		"swing_side":
			$AnimatedSprite2D.set_animation("idle_side")
	
	previous_input_direction = Vector2(10,10) # Filler to force the get_input() to update after the animation
