extends Control
class_name HUD

@export var hub_tile: HubTile
@export var resource_goal: ResourceDemander
@export var spin_mode_guide: HBoxContainer

func _ready() -> void:
	hub_tile.lighthouse.upgrade_table.resource_demander.demand_set.connect(_on_upgrade_table_demand_set)
	resource_goal.set_demand(hub_tile.lighthouse.upgrade_table.resource_demander.demand)
	hub_tile.lighthouse.expedition_finished.connect(_on_expedtion_finished)
	hub_tile.lighthouse.expedition_started.connect(_on_expedtion_started)
	spin_mode_guide.hide()
	

func _on_upgrade_table_demand_set(demand: Demand):
	resource_goal.set_demand(demand)

func _on_expedtion_finished():
	spin_mode_guide.show()

func _on_expedtion_started():
	spin_mode_guide.hide()
