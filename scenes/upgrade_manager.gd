extends Node

@export var tile_unlock_1: Unlock1Tile


func _ready() -> void:
	tile_unlock_1.mill.unlock_1_demand_completed.connect(_on_unlock_1_demand_completion)

func _on_unlock_1_demand_completion(demand: Demand):
	Global.get_player().boomerang.hitbox.damage = 4
