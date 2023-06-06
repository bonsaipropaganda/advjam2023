extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	top_level = true

func _physics_process(delta):
	global_position = lerp(global_position,get_parent().global_position,5*delta)
