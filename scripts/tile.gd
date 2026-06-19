extends Node2D
enum tile_types {
	hub,
	fan,
	campfire,
	river,
}


@export var tile_type = tile_types.hub
@export var has_bridges = { "up": false,
							"right": false,
							"down": false,
							"left": false
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
	check_for_bridges()

func check_for_bridges():
	for bridge_collision in bridges_collisions:
		if has_bridges.get(bridge_collision):
			bridges_collisions.get(bridge_collision).disabled = true
	
