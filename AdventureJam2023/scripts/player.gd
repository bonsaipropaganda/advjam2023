extends CharacterBody2D

@export var speed = 400
@export var swing_animation: PackedScene


#Used to remember the previous direction of player - to prevent changing animation every frame
#Only changes animation when previous input direction does not match current
@onready var previous_input_direction = Vector2(0,0)

@onready var swinging = false

func _ready():
	pass


func get_input():
	# CHECK INPUT
	var input_direction = Input.get_vector("keyboard_left", "keyboard_right", "keyboard_up", "keyboard_down")
	# Set velocity
	velocity = input_direction.normalized() * speed
	
	# Flip sprite depending on x direction 
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
		
	# ATTACKS
	## SLASH
	if not swinging and Input.is_action_pressed("keyboard_space"):
		swinging = true 
		
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

		# Create animation for slash
		var slash = swing_animation.instantiate()
		
		# Flip slash according to direction of player
		slash.get_node("Animation").flip_h = not $AnimatedSprite2D.flip_h
		if ($AnimatedSprite2D.animation == "swing_up" ):
			slash.get_node("Animation").flip_v = true
			slash.set_z_index(z_index-2)
		
		# Position collision box of slash according to direction of player
		match $AnimatedSprite2D.animation:
			"swing_down":
				slash.get_node("CollisionShape2D").position = Vector2(0,16)
			
			"swing_up":
				slash.get_node("CollisionShape2D").position = Vector2(0,-16)
			
			"swing_side":
				if(slash.get_node("Animation").flip_h == true):
					slash.get_node("CollisionShape2D").position = Vector2(16,0)
				else:
					slash.get_node("CollisionShape2D").position = Vector2(-16,0)
			
		slash.get_node("CollisionShape2D").position = Vector2(0,0)
		
		add_child(slash)
		
		velocity = Vector2(0,0) #Stop the player movement
		
		
	# Remember previous direction of player
	previous_input_direction = input_direction
	
	
func _physics_process(_delta):
	if not swinging:
		get_input()
		move_and_slide()

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
