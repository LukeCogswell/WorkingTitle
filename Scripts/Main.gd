extends Node2D

var castle = preload("res://Scenes/Castle.tscn")
var house = preload("res://Scenes/House.tscn")
var grass = preload("res://Scenes/Grass.tscn")
var mountain = preload("res://Scenes/Mountain.tscn")
var tree = preload("res://Scenes/Tree.tscn")
var water = preload("res://Scenes/Water.tscn")
var tileSize = 8

var noiseSeed = 0
var noiseOctaves = 2
var noisePeriod = 30
var altitude_noise = OpenSimplexNoise.new()
var map = []
	

var tiles = [castle, house, grass, mountain]

func _ready():
	altitude_noise.octaves = noiseOctaves
	altitude_noise.period = noisePeriod
	altitude_noise.seed = noiseSeed
	for i in 32:
		map.append([])
	generate_using_noise()
	
#	make_tiles()

# default values based on screen height/width
func make_tiles(cols : int = 32, rows : int = 18):
	for x in cols:
		for y in rows:
			var new_pos = Vector2(x * tileSize, y * tileSize)
			var choice = rand_range(0, len(tiles))
			var new_tile = tiles[choice].instance()
			new_tile.position = new_pos
			add_child(new_tile)
			map[x].append(new_tile)

func generate_using_noise(cols : int = 32, rows : int = 18):
	
	for x in cols:
		for y in rows:
			var pos = Vector2(x * tileSize, y * tileSize)
			var val = altitude_noise.get_noise_2d(pos.x, pos.y)
			if val < 0:
				make_at(grass, pos)
			elif val < 0.35:
				make_at(tree, pos)
			else:
				make_at(mountain, pos)

#func generate_river():
#	currentPos = 

func make_at(scene, pos : Vector2):
	
	var new_child = scene.instance()
	new_child.position = pos
	add_child(new_child)
	map[int(pos.x / tileSize)].append(new_child)
	
func get_5_by_5(tileScene):
	var centerCoord = Vector2(int(tileScene.position.x / tileSize), int(tileScene.position.y / tileSize))
	var fiveXfive = [[], [], [], [], []]
	for x in 5:
		for y in 5:
			fiveXfive[x].append(map[centerCoord.x - 2 + x][centerCoord.y + 2 - y])
	return fiveXfive
	
