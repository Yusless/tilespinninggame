extends Node

var tile_scene = preload("res://scenes/Tile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	replace_tileset_with_cells()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func replace_tileset_with_cells():
	var layer = get_node("TileMapLayer")
	var tiles = layer.get_used_cells()
	for tile in tiles:
		var tile_position = layer.map_to_local(tile)
		layer.to_global(tile_position)
		
		var node = tile_scene.instantiate()
		node.position = tile_position
		add_child(node)
		
		
