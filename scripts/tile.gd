extends Node2D
enum tile_types {
	hub,
	fan,
	campfire,
	river,
}

enum border_types {
	nothing,
	wall,
	bridge
}

const DIST_BETWEEN_TILES = 280

var neighbours = {"up":null,
				"right":null,
				"down":null,
				"left":null
}

@export var tile_type = tile_types.hub
var borders = { "up": border_types.nothing,
				"right": border_types.nothing,
				"down": border_types.nothing,
				"left": border_types.nothing
							}

@export var up_bridge_collision = CollisionShape2D
@export var right_bridge_collision = CollisionShape2D
@export var down_bridge_collision = CollisionShape2D
@export var left_bridge_collision = CollisionShape2D

var bridges_collisions = {}

func _ready() -> void:
	bridges_collisions = {"up": up_bridge_collision,
						"right": right_bridge_collision,
						"down": down_bridge_collision,
						"left": left_bridge_collision
						}
	borders = component_data_to_border_data()
	place_yourself()
	remove_colissions()

func remove_colissions() -> void:
	for bridge_collision in bridges_collisions:
		if borders.get(bridge_collision) == border_types.bridge:
			bridges_collisions.get(bridge_collision).disabled = true
		else:
			bridges_collisions.get(bridge_collision).disabled = false


func place_yourself() -> void:
	var pos_x = position.x 
	var pos_y = position.y
	
	pos_x = int(pos_x/DIST_BETWEEN_TILES)
	pos_y = int(pos_y/DIST_BETWEEN_TILES)
	
	position.x = pos_x * DIST_BETWEEN_TILES
	position.y = pos_y * DIST_BETWEEN_TILES
	
	
func component_data_to_border_data():
	if find_child("border_component"):
		return find_child("border_component").create_dict_from_export()
	return borders
	
func rotate_self():
	var temp = borders.get("up")
	borders.set("up", borders.get("left"))
	borders.set("left", borders.get("down"))
	borders.set("down", borders.get("right"))
	borders.set("right", temp)
	remove_colissions()
	
