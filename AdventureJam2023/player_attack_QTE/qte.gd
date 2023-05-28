extends Node2D


@export var images:Array[Texture]

var qte_sequence:Array[int]
var qte_counter:int = 0
var is_qte:bool = false


func _ready():
	init_qte()


func _process(delta):
	if is_qte:
		var input:int = fetch_input()
		qte_checker(input)
	else:
		Engine.time_scale = 1

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
		return 4
	return ret_val

func qte_checker(input:int) -> void:
	if input < 0:
		return
	
	
	
	if input == qte_sequence[qte_counter]:
		qte_counter += 1
		if qte_counter == qte_sequence.size():
			is_qte = false
		
		sprite_shift()
		
	else:
		is_qte = false

func sprite_shift():
	for i in range(get_child_count()):
		var sprite_stuff:Object = get_child(i)
		sprite_stuff.global_position.x -= 20
		pass
	pass


##############################################
func init_qte() -> void:
	qte_sequence = sequence(5)
	spawn_qte_sprites()
	Engine.time_scale = 0.0
	is_qte = true


func sequence(max_len:int)->Array[int]:
	var seq:Array[int]
	for i in range(max_len):
		var value:int = randi_range(0, images.size() - 1)
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


