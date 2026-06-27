@tool
extends PromptDisplayer

func hide_condition() -> bool:
	return Input.is_action_pressed("attack") or Input.is_action_pressed("restart")
