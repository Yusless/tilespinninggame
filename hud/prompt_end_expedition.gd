@tool
extends PromptDisplayer

@export var wheat: NaturalResource
@export var hub_tile: HubTile

var res_mgr : ResourceManager
var lighthouse_entered := false

func _ready() -> void:
	super()
	if !Engine.is_editor_hint():
		res_mgr = Global.get_manager(ResourceManager)

func hide_condition() -> bool:
	return hub_tile.lighthouse.interior.visible

func display_condition() -> bool:
	return res_mgr.resource_amounts[wheat] >= 50
