extends Node

const DIST_BETWEEN_TILES = 368

enum border_types {
	nothing,
	wall,
	bridge
}

var resource_list := [
	preload("res://natural_resources/wheat_resource.tres"),
	preload("res://natural_resources/wood_resource.tres"),
]

var treat_tiles_as_interface := false

func get_manager(manager_type: Object):
	for mgr in get_tree().get_nodes_in_group("Managers"):
		if is_instance_of(mgr, manager_type):
			return mgr

func get_player() -> Player:
	return get_tree().get_first_node_in_group("Player")
