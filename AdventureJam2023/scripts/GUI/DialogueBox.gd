class_name DialogueBox
extends NinePatchRect


func show_dialogue_line(character_name: String, line: String) -> void:
	%DialogueLine.text = line
	%CharacterName.text = character_name
	
