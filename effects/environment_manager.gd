extends CanvasModulate
class_name EnvironmentManager

@export var default_color := Color.WHITE
@export var night_color := Color("#6567a3")
@export var transition_time := 3.0

func _ready() -> void:
	pass

func switch_to_day():
	var tween := create_tween()
	tween.tween_property(self, "color", default_color, transition_time)

func switch_to_night():
	var tween := create_tween()
	tween.tween_property(self, "color", night_color, transition_time)
