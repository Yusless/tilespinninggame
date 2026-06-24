extends Node2D
class_name ResourceCollectable

@export var resource: NaturalResource
@export var amount := 1
@export var fly_up_distance := 8.0
@export var drop_distance := 8.0
@export var horizontal_spread_max := 6.0
@export var sprite: Sprite2D
@export var animation_player: AnimationPlayer
@export var collision_shape: CollisionShape2D


func _ready() -> void:
	drop()
	sprite.texture = resource.icon

func drop():
	var direction := 1 if randi()%2 else -1
	var keyframe1 := global_position + Vector2(
		randf_range(0, horizontal_spread_max) * direction,
		-fly_up_distance + randf_range(-2.0, 2.0),
	)
	var keyframe2 := global_position + Vector2(
		randf_range(0, horizontal_spread_max) * direction,
		drop_distance + randf_range(-2.0, 2.0),
	)
	
	var tween := create_tween()
	tween.tween_property(self, "global_position", keyframe1, 0.15).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", keyframe2, 0.25).set_ease(Tween.EASE_IN)
	tween.tween_property(collision_shape, "disabled", false, 0.0)

func collect():
	var res_mgr: ResourceManager = Global.get_manager(ResourceManager)
	res_mgr.add_resource(resource, amount)
	animation_player.play("collect")
	await animation_player.animation_finished
	if is_inside_tree():
		queue_free()

func reset():
	queue_free()

func _on_player_detector_area_entered(_area: Area2D) -> void:
	collect()
