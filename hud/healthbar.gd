@tool
extends HBoxContainer
class_name Healthbar

@export var max_health := 5
@export var heart_container_scene: PackedScene

var containers: Array[HeartContainer] = []
var current_container := 4

func _ready() -> void:
	current_container = max_health-1
	for child in get_children():
		child.queue_free()
	for i in range(max_health):
		var container: HeartContainer = heart_container_scene.instantiate()
		add_child(container)
		containers.push_back(container)
	
	var player := Global.get_player()
	player.health_component.damaged.connect(_on_player_damaged)
	player.health_component.healed.connect(_on_player_healed)

func fill_containers(amount: int):
	for i in range(amount):
		if current_container >= containers.size():
			return
		current_container += 1
		containers[current_container].fill()

func empty_containers(amount: int):
	for i in range(amount):
		if current_container < 0:
			return
		containers[current_container].empty()
		current_container -= 1

func add_container():
	fill_containers(max_health - current_container - 1)
	for i in range(max_health):
		var container: HeartContainer = heart_container_scene.instantiate()
		add_child(container)
		containers.push_back(container)
		max_health += 1

func _on_player_damaged(amount: int):
	empty_containers(amount)

func _on_player_healed(amount: int):
	fill_containers(amount)
