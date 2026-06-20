extends Node2D

enum border_types {
	nothing,
	wall,
	bridge
}
const BRIDGE_SCENE = "res://scenes/tiles/bridge.tscn"

var rot_dict = {"up": -90,
				"right": 0,
				"down": 90,
				"left": 180
}

var opposite_dict = {"up": "down",
				"right": "left",
				"down": "up",
				"left": "right"
}

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
	
func draw_bridges():
	var bridge = preload(BRIDGE_SCENE)
	for border in get_parent().border_c.borders:
		if get_parent().border_c.borders[border] == border_types.bridge:
			if get_parent().find_child(border + "Bridge"):
				pass
			var bridge_instance = bridge.instantiate()
			get_parent().add_child(bridge_instance)
			bridge_instance.name = border + "Bridge"
			bridge_instance.find_child("StaticBody2D").rotation_degrees = rot_dict.get(border)
			bridge_instance.find_child(border + "Bridge").visible = true
			check_for_completed_bridges(bridge_instance,border)
		else:
			if get_parent().get_node(border + "Bridge"):
				get_parent().get_node(border + "Bridge").queue_free()
			pass
	
func check_for_completed_bridges(bridge_instance,border):
	var opposite = opposite_dict.get(border)
	if get_parent().neighbours.get(border):
		if get_parent().neighbours.get(border).find_child("border_component").borders.get(opposite) == border_types.bridge:
			bridge_instance.find_child("MidPart").disabled = true
		else: 
			bridge_instance.find_child("MidPart").disabled = false
