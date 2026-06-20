extends Node

func get_manager(manager_type: Object):
	for mgr in get_tree().get_nodes_in_group("Managers"):
		if is_instance_of(mgr, manager_type):
			return mgr
