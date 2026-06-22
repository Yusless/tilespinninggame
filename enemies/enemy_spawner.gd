@tool
extends Node2D
class_name EnemySpawner

@export var enemy_scene: PackedScene

@export var boundry_left := -Vector2.ONE * 10
@export var boundry_right := Vector2.ONE * 10
@export var spawn_interval := 5.0
@export var enemy_limit := 6

@export var boundry_left_marker: Marker2D
@export var boundry_right_marker: Marker2D
@export var spawn_timer: Timer


var active := false
var enemies: Array[Enemy] = []

func _ready() -> void:
	if !Engine.is_editor_hint() and active:
		spawn_timer.wait_time = spawn_interval
		spawn_timer.start()

func spawn_enemy():
	if enemies.size() >= enemy_limit:
		return
	
	var enemy: Enemy = enemy_scene.instantiate()
	enemies.push_back(enemy)
	enemy.defeated.connect(_on_enemy_defeated)
	get_parent().add_child(enemy)
	enemy.global_position = Vector2(
		randf_range(boundry_left_marker.global_position.x, boundry_right_marker.global_position.x),
		randf_range(boundry_left_marker.global_position.y, boundry_right_marker.global_position.y)
	)

func remove_enemy(enemy: Enemy):
	enemy.queue_free()
	enemies.erase(enemy)
	if enemies.size() < enemy_limit and spawn_timer.is_stopped() and active:
		spawn_timer.start()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		boundry_left_marker.position = boundry_left
		boundry_right_marker.position = boundry_right


func _on_spawn_timer_timeout() -> void:
	if !active:
		return
	spawn_enemy()
	if enemies.size() < enemy_limit:
		spawn_timer.wait_time = spawn_interval
		spawn_timer.start()

func _on_enemy_defeated(enemy: Enemy):
	await get_tree().create_timer(1.0).timeout
	if is_inside_tree():
		remove_enemy(enemy)

func deactivate():
	active = false
	spawn_timer.stop()

func activate():
	active = true
	spawn_timer.start()

func reset():
	while enemies:
		remove_enemy(enemies[0])
