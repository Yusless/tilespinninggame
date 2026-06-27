@tool
extends PromptDisplayer

var player: Player

func _ready() -> void:
	player = Global.get_player()

func hide_condition() -> bool:
	return Input.is_action_pressed("dash")

func display_condition() -> bool:
	if player:
		return player.has_dash
	return false
