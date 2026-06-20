extends Node2D
class_name NaturalResourceNode

@onready var collectable_scene := preload("res://natural_resources/resource_collectable.tscn")

@export var resource: NaturalResource
@export var health_component: HealthComponent
@export var amount_min := 1
@export var amount_max := 2
@export var collectable_amount := 3
@export var collectable_origin: Marker2D
@export var sprite: AnimatedSprite2D

var harvested := false

func _ready() -> void:
	health_component.health_depleted.connect(_on_health_depleted)
	sprite.play("default")

func spawn_collectable():
	var collectable: ResourceCollectable = collectable_scene.instantiate()
	collectable.amount = randi_range(amount_min, amount_max)
	collectable.resource = resource
	call_deferred("add_child", collectable)
	collectable.top_level = true
	collectable.global_position = global_position
	print(1)
	pass

func harvest():
	if harvested:
		return
	harvested = true
	for i in range(collectable_amount):
		spawn_collectable()
	sprite.play("harvested")

func _on_health_depleted():
	harvest()
