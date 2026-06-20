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
	place_yourself()
	remove_colissions()

func remove_colissions() -> void:
	component_data_to_border_data()
	for bridge_collision in bridges_collisions:
		borders = component_data_to_border_data()
		if borders.get(bridge_collision) == border_types.bridge:
			bridges_collisions.get(bridge_collision).disabled = true


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
