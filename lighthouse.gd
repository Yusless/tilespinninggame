extends Node2D
class_name Lighthouse


signal expedition_finished
signal expedition_started

func _ready() -> void:
	start_expedition()

func try_to_interact():
	var player = Global.get_player()
	if player.state == player.States.INSIDE:
		player.get_outside()
		start_expedition()
	else:
		player.get_inside()
		finish_expedition()

func finish_expedition():
	expedition_finished.emit()

func start_expedition():
	expedition_started.emit()
