extends Node2D
class_name TileContents

const CELL_SIZE := 16
const TILE_SIZE := 16

@export var rotation_time := 0.15 + 0.1

@export var tile_map_ground: TileMapLayer
@export var tile_map_details: TileMapLayer
@export var tile_map_texture: TileMapLayer

var tilemaps: Array[TileMapLayer]
var nodes: Array[Node2D]

func _ready() -> void:
	for child in get_children():
		if child is TileMapLayer:
			tilemaps.push_back(child)
		else:
			nodes.push_back(child)

func rotate_contents():
	var tween := create_tween()
	tween.tween_property(self, "rotation", rotation - PI/12, rotation_time * 0.6).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "rotation", rotation + PI/2 + PI/12, rotation_time * 0.4).set_ease(Tween.EASE_IN_OUT)
	for layer in tilemaps:
		tween.tween_callback(rotate_tilemap.bind(layer, 90.0))
	for node in nodes:
		tween.tween_callback(rotate_node.bind(node, 90.0))
	tween.tween_property(self, "rotation", PI/12, 0.0)
	tween.tween_property(self, "rotation", 0, rotation_time * 0.4).set_ease(Tween.EASE_OUT)

func get_cell_array(tilemap: TileMapLayer) -> Array[Array]:
	var res: Array[Array] = []
	for y in range(TILE_SIZE):
		res.push_back([])
		for x in range(TILE_SIZE):
			var cell_coords = Vector2(
				-CELL_SIZE * TILE_SIZE/2.0 + x * CELL_SIZE,
				-CELL_SIZE * TILE_SIZE/2.0 + y * CELL_SIZE,
			)
			var tile_data = tilemap.get_cell_tile_data(tilemap.local_to_map(cell_coords))
			var atlas_coords = tilemap.get_cell_atlas_coords(tilemap.local_to_map(cell_coords))
			res[y].push_back(
				{
					tile_data = tile_data,
					atlas_coords = atlas_coords,
				}
			)
	return res

func get_rotated_array_by_degrees(array: Array[Array], degrees: float) -> Array[Array]:
	var res: Array[Array] = array.duplicate(true)
	var rotations := floori(degrees / 90.0)
	for x in range(rotations):
		var transposed_array = res.duplicate(true)
		for i in range(res.size()):
			for j in range(res.size()):
				transposed_array[i][j] = res[j][i]
				transposed_array[j][i] = res[i][j]
		res = transposed_array
		for i in range(res.size()):
			res[i].reverse()
	return res

func rotate_node(node: Node2D, degrees: float):
	var rotations := floori(degrees / 90.0)
	var new_pos := node.position.rotated(PI/2 * rotations)
	node.position = new_pos
	if node.is_in_group("NeedsRotationChanged"):
		node.rotate(PI/2 * rotations)

func rotate_tilemap(tilemap: TileMapLayer, degrees: float):
	if tilemap.name == "TileMapGround":
		return
	var array := get_cell_array(tilemap)
	var rotated_array := get_rotated_array_by_degrees(array, degrees)
	tilemap.clear()
	var terrains := {}
	for y in range(rotated_array.size()):
		for x in range(rotated_array.size()):
			var cell = rotated_array[y][x]
			var tile_data: TileData = cell.tile_data
			var atlas_coords: Vector2i = cell.atlas_coords
			var cell_coords = Vector2i(x-int(TILE_SIZE/2.0), y-int(TILE_SIZE/2.0))
			if tile_data:
				if tile_data.terrain_set != -1:
					if [tile_data.terrain_set, tile_data.terrain] not in terrains:
						terrains[[tile_data.terrain_set, tile_data.terrain]] = []
					terrains[[tile_data.terrain_set, tile_data.terrain]].push_back(cell_coords)
				else:
					tilemap.set_cell(
						cell_coords,
						0,
						atlas_coords
					)
	for terrain in terrains:
		tilemap.set_cells_terrain_connect(terrains[terrain], terrain[0], terrain[1])

func reset():
	for node in nodes:
		if node.is_in_group("NeedsResetting") and node.has_method("reset"):
			if node.has_method("deactivate"):
				node.deactivate()
			node.reset()

func activate():
	for node in nodes:
		if node.has_method("activate"):
			node.activate()
