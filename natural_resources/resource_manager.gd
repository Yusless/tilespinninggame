extends Node
class_name ResourceManager

signal resource_added(resource: NaturalResource)
signal resource_detracted(resource: NaturalResource)

@export var available_resources: Array[NaturalResource]

var resource_amounts: Dictionary[NaturalResource, int]

func _ready() -> void:
	for res in available_resources:
		resource_amounts[res] = 0

func add_resource(res: NaturalResource, amount: int):
	resource_amounts[res] += amount
	resource_added.emit(res)

func detract_resource(res: NaturalResource, amount: int):
	resource_amounts[res] = max(0, resource_amounts[res] - amount)
	resource_detracted.emit(res)
