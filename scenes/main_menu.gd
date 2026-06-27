extends Control

@export var menu_area: MarginContainer
@export var settings_area: MarginContainer



func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_scene.tscn")


func _on_settings_pressed() -> void:
	menu_area.hide()
	settings_area.show()
