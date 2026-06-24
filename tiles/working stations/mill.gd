extends WorkingStation
class_name Mill

signal unlock_1_demand_completed(demand: Demand)

func complete_demand():
	unlock_1_demand_completed.emit(demands[current_demand_id])
	super()
