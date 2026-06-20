extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_data_to_tiles()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func add_data_to_tiles():
	get_cell_atlas_coords(Vector2i(1,-2))
