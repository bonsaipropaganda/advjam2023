extends CanvasLayer


@onready var chroma: ColorRect = $ChromaticAberration/Node/Canvas
@onready var vignette: ColorRect = $Vignette/Node/Canvas

# Shader parameters
@export_group("Chromatic Aberration")
@export var chroma_sharpness: float   = 8.0:
	set(value):
		chroma_sharpness = value
		if is_inside_tree():
			chroma.material.set_shader_parameter(&"sharpness", value)

@export var chroma_red_displacement  : float   = 0.0:
	set(value):
		chroma_red_displacement = value
		if is_inside_tree():
			chroma.material.set_shader_parameter(&"red_displacement", value)

@export var chroma_green_displacement: float   = 0.003:
	set(value):
		chroma_green_displacement = value
		if is_inside_tree():
			chroma.material.set_shader_parameter(&"green_displacement", value)

@export var chroma_blue_displacement : float   = 0.005:
	set(value):
		chroma_blue_displacement = value
		if is_inside_tree():
			chroma.material.set_shader_parameter(&"blue_displacement", value)


@export_group("Vignette")
@export var vignette_color   : Color = Color.BLACK:
	set(value):
		vignette_color = value
		if is_inside_tree():
			vignette.material.set_shader_parameter(&"color", value)

@export var vignette_strength: float = 0.03:
	set(value):
		vignette_strength = value
		if is_inside_tree():
			vignette.material.set_shader_parameter(&"strength", value)


func _ready() -> void:
	visible = true
	
	# Call setters
	chroma_sharpness = chroma_sharpness
	chroma_red_displacement   = chroma_red_displacement
	chroma_green_displacement = chroma_green_displacement
	chroma_blue_displacement  = chroma_blue_displacement
	
	vignette_color = vignette_color
	vignette_strength = vignette_strength


func _on_visibility_changed() -> void:
	chroma.visible = visible
	vignette.visible = visible
