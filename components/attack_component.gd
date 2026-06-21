extends Area2D
class_name AttackComponent

@export var damage := 1
var attack_id := 0
var active := false

#func _ready() -> void:
	#area_entered.connect(_on_area_entered)
	#body_entered.connect(_on_body_entered)

func begin_attack():
	attack_id = CombatManager.get_attack_id()
	active = true
	set_deferred("monitorng", true)
	set_deferred("monitorable", true)

func end_attack():
	active = false
	set_deferred("monitorng", false)
	set_deferred("monitorable", false)

func _process(_delta: float) -> void:
	if active:
		for area in get_overlapping_areas():
			if area.has_method("get_hit") and active:
				area.get_hit(self)
		for body in get_overlapping_bodies():
			if body.has_method("get_hit") and active:
				body.get_hit(self)

#func _on_area_entered(area: Area2D) -> void:
	#if area.has_method("get_hit") and active:
		#area.get_hit(self)
#
#
#func _on_body_entered(body: Node2D) -> void:
	#if body.has_method("get_hit") and active:
		#body.get_hit(self)
