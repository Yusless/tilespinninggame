extends Node2D

enum border_types {
	nothing,
	wall,
	bridge
}

@export var left_border = border_types.nothing
@export var up_border = border_types.nothing
@export var right_border = border_types.nothing
@export var down_border = border_types.nothing

func create_dict_from_export() -> Dictionary:
	var borders = {"up": up_border,
						"right": right_border,
						"down": down_border,
						"left": left_border
						}
	return borders
