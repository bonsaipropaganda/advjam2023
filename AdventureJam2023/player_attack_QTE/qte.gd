extends Node2D


@export var images:Array[Texture]

var called:bool = false


var qte_sequence:Array[int]
var qte_counter:int = 0
var is_qte:bool = false


var qte_reset_timer:float = 1.5
var qte_timer:float = 1.5
var qte_previous_time:float = 0
var qte_delta_time:float = 0

var success:bool = false

func _process(delta):
	qte_delta_time_process()
	if is_qte:
		var input:int = fetch_input()
		qte_iter(input)
		qte_time_out()
	if is_qte==false:
		if not get_child_count()==0:
			destroy_sprites()
		Engine.time_scale = 1

#export functions!!!
func is_success()->bool:
	return success

func reset()->void:
	success = false

##############################################
func fetch_input()->int:
	var ret_val:int = -1
	if Input.is_action_just_pressed("keyboard_up"):
		return 0
	if Input.is_action_just_pressed("keyboard_right"):
		return 1
	if Input.is_action_just_pressed("keyboard_left"):
		return 2
	if Input.is_action_just_pressed("keyboard_down"):
		return 3
	if Input.is_action_just_pressed("keyboard_space"):
		return -1
	return ret_val


func qte_iter(input:int) -> void:
	if input < 0 or not is_qte:
		return
	if input == qte_sequence[qte_counter]:
		qte_timer = qte_reset_timer
		qte_counter += 1
		if qte_counter == qte_sequence.size():
			is_qte = false
			success = true
		sprite_shift()
	else:
		is_qte = false

func sprite_shift():
	for i in range(get_child_count()):
		var sprite_stuff:Object = get_child(i)
		sprite_stuff.position.x -= 20



func qte_delta_time_process()->void:
	var current_time:float = Time.get_ticks_msec()
	qte_delta_time = (current_time - qte_previous_time)/1000
	qte_previous_time = current_time


func qte_time_out()->void:
	if qte_timer < 0:
		qte_timer = qte_reset_timer
		is_qte = false
	qte_timer-=qte_delta_time



func destroy_sprites()->void:
	for i in range(get_child_count()):
		get_child(i).queue_free()
	Engine.time_scale = 1

##############################################
func init_qte() -> void:
	is_qte = true
	qte_sequence = sequence(5)
	spawn_qte_sprites()
	Engine.time_scale = 0.0
	qte_timer = qte_reset_timer
	qte_counter = 0


func sequence(max_len:int)->Array[int]:
	var seq:Array[int]
	for i in range(max_len):
		var value:int = randi_range(0, images.size() - 2)
		seq.append(value)
	return seq

func spawn_qte_sprites():
	var counter:int = 0
	for i in qte_sequence:
		var sprite:Sprite2D = Sprite2D.new()
		add_child(sprite)
		
		sprite.texture = images[i]
		sprite.global_position =Vector2(counter*20, 0)
		
		counter += 1




