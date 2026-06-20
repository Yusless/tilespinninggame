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

const DIST_BETWEEN_TILES = 285

var neighbours = {"up":null,
				"right":null,
				"down":null,
				"left":null
}

var border_c
var visual_c

@export var tile_type = tile_types.hub

@export var up_bridge_collision = CollisionShape2D
@export var right_bridge_collision = CollisionShape2D
@export var down_bridge_collision = CollisionShape2D
@export var left_bridge_collision = CollisionShape2D

var bridges_collisions = {}

func _ready() -> void:	
	border_c = find_child("border_component")
	visual_c = find_child("visual_component")
	bridges_collisions = {"up": up_bridge_collision,
						"right": right_bridge_collision,
						"down": down_bridge_collision,
						"left": left_bridge_collision
						}
	place_yourself()
	remove_colissions()

func remove_colissions() -> void:
	for bridge_collision in bridges_collisions:
		if border_c.borders.get(bridge_collision) == border_types.bridge:
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
	
func rotate_self():
	border_c.rotate_borders()
	visual_c.draw_bridges()
	remove_colissions()
