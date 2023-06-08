class_name DialogueBox
extends NinePatchRect

@onready var sfx = %sfx
@onready var player: Object = get_tree().get_nodes_in_group("Player")[0]

func show_dialogue_line(character_name: String, line: String) -> void:
	%DialogueLine.text = line
	%CharacterName.text = character_name
	sfx.play()
	player.can_do_stuff = false
