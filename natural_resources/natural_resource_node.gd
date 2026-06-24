extends Node2D
class_name NaturalResourceNode

@onready var collectable_scene := preload("res://natural_resources/resource_collectable.tscn")

@export var resource: NaturalResource
@export var health_component: HealthComponent
@export var hurtbox_component: HurtboxComponent
@export var amount_min := 1
@export var amount_max := 2
@export var collectable_amount := 3
@export var collectable_origin: Marker2D
@export var sprite: AnimatedSprite2D

var harvested := false
var collectables: Array[Node] = []

func _ready() -> void:
	health_component.health_depleted.connect(_on_health_depleted)
	hurtbox_component.hit.connect(_on_hit)
	sprite.play("default")

func spawn_collectable():
	var collectable: ResourceCollectable = collectable_scene.instantiate()
	collectable.amount = randi_range(amount_min, amount_max)
	collectable.resource = resource
	call_deferred("add_child", collectable)
	collectable.top_level = true
	collectable.global_position = collectable_origin.global_position
	collectable.drop_distance = global_position.y - collectable_origin.global_position.y + 8
	collectables.push_back(collectable)

func harvest():
	if harvested:
		return
	harvested = true
	for i in range(collectable_amount):
		spawn_collectable()
	sprite.play("harvested")

func burn():
	harvested = true
	sprite.play("burnt")

func reset():
	harvested = false
	sprite.play("default")
	health_component.reset()
	for node in collectables:
		if node:
			node.queue_free()
	collectables.clear()

func _on_health_depleted():
	harvest()

func _on_hit():
	pass
