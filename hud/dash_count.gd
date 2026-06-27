extends HBoxContainer

@export var counter: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func update_counter():
	counter.text = str(Global.get_player().max_dashes)
	
