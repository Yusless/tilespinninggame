@tool
extends HBoxContainer
class_name ResourceNumber

@export var icon: TextureRect
@export var counter: Label
@export var resource: NaturalResource

var resource_manager: ResourceManager

func _ready():
	icon.texture = resource.icon
	update(1)

func update(amount: int):
	icon.texture = resource.icon
	if amount == 0:
		hide()
		return
	show()
	counter.text = str(amount)
