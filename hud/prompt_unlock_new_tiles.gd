@tool
extends PromptDisplayer

@export var wheat: NaturalResource
@export var hub_tile: HubTile
@export var resource_manager: ResourceManager

var res_mgr : ResourceManager
var display_wheat := 0

func _ready() -> void:
	super()
	if !Engine.is_editor_hint():
		res_mgr = Global.get_manager(ResourceManager)

func display_condition() -> bool:
	return res_mgr.resource_amounts[wheat] >= 50

func display():
	super()
	display_wheat = res_mgr.resource_amounts[wheat]

func hide_condition() -> bool:
	return res_mgr.resource_amounts[wheat] < display_wheat
