extends Area2D

# Grid-based cursor

export var tile_size := 8

func _ready():
	# hide mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	position = (get_global_mouse_position() / tile_size).floor() * tile_size
