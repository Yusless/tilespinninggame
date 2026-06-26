extends Node2D
class_name Lighthouse

signal expedition_finished
signal expedition_started
signal entered
signal exited

@export var base: Sprite2D
@export var outer_layer: Sprite2D
@export var interior: Node2D
@export var spawn_point_interior: Marker2D
@export var leave_component: InteractionComponent
@export var expedition_table_interaction: InteractionComponent
@export var upgrade_table: UpgradeTable
@export var interior_collider: StaticBody2D

@export var needs_collision_disabled: Array[StaticBody2D]

var spin_mode := false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("start_expedition") and spin_mode:
		start_expedition()
		var player = Global.get_player()
		player.exit_spin_mode()

func _ready() -> void:
	start_expedition()
	disable_interior()
	leave_component.interacted.connect(_on_leave_component_interacted)
	expedition_table_interaction.interacted.connect(_on_expedition_table_interacted)

func try_to_interact():
	var player = Global.get_player()
	player.get_inside(spawn_point_interior.global_position)
	enable_interior()

func enable_interior():
	outer_layer.hide()
	interior.show()
	for collider in needs_collision_disabled:
		collider.process_mode = Node.PROCESS_MODE_INHERIT
	entered.emit()

func disable_interior():
	outer_layer.show()
	interior.hide()
	for collider in needs_collision_disabled:
		collider.process_mode = Node.PROCESS_MODE_DISABLED
	exited.emit()

func finish_expedition():
	var player = Global.get_player()
	expedition_finished.emit()
	spin_mode = true
	upgrade_table.res_mgr.clear()
	disable_interior()
	player.hide()
	player.health_component.reset()

func start_expedition():
	var player = Global.get_player()
	expedition_started.emit()
	spin_mode = false
	upgrade_table.res_mgr.clear()
	enable_interior()
	player.show()

func _on_leave_component_interacted():
	var player = Global.get_player()
	player.get_outside()
	disable_interior()

func _on_expedition_table_interacted():
	if !spin_mode:
		finish_expedition()
		var player = Global.get_player()
		player.enter_spin_mode()
