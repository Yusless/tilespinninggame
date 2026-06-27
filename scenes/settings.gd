extends Control

@export var menu_area: MarginContainer


func _on_button_pressed() -> void:
	hide()
	menu_area.show()
