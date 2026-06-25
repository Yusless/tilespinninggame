extends Tile
class_name FlammableTile

var res_nodes: Array[NaturalResourceNode] = []

func _ready() -> void:
	super()
	for node in tile_contents.get_children():
		if node is NaturalResourceNode:
			res_nodes.push_back(node)

func burn():
	for node in res_nodes:
		node.burn()
