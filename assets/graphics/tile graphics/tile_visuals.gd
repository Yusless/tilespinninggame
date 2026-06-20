extends Node2D

const CELL_SIZE := 16
const TILE_SIZE := 16

func get_rotated_array_by_degrees(array: Array[Array], degrees: float):
	var rotations := floori(degrees / 90.0)
	
