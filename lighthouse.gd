extends Node2D

func try_to_interact():
	var player = Global.get_player()
	if player.state == player.States.INSIDE:
		player.get_outside()
	else:
		player.get_inside()
