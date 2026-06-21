extends Area2D
class_name InteractionComponent

signal interacted


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		interacted.emit()
