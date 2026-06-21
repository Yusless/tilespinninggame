@tool
extends Node2D

@export var bridge_right := false
@export var bridge_down := false
@export var bridge_left := false
@export var bridge_up := false

@export var right_bridge: Sprite2D
@export var left_bridge: Sprite2D
@export var up_bridge: Sprite2D
@export var down_bridge: Sprite2D

func _ready() -> void:
	right_bridge.show()

func _process(delta: float) -> void:
	right_bridge.visible = bridge_right
