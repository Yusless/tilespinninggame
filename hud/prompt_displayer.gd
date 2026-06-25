@tool
extends Area2D
class_name PromptDisplayer

@export var prompt: Prompt
@export var prompt_text := ""
@export var prompt_icon: Texture2D
var fly_up_distance := 8.0
var drop_distance := 8.0

var displayed := false
var finished := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(_delta: float) -> void:
	if !Engine.is_editor_hint():
		if hide_condition() and displayed and !finished:
			finish()
	prompt.text = prompt_text
	if prompt.icon != prompt_icon:
		prompt.icon = prompt_icon

func display():
	var keyframe1 := global_position + Vector2(
		0.0,
		-fly_up_distance + randf_range(-2.0, 2.0),
	)
	var keyframe2 := global_position + Vector2(
		0.0,
		drop_distance + randf_range(-2.0, 2.0),
	)
	
	prompt.show()
	displayed = true
	var tween := create_tween()
	tween.tween_property(prompt, "global_position", keyframe1, 0.15).set_ease(Tween.EASE_OUT)
	tween.tween_property(prompt, "global_position", keyframe2, 0.25).set_ease(Tween.EASE_IN)


func finish():
	finished = true
	prompt.hide()
	create_tween().tween_property(prompt, "modulate", Color.TRANSPARENT, 0.4)

func display_condition() -> bool:
	return true

func hide_condition() -> bool:
	return false


func _on_body_entered(body: Node2D) -> void:
	if display_condition() and body is Player and !displayed:
		display()
