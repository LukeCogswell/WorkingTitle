extends Node2D

var castle = preload("res://Scenes/Castle.tscn")
var house = preload("res://Scenes/House.tscn")
var grass = preload("res://Scenes/Grass.tscn")
var mountain = preload("res://Scenes/Mountain.tscn")

var tiles = [castle, house, grass, mountain]

onready var noise = $"land noise".texture.noise

func _ready():
	generate_using_noise()
#	make_tiles()

# very basic function that fills the screen with castles
# default values based on screen height/width
func make_tiles(cols : int = 32, rows : int = 18):
	for x in cols:
		for y in rows:
			var new_pos = Vector2(x * 8, y * 8)
			var choice = rand_range(0, len(tiles))
			var new_castle = tiles[choice].instance()
			new_castle.position = new_pos
			add_child(new_castle)

func generate_using_noise(cols : int = 32, rows : int = 18):
	for x in cols:
		for y in rows:
			var pos = Vector2(x * 8, y * 8)
			var val = noise.get_noise_2d(pos.x, pos.y)
			if val > 0:
				make_at(grass, pos)
			else:
				make_at(mountain, pos)

func make_at(scene, pos : Vector2):
	var new_child = scene.instance()
	new_child.position = pos
	add_child(new_child)
