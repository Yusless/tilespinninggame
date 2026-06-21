extends Node

enum border_types {
	nothing,
	wall,
	bridge
}

var opposite_dict = {"up": "down",
				"right": "left",
				"down": "up",
				"left": "right"
}

var rot_dict = {"up": -90,
				"right": 0,
				"down": 90,
				"left": 180
}


func get_manager(manager_type: Object):
	for mgr in get_tree().get_nodes_in_group("Managers"):
		if is_instance_of(mgr, manager_type):
			return mgr

func get_player() -> Player:
	return get_tree().get_first_node_in_group("Player")
