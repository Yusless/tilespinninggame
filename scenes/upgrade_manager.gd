extends Node

@export var tile_unlock_array: Array[UnlockTile]
@export var hub_tile: HubTile


@export var mill_unlock: Demand
@export var sawmill_unlock: Demand
@export var loom_unlock: Demand
@export var final_unlock: Demand

func _ready() -> void:
	for tile_unlock in tile_unlock_array:
		tile_unlock.working_station.unlock_demand_completed.connect(_on_unlock_demand_completion)
	hub_tile.lighthouse.upgrade_table.demand_completed.connect(_on_unlock_demand_completion)

func _on_unlock_demand_completion(demand: Demand):
	print(demand)
	if demand == mill_unlock:
		Global.get_player().boomerang.hitbox.damage = 10
	if demand == sawmill_unlock:
		Global.get_player().boomerang.upgraded = true
	if demand == loom_unlock:
		Global.get_player().max_dashes = 2
	if demand == final_unlock:
		get_tree().change_scene_to_file("res://scenes/thanks_for_playing.tscn")
