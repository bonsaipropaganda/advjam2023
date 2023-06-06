extends Camera2D

@onready var color_rect = $ColorRect

# Called when the node enters the scene tree for the first time.
func _ready():
	top_level = true
	global_position = get_parent().global_position

func _process(delta):
	color_rect.modulate = lerp(color_rect.modulate,Color(0,0,0,0),0.5*delta)

func _physics_process(delta):
	global_position = lerp(global_position,get_parent().global_position,5*delta)
