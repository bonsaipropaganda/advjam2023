extends Node2D

@onready var key = $Key
@onready var SpriteAnimator = $AnimatedSprite2D
@onready var textBox = owner.get_node("GUI/TextureRect")

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
			match index:
				-1:	dialogue(0, -1)
				0:	dialogue(index, 1)
				1:	dialogue(index, 2)
				2:	dialogue(index, 3)
				3:	dialogue(index, 4)
				4:	dialogue(index, 5)
				5:	dialogue(index, 6)
				6:	dialogue(index, 7)
				7:	dialogue(index, 8)
				8:	dialogue(index, 9)
				9:	dialogue(index, 10)
				10: dialogue(index, 11)
				11:	
					dialogue(0, -1)
					# this section gradually gets rid of the nodes from Dark Figure's Scene
					key.visible = false
					key = null
					textBox.visible = false
					textBox = null
					$CollisionShape2D.disabled = true
					SpriteAnimator.play("disappear")
					get_parent().get_node("ForceField").get_node("AnimatedSprite2D").play("disappear")
					$AudioStreamPlayer2D.play(0)
					await SpriteAnimator.animation_finished
					get_parent().get_node("ForceField").queue_free()
					await $AudioStreamPlayer2D.finished
					queue_free()
				_:  dialogue()

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
func dialogue(_index := 0, _next_index := 0, _the_name := "Dark Figure", _filePath := "res://scenes/Entities/DarkFigure/Dark_Figure_Dialogue.json"):
	var _json_as_text = FileAccess.get_file_as_string(_filePath)
	var _json_as_dict = JSON.parse_string(_json_as_text)
	if textBox:
		textBox.get_node("CharacterNameBox/CharacterName").text = _the_name
		textBox.get_node("Text").text = _json_as_dict[_index].text
	index = _next_index

