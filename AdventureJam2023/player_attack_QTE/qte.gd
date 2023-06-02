extends Node2D

@export var images: Array[Texture]

var called: bool = false

@export var qte_sequence: Array[int]
# how many correct characters the player has ah. done.
@export var qte_counter: int = 0
var is_qte: bool = false

@export var qte_reset_timer: float = 1.5
@export var qte_timer: float = 1.5
var qte_previous_time: float = 0
var qte_delta_time: float = 0
var success: bool = false

##############################################.

signal qte_done(is_success: bool)


#this is where the whole code starts
func init_qte(
	sequenceLength: int = 3, resetBonusTime: float = 1.5, totalCompletionTime: float = 3.0
) -> void:
	is_qte = true

	qte_reset_timer = resetBonusTime
	qte_timer = totalCompletionTime

	#get a random sequence of stuff
	qte_sequence = sequence(sequenceLength)

	#spawn some sprites
	spawn_qte_sprites()

	#stop the time
	Engine.time_scale = 0.1

	#hey, da QTE timer!!!. AHHH!!!!, TODO: make some sorta weird shader that'll slowly make the screen go grayscale to indicate that the time's gonna run out
	qte_timer = qte_reset_timer
	qte_counter = 0


#get the random sequence of characetsrs
func sequence(max_len: int) -> Array[int]:
	var seq: Array[int] = []
	for i in range(max_len):
		var value: int = randi_range(0, images.size() - 2)
		seq.append(value)
	return seq


#spawn the sprites
func spawn_qte_sprites():
	var counter: int = 0
	var player: Object = get_parent()

	for i in qte_sequence:
		var sprite: Sprite2D = Sprite2D.new()
		add_child(sprite)

		sprite.texture = images[i]
		sprite.global_position = Vector2(counter * 20, 0) + player.global_position

		counter += 1


#the main loop
func _process(_delta):
	#custom delta time, cuz time has been stopped now. soo no traditional delta time
	qte_delta_time_process()
	if is_qte:  #are you still playing da QTE?.
		var input: int = fetch_input()  #get da input
		qte_iter(input)  #see if it's right. if it is, check iterate
		qte_time_out()  #timed out?. exit da QTE
	if is_qte == false:  #if the qte is done
		if not get_child_count() == 0:  #delete all the sprites
			destroy_sprites()
		Engine.time_scale = 1  #set the engine time to 1.


#export functions!!!
func is_success() -> bool:
	return success


func reset() -> void:
	success = false


##############################################
func fetch_input() -> int:
	if Input.is_action_just_pressed("keyboard_up"):
		return 0
	if Input.is_action_just_pressed("keyboard_right"):
		return 1
	if Input.is_action_just_pressed("keyboard_left"):
		return 2
	if Input.is_action_just_pressed("keyboard_down"):
		return 3
	return -1


func qte_iter(input: int) -> void:
	if input < 0:  #if there has NOT been any input, exit
		return

	#yayyy!!, if the input is right, resert the qte timer. and iterate the qte_counter so you can check the next element in the sequence
	if input == qte_sequence[qte_counter]:
		if qte_reset_timer > 0:
			qte_timer = clampf(qte_timer + qte_reset_timer, 0, qte_timer)
		qte_counter += 1
		if qte_counter == qte_sequence.size():  #if you'er at the end of the sequence, exitttt, and sucess is truee
			is_qte = false
			success = true
			qte_done.emit(true)

		sprite_shift()
	else:  # if you have failed, then just quit
		is_qte = false
		qte_done.emit(false)


func sprite_shift():  #for moving the sprite around after every input
	for i in range(get_child_count()):
		var sprite_stuff: Object = get_child(i)
		sprite_stuff.position.x -= 20


func qte_delta_time_process() -> void:  #delta timeee,when the time is stopped
	var current_time: float = Time.get_ticks_msec()
	qte_delta_time = (current_time - qte_previous_time) / 1000
	qte_previous_time = current_time

	for i in range(get_child_count()):
		get_child(i).scale = Vector2(1, 1) * (qte_timer / (qte_timer - qte_delta_time))


func qte_time_out() -> void:  #timedd out
	if qte_timer < 0:
		qte_timer = qte_reset_timer
		is_qte = false
		qte_done.emit(false)
	qte_timer -= qte_delta_time


func destroy_sprites() -> void:
	for i in range(get_child_count()):
		get_child(i).queue_free()
	Engine.time_scale = 1
