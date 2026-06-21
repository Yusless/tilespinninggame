class_name Side

enum Sides {
	UP,
	RIGHT,
	DOWN,
	LEFT
}

const OPPOSITE_DICT = {Sides.UP: Sides.DOWN,
				Sides.RIGHT: Sides.LEFT,
				Sides.DOWN: Sides.UP,
				Sides.LEFT: Sides.RIGHT
}

const NEXT_DICT = {Sides.UP: Sides.RIGHT,
				Sides.RIGHT: Sides.DOWN,
				Sides.DOWN: Sides.LEFT,
				Sides.LEFT: Sides.UP
}


static func get_opposite(side: Sides) -> Sides:
	return OPPOSITE_DICT[side]
	
static func get_next(side: Sides) -> Sides:
	return NEXT_DICT[side]
