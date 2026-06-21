extends Node2D

const BRIDGE_SCENE = "res://tiles/bridge.tscn"
	
func draw_bridges():
	var bridge = preload(BRIDGE_SCENE)
	for border in get_parent().border_c.borders:
		if get_parent().border_c.borders[border] == Global.border_types.bridge:
			if get_parent().find_child(border + "Bridge"):
				pass
			var bridge_instance = bridge.instantiate()
			get_parent().add_child(bridge_instance)
			bridge_instance.name = border + "Bridge"
			bridge_instance.find_child("StaticBody2D").rotation_degrees = Global.rot_dict.get(border)
			bridge_instance.find_child(border + "Bridge").visible = true
			check_for_completed_bridges(bridge_instance,border)
		else:
			if get_parent().get_node(border + "Bridge"):
				get_parent().get_node(border + "Bridge").queue_free()
			pass
	
func check_for_completed_bridges(bridge_instance: Node2D,border):
	var opposite = Global.opposite_dict.get(border)
	
	if get_parent().neighbours.get(border):
		if get_parent().neighbours.get(border).find_child("border_component").borders.get(opposite) == Global.border_types.bridge:
			bridge_instance.find_child("MidPart").disabled = true
		else: 
			bridge_instance.find_child("MidPart").disabled = false
