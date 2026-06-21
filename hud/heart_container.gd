@tool
extends TextureRect
class_name HeartContainer

@export var texture_full: Texture2D
@export var texture_empty: Texture2D

func _ready() -> void:
	fill()

func fill():
	texture = texture_full

func empty():
	texture = texture_empty
