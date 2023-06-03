extends Node2D
class_name NPC

# Exported variables to be changed/added in the editor
@export var figure_name: String = "Blank"	# The name that will appear for the character
@export var dialogue_paths: Array[String]	# An array of file paths that point to json files for dialogue
@export var dialogue_index: int = 0			# The index of the current dialogue file in dialogue_paths

var key
var SpriteAnimator
var textBox

var index : int = 0			# The index of the current line of dialogue
var can_interact := false

var player_reference = null

var json_as_dict = {}		# dictionary of the current dialogue
var action_on_dialogue = {}	# dictionary of actions to take upon reaching certain dialogue indexes

signal dialogue_finished(dialogue_index)

func _ready():
	key = $Key
	SpriteAnimator = $AnimatedSprite2D
	SpriteAnimator.play("default")
	textBox = owner.get_node("GUI/TextureRect")
	set_json(dialogue_paths[dialogue_index])
	set_action_index()

func _input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("Interact") and can_interact:
			# stuff lke if textBox: textBox... is just to avoid nill errors
			if textBox: textBox.visible = true
			
			if index in action_on_dialogue:		# If there is a special action associated with this index, do it
				action_on_dialogue[index].call()
			elif index >= json_as_dict.size():	# If the dialogue is over, reset the index and hide the dialogue box
				close_dialogue()
			else:
				dialogue(index, index+1)		# If this is not a special case, conitnue as usual

func close_dialogue():
	index = 0
	key.visible = false
	textBox.visible = false
	can_interact = false
	dialogue_finished.emit(dialogue_index)

# Function to overwrite in children classes. Did this to not overwrite the _ready method
func set_action_index():
	pass

# Function to reset the action_on_dialogue dictionary
func clear_action_index(_new_action_index: Dictionary = {}):
	# Wait for the signal to fire to ensure every line of code in action_on_dialogue is finished first.
	await(self.dialogue_finished)
	
	action_on_dialogue = _new_action_index

func add_action_to_index(idx : int, actions):
	action_on_dialogue[idx] = actions

func switch_dialogue_option(new_index):
	dialogue_index = new_index
	set_json(dialogue_paths[dialogue_index])

# this is to interact from nearby
func _on_interaction_range_body_entered(body):
	if body.name == "Player":
		if key:	key.visible = true
		can_interact = true
		player_reference = body

# this is to exit the interaction
func _on_interaction_range_body_exited(body):
	if body.name == "Player":
		if key:	key.visible = false
		if textBox: textBox.visible = false
		can_interact = false
		player_reference = null

# Get the json file and use it to fill a dict
func set_json(file_path):
	var _json_as_text = FileAccess.get_file_as_string(file_path)
	json_as_dict = JSON.parse_string(_json_as_text)

# a dialogue function that uses a json file which has all the dialogue for this character
func dialogue(_index := 0, _next_index := 0, _the_name := figure_name, _file_path := dialogue_paths[dialogue_index]):
	if textBox:
		textBox.get_node("CharacterNameBox/CharacterName").text = _the_name
		textBox.get_node("Text").text = json_as_dict[_index].text
	index = _next_index
