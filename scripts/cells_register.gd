extends Node

var tile_scene = preload("res://scenes/Tile.tscn")

func _ready() -> void:
	replace_tileset_with_cells()


func _process(delta: float) -> void:
	pass


func replace_tileset_with_cells():
	var layer = get_parent().get_node("TileMapLayer")
	var tiles = layer.get_used_cells()
	for tile in tiles:
		var tile_position = layer.map_to_local(tile)
		var node = tile_scene.instantiate()
		node.position = tile_position
		add_child(node)
