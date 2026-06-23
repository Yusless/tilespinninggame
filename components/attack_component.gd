extends Area2D
class_name AttackComponent

signal hit

@export var damage := 1
var attack_id := 0
var hurtbox_active := false
var hit_queue := []
var shape: CollisionShape2D

func _ready() -> void:
	if !area_entered.is_connected(_on_area_entered):
		area_entered.connect(_on_area_entered)
		body_entered.connect(_on_body_entered)
		if get_child(0):
			if get_child(0) is CollisionShape2D:
				shape = get_child(0)

func begin_attack():
	attack_id = CombatManager.get_attack_id()
	hurtbox_active = true
	if shape:
		shape.set_deferred("disabled", false)

func end_attack():
	hurtbox_active = false
	if shape:
		shape.set_deferred("disabled", true)

func _on_area_entered(area: Area2D) -> void:
	if area.has_method("get_hit") and hurtbox_active:
		area.get_hit(self)

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("get_hit") and hurtbox_active:
		body.get_hit(self)
