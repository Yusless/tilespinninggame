extends Area2D
class_name InteractionComponent

signal interacted

var can_interact := false

@export var prompt_enabled := false
@export var prompt_scene: PackedScene
@export var prompt_text := ""
@export var prompt_icon: Texture
@export var prompt_origin: Marker2D

var prompt: Prompt

func _ready() -> void:
	if prompt_enabled:
		prompt = prompt_scene.instantiate()
		prompt.text = prompt_text
		prompt.icon = prompt_icon
		prompt.hide()
		prompt_origin.add_child(prompt)

func _on_area_entered(_area: Area2D) -> void:
	can_interact = true
	if prompt_enabled and prompt:
		prompt.show()


func _on_area_exited(_area: Area2D) -> void:
	can_interact = false
	if prompt_enabled and prompt:
		prompt.hide()


func _input(event: InputEvent) -> void:
	if can_interact and event.is_action_pressed("interact"):
		if get_parent().has_method("try_to_interact"):
			get_parent().try_to_interact()
		interacted.emit()
