extends Node

@export var tile_unlock_array: Array[UnlockTile]

@export var mill_unlock: Demand
@export var sawmill_unlock: Demand

func _ready() -> void:
	for tile_unlock in tile_unlock_array:
		tile_unlock.working_station.unlock_demand_completed.connect(_on_unlock_demand_completion)

func _on_unlock_demand_completion(demand: Demand):
	if demand == mill_unlock:
		Global.get_player().boomerang.hitbox.damage = 10
	if demand == sawmill_unlock:
		Global.get_player().boomerang.upgraded = true
