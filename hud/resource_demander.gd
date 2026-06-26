extends Control
class_name ResourceDemander

signal demand_set(new_demand: Demand)

@export var number_root: GridContainer

var demand: Demand
var res_nums: Array[ResourceNumber]

func _ready() -> void:
	for num in number_root.get_children():
		if num is ResourceNumber:
			res_nums.push_back(num)

func set_demand(new_demand: Demand):
	demand = new_demand
	for num in res_nums:
		if num.resource in demand.resources_needed:
			num.update(demand.resources_needed[num.resource])
		else:
			num.update(0)
	demand_set.emit(new_demand)

func is_demand_met() -> bool:
	var res_mgr: ResourceManager = Global.get_manager(ResourceManager)
	for res in demand.resources_needed:
		if res_mgr.resource_amounts[res] < demand.resources_needed[res]:
			return false
	return true
