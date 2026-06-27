extends Control
class_name HUD

@export var hub_tile: HubTile
@export var resource_goal: ResourceDemander
@export var spin_mode_guide: HBoxContainer
@export var dash_counter: DashCounter
@export var dash_panel: PanelContainer

var player: Player

func _ready() -> void:
	hub_tile.lighthouse.upgrade_table.resource_demander.demand_set.connect(_on_upgrade_table_demand_set)
	resource_goal.set_demand(hub_tile.lighthouse.upgrade_table.resource_demander.demand)
	hub_tile.lighthouse.expedition_finished.connect(_on_expedtion_finished)
	hub_tile.lighthouse.expedition_started.connect(_on_expedtion_started)
	spin_mode_guide.hide()
	player = Global.get_player()
	dash_panel.hide()

func _process(delta: float) -> void:
	if player:
		if player.max_dashes:
			dash_panel.show()
			
		dash_counter.counter.text = str(player.max_dashes)

func _on_upgrade_table_demand_set(demand: Demand):
	resource_goal.set_demand(demand)

func _on_expedtion_finished():
	spin_mode_guide.show()

func _on_expedtion_started():
	spin_mode_guide.hide()
