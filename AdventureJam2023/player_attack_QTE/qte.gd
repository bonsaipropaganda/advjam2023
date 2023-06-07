extends Node2D

@export var images: Array[Texture]

# Describes how much time is slowed during a qte
@export var time_factor: float = 0.1

# Spacing between key indicators
@export var key_spacing: float = 20
# The time it takes for a key to move to the left
@export var key_mov_time: float = 0.08
# The amount of time the player has to complete the QTE
@export var total_time: float = 3.0
# The attack cooldown
@export var cooldown_time: float = 0.8


var sequence: Array[int]
# how many correct characters the player has ah. done.
var correct_key_count: int

# Eather cooldown time or time remaining in QTE, depending on `on_cooldown` flag
var time: float = -1.0
var on_cooldown: bool = false
var in_progress: bool = false

##############################################.

signal qte_done(is_success: bool)


func _ready() -> void:
	qte_done.connect(func(_s): reset())


# This is where the whole code starts
func init_qte(sequence_length: int = 3) -> void:
	if on_cooldown:
		return
	
	time = total_time
	in_progress = true
	correct_key_count = 0
	
	#get a random sequence of stuff
	sequence = create_random_sequence(sequence_length)

	#spawn some sprites
	spawn_qte_sprites()

	# Slow down time
	Engine.time_scale = time_factor


#get the random sequence of characetsrs
func create_random_sequence(max_len: int) -> Array[int]:
	var seq: Array[int] = []
	for i in range(max_len):
		var value: int = randi_range(0, images.size() - 2)
		seq.append(value)
	return seq


#spawn the sprites
func spawn_qte_sprites():
	var counter: int = 0

	for i in sequence:
		var sprite: Sprite2D = Sprite2D.new()
		add_child(sprite)

		sprite.texture = images[i]
		sprite.position = Vector2(counter * key_spacing, 0)

		counter += 1


#the main loop
func _process(delta: float):
	# Transform engine time delta into real time delta
	delta = delta / Engine.time_scale
	
	time -= delta # Remove time for the QTE
	
	# Apply scale animation
	for i in range(get_child_count()):
		get_child(i).scale = Vector2(1, 1) * (time / (time - delta))
	
	# Stop QTE when ran out of time
	if is_in_progress() && time <= 0.0:
		qte_done.emit(false)
	if is_on_cooldown() && time <= 0.0:
		on_cooldown = false


func _unhandled_input(event: InputEvent) -> void:
	if !is_in_progress():
		return
	
	var index := get_event_index(event)
	if index != -1:
		get_viewport().set_input_as_handled()
		register_input(index)


func get_event_index(event: InputEvent) -> int:
	if event.is_action_pressed("keyboard_up"):
		return 0
	elif event.is_action_pressed("keyboard_right"):
		return 1
	elif event.is_action_pressed("keyboard_left"):
		return 2
	elif event.is_action_pressed("keyboard_down"):
		return 3
	return -1


func register_input(input: int) -> void:
	#yayyy!!, if the input is right, resert the qte timer. and iterate the qte_counter so you can check the next element in the sequence
	if input == sequence[correct_key_count]:
#		if qte_reset_timer > 0:
#			qte_timer = clampf(qte_timer + qte_reset_timer, 0, qte_timer)
		correct_key_count += 1
		if correct_key_count == sequence.size():  #if you'er at the end of the sequence, exitttt, and sucess is truee
			time = -1.0
			qte_done.emit(true)

		sprite_shift()
	else:  # if you have failed, then just quit
		qte_done.emit(false)


func sprite_shift():  # For moving the sprite around after every input
	for sprite in get_children():
		if !(sprite is Sprite2D):
			continue
		
		var tween := sprite.create_tween()
		tween.tween_property(sprite, ^"position",
			sprite.position - Vector2(key_spacing, 0.0), time_factor * key_mov_time
		).set_trans(Tween.TRANS_CUBIC)


func is_in_progress() -> bool:
	return in_progress


func is_on_cooldown() -> bool:
	return on_cooldown


func get_progress() -> float:
	return 1.0 - time / total_time


# Normalized remaining cooldown
func get_cooldown_remaining() -> float:
	return time / cooldown_time


func reset() -> void:
	time = cooldown_time
	on_cooldown = true
	in_progress = false
	
	for child in get_children(): # Remove key sprites
		if child is Sprite2D:
			child.queue_free()
	
	Engine.time_scale = 1.0
