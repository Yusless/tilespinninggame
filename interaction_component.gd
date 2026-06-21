extends Area2D


var can_interact := false

@export var collision: CollisionShape2D



func _on_area_entered(area: Area2D) -> void:
	can_interact = true


func _on_area_exited(area: Area2D) -> void:
	can_interact = false


func _input(event: InputEvent) -> void:
	if can_interact and event.is_action_pressed("interact"):
		get_parent().try_to_interact()
