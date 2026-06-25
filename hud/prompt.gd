@tool
extends Control
class_name Prompt

@export var text := ""
@export var icon : Texture2D

@export var label: Label
@export var texture_rect: TextureRect

func _ready() -> void:
	label.text = text
	texture_rect.texture = icon

func _process(_delta: float) -> void:
	label.text = text
	if texture_rect.texture != icon:
		texture_rect.texture = icon
