extends Node

enum border_types {
	nothing,
	wall,
	bridge
}


func get_manager(manager_type: Object):
	for mgr in get_tree().get_nodes_in_group("Managers"):
		if is_instance_of(mgr, manager_type):
			return mgr

func get_player() -> Player:
	return get_tree().get_first_node_in_group("Player")
