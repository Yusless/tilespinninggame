extends Node
const FIELD_WIDTH = 5
const FIELD_HEIGHT = 5

var map = []

var unlock_dict: Dictionary[Demand, Array] = {}

@export var hub_tile: HubTile
@export var environment_manager: EnvironmentManager
@export var player: Player

func _ready() -> void:
	create_map_from_tiles()
	for tile in get_tiles_as_array():
		get_neighbours(tile)
	update_all_bridges()
	hub_tile.lighthouse.expedition_finished.connect(_on_lighthouse_expedition_finished)
	hub_tile.lighthouse.expedition_started.connect(_on_lighthouse_expedition_started)
	player.died.connect(_on_player_died)
	hub_tile.upgrade_table.demand_completed.connect(_on_demand_completed)
	
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
	for tile in tiles:
		if tile.demand_for_unlock:
			if tile.demand_for_unlock not in unlock_dict:
				unlock_dict[tile.demand_for_unlock] = []
			unlock_dict[tile.demand_for_unlock].append(tile)


func get_map_position(tile: Tile) :
	var pos_x = tile.position.x 
	var pos_y = tile.position.y

	pos_x = int(pos_x/Global.DIST_BETWEEN_TILES)
	pos_y = int(pos_y/Global.DIST_BETWEEN_TILES)

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

func get_tiles_as_array() -> Array[Tile]:
	var res := []
	for child in get_children():
		if child is Tile:
			res.push_back(child)
	return res
	
func update_all_bridges():
	for tile in get_tiles_as_array():
		for side in tile.border_objects:
			var border = tile.border_objects[side]
			if border is Bridge:
				border.update()

func reset_tiles():
	for tile in get_tiles_as_array():
		tile.reset()

func activate_tiles():
	for tile in get_tiles_as_array():
		if tile.rotatable:
			tile.activate()

func check_for_interactions():
	for tile: Tile in get_tiles_as_array():
		for side in tile.neighbours:
			if tile.neighbours[side]:
				if tile.can_interact(tile.neighbours[side], side):
					tile.interact(tile.neighbours[side], side)
			
func submit_tile_position():
	check_for_interactions()

func _on_lighthouse_expedition_finished():
	environment_manager.switch_to_night()
	reset_tiles()

func _on_lighthouse_expedition_started():
	environment_manager.switch_to_day()
	update_all_bridges()
	activate_tiles()


func _on_player_died():
	reset_tiles()
	hub_tile.lighthouse.start_expedition()
	player.spawn()

func _on_demand_completed(demand: Demand):
	unlock_tiles(demand)


func unlock_tiles(demand: Demand):
	if demand in unlock_dict:
		for tile in unlock_dict[demand]:
			tile.unlock()
