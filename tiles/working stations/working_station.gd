extends Node2D
class_name WorkingStation

@export var resource_demander: ResourceDemander
@export var interaction_component: Area2D
@export var demands: Array[Demand]
@export var working_sound: AudioStreamPlayer2D

var current_demand_id := 0

var res_mgr: ResourceManager

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("forest_unlock") and current_demand_id < demands.size():
		pass
		#complete_demand()

func _ready() -> void:
	interaction_component.area_entered.connect(_on_interaction_area_entered)
	interaction_component.area_exited.connect(_on_interaction_area_exited)
	resource_demander.set_demand(demands[current_demand_id])
	res_mgr = Global.get_manager(ResourceManager)

func complete_demand():
	
	if working_sound:
		working_sound.play()

	for res in demands[current_demand_id].resources_needed:
		res_mgr.detract_resource(res, demands[current_demand_id].resources_needed[res])

	current_demand_id += 1
	if current_demand_id < demands.size():
		resource_demander.set_demand(demands[current_demand_id])
	else:
		resource_demander.hide()

func try_to_interact():
	if current_demand_id < demands.size():
		if resource_demander.is_demand_met():
			complete_demand()

func _on_interaction_area_entered(_area: Area2D):
	if current_demand_id < demands.size():
		resource_demander.show()

func _on_interaction_area_exited(_area: Area2D):
	resource_demander.hide()
