extends Node



var hub_scene = preload("res://scenes/Tile.tscn")
var forest_scene = preload("res://scenes/Tile.tscn")
var plain_scene = preload("res://scenes/Tile.tscn")
var mointain_scene = preload("res://scenes/player.tscn")

var altas_coords_to_tile_scene = {
	Vector2i(0,0): hub_scene,
	Vector2i(1,0): forest_scene,
	Vector2i(0,1): plain_scene,
	Vector2i(1,1): mointain_scene
}

func _ready() -> void:
	replace_tileset_with_cells()


func _process(delta: float) -> void:
	pass


func replace_tileset_with_cells():
	var layer = get_parent().get_node("TileMapLayer")
	var cells = layer.get_used_cells()
	for cell in cells:
		var atlas_coords = layer.get_cell_atlas_coords(cell)
		var cell_position = layer.map_to_local(cell)
		
		var node = altas_coords_to_tile_scene.get(atlas_coords).instantiate()
		node.position = cell_position
		add_child(node)

func create_map_from_tileset():
	pass
