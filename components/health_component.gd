extends Node
class_name HealthComponent

signal damaged
signal health_depleted
signal healed

@export var max_health := 10
@export var can_overheal := false

var health

func _ready() -> void:
	health = max_health

func take_damage(damage: int):
	health = max(0, health - damage)
	damaged.emit()
	if health <= 0:
		health_depleted.emit()

func heal(healing: int):
	if !can_overheal:
		health = min(health + healing, max_health)
	else:
		health += healing
	healed.emit()
