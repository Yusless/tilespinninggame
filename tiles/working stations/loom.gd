extends WorkingStation
class_name Loom

signal unlock_demand_completed(demand: Demand)

func complete_demand():
	if working_sound:
		working_sound.play()

	resource_demander.hide()
	unlock_demand_completed.emit(demands[current_demand_id])

func try_to_interact():
	complete_demand()
