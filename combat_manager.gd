extends Node

var attack_id := 0

func get_attack_id() -> int:
	attack_id += 1
	return attack_id - 1
