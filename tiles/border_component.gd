extends Node2D


var borders = { "up": Global.border_types.nothing,
				"right": Global.border_types.nothing,
				"down": Global.border_types.nothing,
				"left": Global.border_types.nothing
							}

@export var left_border = Global.border_types.nothing
@export var up_border = Global.border_types.nothing
@export var right_border = Global.border_types.nothing
@export var down_border = Global.border_types.nothing

func _ready() -> void:
	create_dict_from_export()


func create_dict_from_export() -> void:
	borders = {"up": up_border,
				"right": right_border,
				"down": down_border,
				"left": left_border
				}


func rotate_borders() -> void:
	var temp = borders.get("up")
	borders.set("up", borders.get("left"))
	borders.set("left", borders.get("down"))
	borders.set("down", borders.get("right"))
	borders.set("right", temp)
