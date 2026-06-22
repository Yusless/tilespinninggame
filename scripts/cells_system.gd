extends Node
const DIST_BETWEEN_TILES = 280
const FIELD_WIDTH = 3
const FIELD_HEIGHT = 3

var map = []


func _ready() -> void:
	create_map_from_tiles()
	for tile in get_tiles_as_array():
		get_neighbours(tile)
	update_all_bridges()
	
	
func create_map_from_tiles() -> void:
	for i in range(FIELD_HEIGHT):
		map.append([])
		for j in range(FIELD_WIDTH):
			map[i].append(null)

	var tiles = get_tiles_as_array()
	for tile in tiles:
		if tile is Tile:
			var pos = get_map_position(tile)
			map[pos.y][pos.x] = tile


func get_map_position(tile: Tile) :
	var pos_x = tile.position.x 
	var pos_y = tile.position.y

	pos_x = int(pos_x/DIST_BETWEEN_TILES)
	pos_y = int(pos_y/DIST_BETWEEN_TILES)

	return Vector2i(pos_x,pos_y)

func get_neighbours(tile):
	var neighbours_dict: Dictionary[Side.Sides, Tile] = {Side.Sides.UP: null,
						Side.Sides.RIGHT: null,
						Side.Sides.DOWN: null,
						Side.Sides.LEFT: null
						}
	var pos = get_map_position(tile)
	if pos.y - 1 > -1 and map[pos.y - 1][pos.x]:
		neighbours_dict.set(Side.Sides.UP, map[pos.y - 1][pos.x])
	if pos.y + 1 < FIELD_HEIGHT and map[pos.y + 1][pos.x]:
		neighbours_dict.set(Side.Sides.DOWN, map[pos.y + 1][pos.x])
	if pos.x - 1 > -1 and map[pos.y][pos.x - 1]:
		neighbours_dict.set(Side.Sides.LEFT, map[pos.y][pos.x - 1])
	if  pos.x + 1 < FIELD_WIDTH and map[pos.y][pos.x + 1]:
		neighbours_dict.set(Side.Sides.RIGHT, map[pos.y][pos.x + 1])
	tile.neighbours = neighbours_dict
	return neighbours_dict

func get_tiles_as_array():
	return get_children()
	
func update_all_bridges():
	for tile in get_tiles_as_array():
		for side in tile.border_objects:
			var border = tile.border_objects[side]
			if border is Bridge:
				border.update()


func check_for_interactions():
	for tile in get_tiles_as_array():
		for side in tile.neighbours:
			if tile.neighbours[side]:
				if tile.can_interact(tile.neighbours[side], side):
					tile.interact(tile.neighbours[side], side)
			
func submit_tile_position():
	check_for_interactions()
