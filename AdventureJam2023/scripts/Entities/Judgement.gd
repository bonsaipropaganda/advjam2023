extends Node2D

@onready var key = $Key
@onready var SpriteAnimator = $AnimatedSprite2D
@onready var textBox = owner.get_node("GUI/TextureRect")

@export var figure_name: String = "Blank"
@export var dialogue_path: String = "res://scripts/Entities/dialogue/"

#	index = the dialogue number
var index : int = 0
var can_interact := false

func _ready():
	SpriteAnimator.play("default")

func _input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("Interact") and can_interact:
			# stuff lke if textBox: textBox... is just to avoid nill errors
			if textBox: textBox.visible = true
			print(index)
			if index == -1:
				pass
			elif index == 0:
				dialogue(index, 1)
				SpriteAnimator.play("look_up")
			elif index >= 1 and index <= 12:
				dialogue(index, index+1)
			elif index == 13:
				dialogue(index, 14)
				# Character animation
				SpriteAnimator.play("look_down")
				await(SpriteAnimator.animation_finished)
				SpriteAnimator.play("default")
			elif index == 14:
				dialogue(0, -1)
				key.visible = false
				key = null
				textBox.visible = false
				textBox = null
				can_interact = false

# this is to interact from nearby
func _on_interaction_range_body_entered(body):
	if body.name == "Player":
		if key:	key.visible = true
		can_interact = true

# this is to exit the interaction
func _on_interaction_range_body_exited(body):
	if body.name == "Player":
		if key:	key.visible = false
		if textBox: textBox.visible = false
		can_interact = false

# a dialogue function that uses a json file which has all the dialogue for this character
func dialogue(_index := 0, _next_index := 0, _the_name := figure_name, _file_path := dialogue_path):
	var _json_as_text = FileAccess.get_file_as_string(_file_path)
	var _json_as_dict = JSON.parse_string(_json_as_text)
	if textBox:
		textBox.get_node("CharacterNameBox/CharacterName").text = _the_name
		textBox.get_node("Text").text = _json_as_dict[_index].text
	index = _next_index

