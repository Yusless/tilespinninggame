extends Tile
class_name HubTile

@export var lighthouse: Lighthouse
@export var upgrade_table: UpgradeTable
@export var transparency_area: Area2D

func _on_lighthouse_entered():
	if border_objects[Side.Sides.UP]:
		var bridge := border_objects[Side.Sides.UP]
		if bridge is Bridge:
			bridge.process_mode = Node.PROCESS_MODE_DISABLED

func _on_lighthouse_exited():
	if border_objects[Side.Sides.UP]:
		var bridge := border_objects[Side.Sides.UP]
		if bridge is Bridge:
			bridge.process_mode = Node.PROCESS_MODE_INHERIT

func _ready() -> void:
	super()
	lighthouse.entered.connect(_on_lighthouse_entered)
	lighthouse.exited.connect(_on_lighthouse_exited)
