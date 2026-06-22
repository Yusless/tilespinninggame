extends Area2D
class_name HurtboxComponent

signal hit

@export var health_component: HealthComponent

var attack_ids_taken := []

func disable():
	var child := get_child(0)
	if child:
		if child is CollisionShape2D:
			child.disabled = true

func enable():
	var child := get_child(0)
	if child:
		if child is CollisionShape2D:
			child.disabled = false

func get_hit(attack: AttackComponent):
	if attack.attack_id in attack_ids_taken:
		return
	if health_component:
		health_component.take_damage(attack.damage)
	hit.emit()
	attack_ids_taken.push_back(attack.attack_id)
