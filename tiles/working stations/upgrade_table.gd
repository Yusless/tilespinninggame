extends WorkingStation
class_name UpgradeTable

signal demand_completed(demand: Demand)

func complete_demand():
	demand_completed.emit(demands[current_demand_id])
	res_mgr.clear()
	super()
