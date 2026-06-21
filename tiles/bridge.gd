extends Border

class_name Bridge

var side: Side.Sides = Side.Sides.UP
@export var mid_part: CollisionShape2D
@export var hit_box: StaticBody2D

@export var right_bridge_sprite: Sprite2D
@export var left_bridge_sprite: Sprite2D
@export var up_bridge_sprite: Sprite2D
@export var down_bridge_sprite: Sprite2D



var rot_dict = {Side.Sides.UP: -90,
				Side.Sides.RIGHT: 0,
				Side.Sides.DOWN: 90,
				Side.Sides.LEFT: 180
}
var sprite_to_side = {}

func _ready() -> void:
	sprite_to_side = {Side.Sides.UP:up_bridge_sprite,
				Side.Sides.RIGHT: right_bridge_sprite,
				Side.Sides.DOWN:down_bridge_sprite,
				Side.Sides.LEFT:left_bridge_sprite
				}

func check_for_completed_bridges(recursive = true):
	var opposite = Side.get_opposite(side)
	var tile: Tile = get_parent()
	var neighbour_by_side = tile.neighbours[side]
	mid_part.disabled = false
	if neighbour_by_side:
		if neighbour_by_side.border_objects[opposite] is Bridge:
			mid_part.disabled = true
	if recursive == true:
		for direction in tile.neighbours:
			neighbour_by_side = tile.neighbours[direction]
			opposite = Side.get_opposite(direction)
			if neighbour_by_side and neighbour_by_side.border_objects[opposite] is Bridge:
				neighbour_by_side.border_objects[opposite].check_for_completed_bridges(false)


func update():
	hit_box.rotation_degrees = rot_dict[side]
	sprite_to_side[side].visible = true
	var tile = get_parent()
	for dir in tile.borders:
		if dir != side:
			sprite_to_side[dir].visible = false
	check_for_completed_bridges(true)
