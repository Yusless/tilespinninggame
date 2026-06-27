@tool
extends PromptDisplayer

func hide_condition() -> bool:
	return Input.is_action_just_pressed("zoom in") or Input.is_action_just_pressed("zoom out")
