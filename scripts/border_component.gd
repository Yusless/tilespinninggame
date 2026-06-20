extends Node2D

enum border_types {
	nothing,
	wall,
	bridge
}
var borders = { "up": border_types.nothing,
				"right": border_types.nothing,
				"down": border_types.nothing,
				"left": border_types.nothing
							}
func _ready() -> void:
	create_dict_from_export()

@export var left_border = border_types.nothing
@export var up_border = border_types.nothing
@export var right_border = border_types.nothing
@export var down_border = border_types.nothing

func create_dict_from_export() -> void:
	borders = {"up": up_border,
						"right": right_border,
						"down": down_border,
						"left": left_border
						}


func rotate_borders():
	var temp = borders.get("up")
	borders.set("up", borders.get("left"))
	borders.set("left", borders.get("down"))
	borders.set("down", borders.get("right"))
	borders.set("right", temp)
