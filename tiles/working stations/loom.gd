extends WorkingStation
class_name Loom

signal unlock_demand_completed(demand: Demand)

func complete_demand():
	unlock_demand_completed.emit(demands[current_demand_id])
	super()
