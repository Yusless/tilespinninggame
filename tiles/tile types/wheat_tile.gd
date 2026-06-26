extends Tile
class_name FlammableTile

@export var fires: Node2D

var res_nodes: Array[NaturalResourceNode] = []

func _ready() -> void:
	super()
	for node in tile_contents.get_children():
		if node is NaturalResourceNode:
			res_nodes.push_back(node)
	if fires:
		fires.hide()

func burn():
	for node in res_nodes:
		node.burn()
	if fires:
		fires.show()

func reset():
	super()
	if fires:
		fires.hide()
