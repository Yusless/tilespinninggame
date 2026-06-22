extends Area2D
class_name AttackComponent

@export var damage := 1
var attack_id := 0
var active := false
var hit_queue := []

func _ready() -> void:
	if !area_entered.is_connected(_on_area_entered):
		area_entered.connect(_on_area_entered)
		body_entered.connect(_on_body_entered)
		area_exited.connect(_on_area_exited)
		body_exited.connect(_on_body_exited)

func begin_attack():
	attack_id = CombatManager.get_attack_id()
	active = true

func end_attack():
	active = false

func _process(_delta: float) -> void:
	if active and hit_queue:
		for node in hit_queue:
			node.get_hit(self)
			hit_queue.erase(node)

func _on_area_entered(area: Area2D) -> void:
	if area.has_method("get_hit"):
		hit_queue.push_back(area)


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("get_hit"):
		hit_queue.push_back(body)

func _on_area_exited(area: Area2D) -> void:
	if area.has_method("get_hit"):
		hit_queue.erase(area)


func _on_body_exited(body: Node2D) -> void:
	if body.has_method("get_hit"):
		hit_queue.erase(body)
