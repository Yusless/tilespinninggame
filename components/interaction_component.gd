extends Area2D
class_name InteractionComponent

signal interacted

var can_interact := false

@export var collision: CollisionShape2D

func _on_area_entered(_area: Area2D) -> void:
	can_interact = true


func _on_area_exited(_area: Area2D) -> void:
	can_interact = false


func _input(event: InputEvent) -> void:
	if can_interact and event.is_action_pressed("interact"):
		if get_parent().has_method("try_to_interact"):
			get_parent().try_to_interact()
		interacted.emit()
