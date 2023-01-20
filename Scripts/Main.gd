extends Node2D

onready var ySort = $YSort

var castle = preload("res://Scenes/Castle.tscn")
var house = preload("res://Scenes/House.tscn")
var grass = preload("res://Scenes/Grass.tscn")
var mountain = preload("res://Scenes/Mountain.tscn")
var tree = preload("res://Scenes/Tree.tscn")
var water = preload("res://Scenes/Water.tscn")
onready var button = get_node("Button")
var tileSize = 16
var rngGen = RandomNumberGenerator.new()
export var mapCols = 32
export var mapRows = 18

var noiseOctaves = 2
var noisePeriod = 30
var altitude_noise = OpenSimplexNoise.new()
var map = []
var Seed = rand_range(-1, 1000)
var riverLength = 12

enum {WATER = 0, CASTLE = 1, HOUSE = 2, GRASS = 3, MOUNTAIN = 4, TREE = 5}

var tiles = [castle, house, grass, mountain]

func _ready():
	seed(Seed)
	rngGen.seed = Seed
	altitude_noise.octaves = noiseOctaves
	altitude_noise.period = noisePeriod
	altitude_noise.seed = Seed
	for i in 32:
		map.append([null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null])
	generate_using_noise(mapCols, mapRows)

func generate_using_noise(cols, rows):
	for x in cols:
		for y in rows:
			var pos = Vector2(x * tileSize, y * tileSize)
			var val = altitude_noise.get_noise_2d(pos.x, pos.y)
#			if val < -0.5:
#				make_at(water, pos)
			if val < 0:
				make_at(grass, pos)
			elif val < 0.35:
				make_at(tree, pos)
			else:
				make_at(mountain, pos)

func generate_rivers():
	var randChoice = rand_range(5, len(map)-5)
	var startingTile = map[randChoice][0]
	var startingX = startingTile.position.x / tileSize 
	var y = 0
	var previousPos = Vector2(startingX, y)
	var offsetX = 0
	while y < mapRows and previousPos.x + offsetX > -1 and previousPos.x + offsetX < mapCols:
		previousPos = Vector2(previousPos.x + offsetX, y)
		make_at(water, Vector2(previousPos.x * tileSize, previousPos.y * tileSize))
		offsetX = rngGen.randi_range(-1, 1)
		if offsetX == 0:
			y += 1

func generate_all_lakes(cols, rows):
	var waterStartPoints = []
	for x in cols:
		for y in rows:
			var pos = Vector2(x * tileSize, y * tileSize)
			var val = altitude_noise.get_noise_2d(pos.x, pos.y)
			if map[x][y].type == WATER:
				waterStartPoints.append(Vector2(x * tileSize, y * tileSize))
	for k in waterStartPoints.size():
		generate_lake(waterStartPoints[k])


func generate_lake(pos):
	var currentPos = pos
	var i = 0
	while i < riverLength:
#		var offsetY = 1
#		var offsetX = 0
		var offsetY = int(rand_range(-2, 2))
		var offsetX = int(rand_range(-2, 2))
		if int(currentPos.x/tileSize) + offsetX + 1 > mapCols or int(currentPos.y/tileSize) + offsetY + 1 > mapRows or int(currentPos.x/tileSize) + offsetX < 0 or int(currentPos.y/tileSize) + offsetY < 0:
			i += 1
			return
		 #{WATER, CASTLE, HOUSE, GRASS, MOUNTAIN, TREE}
		var fiveXfiveTypes = get5x5TypeList(Vector2(currentPos.x / tileSize, currentPos.y / tileSize))
		currentPos = Vector2((currentPos.x/tileSize + offsetX) * tileSize, (currentPos.y/tileSize + offsetY) * tileSize)
		var currentTile = map[int(currentPos.x/tileSize)][int(currentPos.y/tileSize)]
		if currentTile.type == WATER:
			return
		elif fiveXfiveTypes[MOUNTAIN] > 0:
			return
		elif fiveXfiveTypes[WATER] > 5:
			make_at(water, currentPos)
		elif fiveXfiveTypes[GRASS] > 8:
			make_at(water, currentPos)
		elif fiveXfiveTypes[TREE] > 7:
			return
		else:
			make_at(water, currentPos)
		i += 1

func make_at(scene, pos : Vector2):
	var new_child = scene.instance()
	new_child.position = pos
	add_child(new_child)
	var old_tile = null
	if map[int(pos.x / tileSize)][int(pos.y / tileSize)] != null:
		old_tile = map[int(pos.x / tileSize)][int(pos.y / tileSize)]
	map[int(pos.x / tileSize)][int(pos.y / tileSize)] = new_child
	if old_tile:
		old_tile.queue_free()
	
func get_5_by_5(tileScene):
	var centerCoord = Vector2(int(tileScene.position.x / tileSize), int(tileScene.position.y / tileSize))
	var fiveXfive = [[], [], [], [], []]
	for x in 5:
		for y in 5:
			fiveXfive[x].append(map[centerCoord.x - 2 + x][centerCoord.y - 2 + y])
	return fiveXfive
	
func get5x5TypeList(pos):
	var tileTypeList = []
	var typeList = [0, 0, 0, 0, 0, 0] #{WATER, CASTLE, HOUSE, GRASS, MOUNTAIN, TREE}
	
	for x in 5:
		for y in 5:
			if pos.x - 2 + x < mapCols and pos.y - 2 + y < mapRows:
				tileTypeList.append(map[pos.x - 2 + x][pos.y - 2 + y].type)
	for j in tileTypeList.size():
		if tileTypeList[j] == 0:
			typeList[0] += 1
		if tileTypeList[j] == 1:
			typeList[1] += 1
		if tileTypeList[j] == 2:
			typeList[2] += 1
		if tileTypeList[j] == 3:
			typeList[3] += 1
		if tileTypeList[j] == 4:
			typeList[4] += 1
		if tileTypeList[j] == 5:
			typeList[5] += 1
	return typeList #{WATER, CASTLE, HOUSE, GRASS, MOUNTAIN, TREE}


func _on_Button_pressed():
	generate_rivers()


func _on_Button2_pressed():
	get_tree().reload_current_scene()
