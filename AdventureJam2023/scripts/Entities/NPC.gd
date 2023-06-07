extends Node2D
class_name NPC

@export var figure_name: String = "Blank"	# The name that will appear for the character
@export_file("*.json") var dialogue_file: String = "":
	set(value):
		dialogue_file = value
		var dialogue_text := FileAccess.get_file_as_string(dialogue_file)
		dialogue_data = JSON.parse_string(dialogue_text)
@export var current_dialogue: String = "Meeting"
var following_dialogue: String = "Meeting"

var dialogue_data: Dictionary = {}

var key
var SpriteAnimator
var text_box: DialogueBox

var line_index : int = 0    # The index of the current line of dialogue
var can_interact := false

var player_reference = null

signal dialogue_finished(dialogue_name: String)
signal do_action(action_name: String)


func _ready():
	key = $Key
	SpriteAnimator = $AnimatedSprite2D
	SpriteAnimator.play("default")
	text_box = owner.get_node("GUI/DialogBox")
	
	do_action.connect(_action)


func _input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("Interact") and can_interact:
			# stuff lke if textBox: textBox... is just to avoid nill errors
			if text_box: text_box.show()
			
			# If there is no more dialogue line, close dialogue
			if line_index >= dialogue_data[current_dialogue].size():
				close_dialogue()
				return
			
			var line: Dictionary = dialogue_data[current_dialogue][line_index]
			
			# Add text if there is one
			if line.has("text"):
				show_dialogue_line(line["text"])
			
			# Execute action if there is one
			if line.has("actions"):
				for act in line["actions"]:
					do_action.emit(act)
			
			if line.has("next"):
				next_dialogue(line["next"])
			elif line.has("continue"):
				continue_dialogue(line["continue"])
			else:
				line_index += 1


# Method to override
func _action(_act_name: String) -> void:
	pass


func close_dialogue():
	line_index = 0
	key.visible = false
	can_interact = false
	text_box.hide()
	dialogue_finished.emit(current_dialogue)
	current_dialogue = following_dialogue


func continue_dialogue(dialogue: String):
	current_dialogue = dialogue
	line_index = 0


func next_dialogue(dialogue: String):
	following_dialogue = dialogue
	line_index = 2147483647


# this is to interact from nearby
func _on_interaction_range_body_entered(body):
	if body.name == "Player":
		if key:	key.visible = true
		can_interact = true
		player_reference = body
		line_index = 0


# this is to exit the interaction
func _on_interaction_range_body_exited(body):
	if body.name == "Player":
		if key:	key.visible = false
		if text_box: text_box.hide()
		can_interact = false
		player_reference = null


func set_dialogue_file(file: String) -> void:
	dialogue_file = file


func show_dialogue_line(line: String) -> void:
	if text_box: text_box.show_dialogue_line(figure_name, line)
