extends Node2D
class_name UpgradeTable

signal demand_completed(demand: Demand)

@export var resource_demander: ResourceDemander
@export var interaction_component: Area2D
@export var demands: Array[Demand]

var current_demand_id := 0

func _ready() -> void:
	interaction_component.area_entered.connect(_on_interaction_area_entered)
	interaction_component.area_exited.connect(_on_interaction_area_exited)
	resource_demander.set_demand(demands[current_demand_id])

func complete_demand():
	demand_completed.emit(demands[current_demand_id])
	
	var res_mgr: ResourceManager = Global.get_manager(ResourceManager)
	
	for res in demands[current_demand_id].resources_needed:
		res_mgr.detract_resource(res, demands[current_demand_id].resources_needed[res])
	
	current_demand_id += 1
	if current_demand_id < demands.size():
		resource_demander.set_demand(demands[current_demand_id])

func try_to_interact():
	if resource_demander.is_demand_met():
		complete_demand()

func _on_interaction_area_entered(_area: Area2D):
	resource_demander.show()

func _on_interaction_area_exited(_area: Area2D):
	resource_demander.hide()
