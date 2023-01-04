extends Node2D

var castle = preload("res://Scenes/Castle.tscn")

# very basic function that fills the screen with castles
# default values based on screen height/width
func make_tiles(cols : int = 32, rows : int = 18):
	for x in cols:
		for y in rows:
			var new_pos = Vector2(x * 8, y * 8)
			var new_castle = castle.instance()
			new_castle.position = new_pos
			add_child(new_castle)

func _ready():
	make_tiles()
