@tool
extends HBoxContainer
class_name ResourceCounter

@export var counter: Label
@export var resource: NaturalResource
@export var icon: TextureRect

var resource_manager: ResourceManager

func _ready():
	if !Engine.is_editor_hint():
		resource_manager = Global.get_manager(ResourceManager)
		resource_manager.resource_added.connect(_on_resource_manager_resource_added)
		resource_manager.resource_detracted.connect(_on_resource_manager_resource_detracted)
	icon.texture = resource.icon

func update_counter():
	counter.text = str(resource_manager.resource_amounts[resource])

func _on_resource_manager_resource_added(res: NaturalResource):
	if res == resource:
		update_counter()

func _on_resource_manager_resource_detracted(res: NaturalResource):
	if res == resource:
		update_counter()
