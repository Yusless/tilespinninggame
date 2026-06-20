extends Area2D
class_name AttackComponent

@export var damage := 1

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)


func _on_area_entered(area: Area2D) -> void:
	if area.has_method("get_hit"):
		area.get_hit(self)


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("get_hit"):
		body.get_hit(self)
