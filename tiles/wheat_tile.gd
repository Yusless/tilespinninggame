extends Tile
class_name WheatTile

var wheat_nodes: Array[NaturalResourceNode] = []

func _ready() -> void:
	super()
	for node in tile_contents.get_children():
		if node is NaturalResourceNode:
			wheat_nodes.push_back(node)

func burn():
	for node in wheat_nodes:
		node.burn()
