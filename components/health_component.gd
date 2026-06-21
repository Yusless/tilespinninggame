extends Node
class_name HealthComponent

signal damaged(amount: int)
signal health_depleted
signal healed(amount: int)

@export var max_health := 10
@export var can_overheal := false

var health: int
var dead := false

func _ready() -> void:
	health = max_health

func take_damage(damage: int):
	health = max(0, health - damage)
	damaged.emit(damage)
	if health <= 0 and !dead:
		health_depleted.emit()
		dead = true

func heal(healing: int):
	if !can_overheal:
		health = min(health + healing, max_health)
	else:
		health += healing
	healed.emit(healing)
