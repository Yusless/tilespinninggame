extends Area2D
class_name HurtboxComponent

signal hit

@export var health_component: HealthComponent

func get_hit(attack: AttackComponent):
	if health_component:
		health_component.take_damage(attack.damage)
	hit.emit()
