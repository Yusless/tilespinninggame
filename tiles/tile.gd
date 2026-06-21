extends Node2D
class_name Tile

const BRIDGE_SCENE = "res://tiles/bridge.tscn"

const ELEVATING_BY_HOVERING = 20

var hovering_before_interacting

enum TileTypes {
	HUB,
	FOREST,
	PLAIN,
	RIVER,
	MOUNTAIN
}

enum BorderTypes {
	NOTHING,
	WALL,
	BRIDGE
}

const DIST_BETWEEN_TILES = 285

@export var tile_type = TileTypes.HUB

@export var up_bridge_collision = CollisionShape2D
@export var right_bridge_collision = CollisionShape2D
@export var down_bridge_collision = CollisionShape2D
@export var left_bridge_collision = CollisionShape2D

@export var left_border = BorderTypes.NOTHING
@export var up_border = BorderTypes.NOTHING
@export var right_border = BorderTypes.NOTHING
@export var down_border = BorderTypes.NOTHING

var borders = {}

var border_objects: Dictionary[Side.Sides, Border] = { Side.Sides.UP: null,
				Side.Sides.RIGHT: null,
				Side.Sides.DOWN: null,
				Side.Sides.LEFT: null
				}

var bridges_collisions = {}

var neighbours: Dictionary[Side.Sides, Tile] = {Side.Sides.UP:null,
				Side.Sides.RIGHT:null,
				Side.Sides.DOWN:null,
				Side.Sides.LEFT:null
}

@export var visual_c: VisualComponent =  null

func _ready() -> void:
	collisions_from_export()
	borders_from_export()
	place_yourself()
	init_bridges_to_tile()
	remove_colissions()

func remove_colissions() -> void:
	for bridge_collision in bridges_collisions:
		if borders[bridge_collision] == BorderTypes.BRIDGE:
			bridges_collisions[bridge_collision].disabled = true
		else:
			bridges_collisions[bridge_collision].disabled = false


func place_yourself() -> void:
	var pos_x = position.x 
	var pos_y = position.y
	
	pos_x = int(pos_x/DIST_BETWEEN_TILES)
	pos_y = int(pos_y/DIST_BETWEEN_TILES)
	
	position.x = pos_x * DIST_BETWEEN_TILES
	position.y = pos_y * DIST_BETWEEN_TILES

func borders_from_export():
	borders = {Side.Sides.UP: up_border,
				Side.Sides.RIGHT: right_border,
				Side.Sides.DOWN: down_border,
			 	Side.Sides.LEFT: left_border
				}
	
func rotate_self():
	rotate_borders()
	rotate_bridges_to_tile()
	remove_colissions()


func collisions_from_export() -> void:
	bridges_collisions = {Side.Sides.UP: up_bridge_collision,
						Side.Sides.RIGHT: right_bridge_collision,
						Side.Sides.DOWN: down_bridge_collision,
						Side.Sides.LEFT: left_bridge_collision
						}

func rotate_borders() -> void:
	var temp = borders[Side.Sides.UP]
	borders[Side.Sides.UP] = borders[Side.Sides.LEFT]
	borders[Side.Sides.LEFT] =  borders[Side.Sides.DOWN]
	borders[Side.Sides.DOWN] =  borders[Side.Sides.RIGHT]
	borders[Side.Sides.RIGHT] =  temp


func init_bridges_to_tile() -> void:
	var bridge = preload(BRIDGE_SCENE)
	for side in borders:
		if borders[side] == BorderTypes.BRIDGE:
			var bridge_instance = bridge.instantiate()
			border_objects[side] = bridge_instance
			add_child(bridge_instance)
			bridge_instance.side = side
			bridge_instance.update()

func rotate_bridges_to_tile() -> void:
	var temp = border_objects[Side.Sides.UP]
	border_objects[Side.Sides.UP] = border_objects[Side.Sides.LEFT]
	if border_objects[Side.Sides.UP]:
		border_objects[Side.Sides.UP].side = Side.Sides.UP
	border_objects[Side.Sides.LEFT] =  border_objects[Side.Sides.DOWN]
	if border_objects[Side.Sides.LEFT]:
		border_objects[Side.Sides.LEFT].side = Side.Sides.LEFT
	border_objects[Side.Sides.DOWN] =  border_objects[Side.Sides.RIGHT]
	if border_objects[Side.Sides.DOWN]:
		border_objects[Side.Sides.DOWN].side = Side.Sides.DOWN
	border_objects[Side.Sides.RIGHT] =  temp
	if border_objects[Side.Sides.RIGHT]:
		border_objects[Side.Sides.RIGHT].side = Side.Sides.RIGHT
	for dir in border_objects:
		if border_objects[dir] is Bridge:
			border_objects[dir].update()


func _on_area_2d_mouse_entered() -> void:
	if Global.get_player().state == Global.get_player().States.INSIDE and tile_type != TileTypes.HUB:
		position.y -= ELEVATING_BY_HOVERING 
	else:
		hovering_before_interacting = true

func _on_area_2d_mouse_exited() -> void:
	if Global.get_player().state == Global.get_player().States.INSIDE and tile_type != TileTypes.HUB and !hovering_before_interacting:
		position.y += ELEVATING_BY_HOVERING 
	else: 
		hovering_before_interacting = false


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Global.get_player().state == Global.get_player().States.INSIDE and event.is_action_pressed("attack"):
		rotate_self()
