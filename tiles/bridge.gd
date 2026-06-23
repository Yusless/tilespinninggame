extends Border
class_name Bridge

var side: Side.Sides = Side.Sides.UP
@export var mid_part: CollisionShape2D
@export var hit_box: StaticBody2D

@export var right_bridge_sprite: Node2D
@export var left_bridge_sprite: Node2D
@export var up_bridge_sprite: Node2D
@export var down_bridge_sprite: Node2D
@export var merge_part_left: TileMapLayer
@export var merge_part_up: TileMapLayer

var rot_dict = {Side.Sides.UP: -90,
				Side.Sides.RIGHT: 0,
				Side.Sides.DOWN: 90,
				Side.Sides.LEFT: 180
}
var sprite_to_side := {}
var side_to_collision := {}
var side_to_collision_shapes := {}
var side_to_middle := {}
var tile: Tile

func _ready() -> void:
	sprite_to_side = {Side.Sides.UP:up_bridge_sprite,
				Side.Sides.RIGHT: right_bridge_sprite,
				Side.Sides.DOWN:down_bridge_sprite,
				Side.Sides.LEFT:left_bridge_sprite
				}
	side_to_collision = {
		Side.Sides.UP: $CollisionUp,
		Side.Sides.RIGHT: $CollisionRight,
		Side.Sides.DOWN: $CollisionDown,
		Side.Sides.LEFT: $CollisionLeft,
	}
	side_to_middle = {
		Side.Sides.UP: $CollisionUp/MidPart,
		Side.Sides.RIGHT: $CollisionRight/MidPart,
		Side.Sides.DOWN: $CollisionDown/MidPart,
		Side.Sides.LEFT: $CollisionLeft/MidPart,
	}
	for s in Side.Sides.values():
		side_to_collision_shapes[s] = side_to_collision[s].get_children()

func check_for_completed_bridges(recursive = true):
	var opposite = Side.get_opposite(side)
	var neighbour_by_side = tile.neighbours[side]
	side_to_middle[side].disabled = false
	merge_part_left.hide()
	merge_part_up.hide()
	if neighbour_by_side:
		if neighbour_by_side.border_objects[opposite] is Bridge and neighbour_by_side.unlocked and tile.unlocked:
			side_to_middle[side].disabled = true
			if side == Side.Sides.UP:
				merge_part_up.show()
			if side == Side.Sides.LEFT:
				merge_part_left.show()
	if recursive == true:
		for direction in tile.neighbours:
			neighbour_by_side = tile.neighbours[direction]
			opposite = Side.get_opposite(direction)
			if neighbour_by_side and neighbour_by_side.border_objects[opposite] is Bridge:
				neighbour_by_side.border_objects[opposite].check_for_completed_bridges(false)

func enable_collision_on_side(s: Side.Sides):
	for shape in side_to_collision_shapes[s]:
		shape.disabled = false

func disable_collision_on_side(s: Side.Sides):
	for shape in side_to_collision_shapes[s]:
		shape.disabled = true

func update():
	for s in Side.Sides.values():
		if s == side:
			enable_collision_on_side(s)
		else:
			disable_collision_on_side(s)
	sprite_to_side[side].visible = true
	for dir in tile.borders:
		if dir != side:
			sprite_to_side[dir].visible = false
	check_for_completed_bridges(true)
