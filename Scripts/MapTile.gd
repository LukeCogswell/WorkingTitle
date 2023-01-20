extends Sprite

class_name MapTile

enum TILE_TYPES {WATER = 0, CASTLE, HOUSE, GRASS, MOUNTAIN, TREE}

export(TILE_TYPES) var type = TILE_TYPES.WATER