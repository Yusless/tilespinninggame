extends Node2D
class_name Tile

const BRIDGE_SCENE = "res://tiles/bridge.tscn"

const ELEVATING_BY_HOVERING = 20

var hovering_before_interacting

var interaction_dict = {
	TileTypes.HUB: [],
	TileTypes.FOREST: [TileTypes.LAVA_LAKE],
	TileTypes.WHEAT: [TileTypes.LAVA_LAKE],
	TileTypes.LAVA_LAKE: [TileTypes.FOREST, TileTypes.WHEAT],
	TileTypes.EMPTY: [],
	TileTypes.POND: []
}

enum TileTypes {
	HUB,
	FOREST,
	WHEAT,
	LAVA_LAKE,
	EMPTY,
	POND
}

enum BorderTypes {
	NOTHING,
	WALL,
	BRIDGE
}
@export var tile_type = TileTypes.HUB

@export var demand_for_unlock: Demand
var unlocked: bool
var rotatable: = unlocked

@export var up_bridge_collision = CollisionShape2D
@export var right_bridge_collision = CollisionShape2D
@export var down_bridge_collision = CollisionShape2D
@export var left_bridge_collision = CollisionShape2D

@export var left_border = BorderTypes.NOTHING
@export var up_border = BorderTypes.NOTHING
@export var right_border = BorderTypes.NOTHING
@export var down_border = BorderTypes.NOTHING

@export var tile_contents: TileContents

@export var color_rect: ColorRect


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

var treated_as_interface := false
var default_position: Vector2
var hovering_position: Vector2

func _ready() -> void:
	unlocked = !demand_for_unlock
	rotatable = !demand_for_unlock
	set_tile_contents_modulation()
	collisions_from_export()
	borders_from_export()
	place_yourself()
	init_bridges_to_tile()
	remove_colissions()
	
	var player := Global.get_player()
	player.lighthouse_entered.connect(_on_player_lighthouse_entered)
	player.lighthouse_exited.connect(_on_player_lighthouse_exited)
	
	default_position = position
	hovering_position = position + Vector2(0.0, -ELEVATING_BY_HOVERING)

func remove_colissions() -> void:
	for bridge_collision in bridges_collisions:
		if borders[bridge_collision] == BorderTypes.BRIDGE:
			bridges_collisions[bridge_collision].disabled = true
		else:
			bridges_collisions[bridge_collision].disabled = false


func place_yourself() -> void:
	var pos_x = position.x 
	var pos_y = position.y
	
	pos_x = int(pos_x/Global.DIST_BETWEEN_TILES)
	pos_y = int(pos_y/Global.DIST_BETWEEN_TILES)
	
	position.x = pos_x * Global.DIST_BETWEEN_TILES
	position.y = pos_y * Global.DIST_BETWEEN_TILES

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
			tile_contents.add_child(bridge_instance)
			bridge_instance.side = side
			bridge_instance.tile = self
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
	if treated_as_interface and tile_type != TileTypes.HUB and rotatable:
		position = hovering_position
	else:
		hovering_before_interacting = true

func _on_area_2d_mouse_exited() -> void:
	if treated_as_interface and rotatable and !hovering_before_interacting:
		position = default_position
	else: 
		hovering_before_interacting = false


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if Global.get_player().state == Global.get_player().States.INSIDE and event.is_action_pressed("attack") and rotatable:
		tile_contents.rotate_contents()
		create_tween().tween_callback(rotate_self).set_delay(tile_contents.rotation_time)

func _on_player_lighthouse_entered():
	treated_as_interface = true

func _on_player_lighthouse_exited():
	treated_as_interface = false
	if position != default_position:
		position = default_position

	
func can_interact(neighbour, side) -> bool:
	if neighbour.tile_type in interaction_dict[tile_type]:
		if neighbour.border_objects[Side.get_opposite(side)] is Bridge and border_objects[side] is Bridge:
			return true
	return false
	
func interact(neighbour: Tile, side: Side.Sides):
	print(self, 'HAS INTERACTED WITH', neighbour, "BY", side)

func reset():
	set_tile_contents_modulation()
	for child in get_children():
		if child.has_method("reset") and child.is_in_group("NeedsResetting"):
			child.reset()

func activate():
	for child in get_children():
		if child.has_method("activate"):
			child.activate()
	
func unlock():
	unlocked = true
	rotatable = true

func set_tile_contents_modulation():
	if unlocked:
		color_rect.visible = false
		tile_contents.modulate = Color("ffffff")
	else:
		color_rect.visible = true
		tile_contents.modulate = Color("1a1a1aff")
