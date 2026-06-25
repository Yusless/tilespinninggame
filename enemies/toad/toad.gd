extends Enemy
class_name Toad

@onready var collectable_scene := preload("res://natural_resources/resource_collectable.tscn")

@export var sprite_default: AnimatedSprite2D
@export var sprite_lava: AnimatedSprite2D
@export var croak_jump: AudioStreamPlayer2D
@export var croak_land: AudioStreamPlayer2D
@export var lava_core_res: NaturalResource
@export var croak_attack: AudioStreamPlayer2D
@export var eat_sound: AudioStreamPlayer2D

var collectables: Array[Node] = []

var dragonfly_spotted := false
var dragonfly_consumed := false

func attack():
	super()
	attack_component.begin_attack()
	var direction_to_target := global_position.direction_to(combat_target.global_position)
	start_step(direction_to_target, speed * 2.0)
	attacking = true

func charge_attack():
	super()
	croak_attack.play()

func spawn_lava_core():
	var collectable: ResourceCollectable = collectable_scene.instantiate()
	collectable.amount = 1
	collectable.resource = lava_core_res
	get_parent().get_parent().call_deferred("add_child", collectable)
	collectable.top_level = true
	collectable.global_position = global_position
	collectables.push_back(collectable)

func consume_dragonfly(dragonfly: Dragonfly):
	dragonfly.be_gone()
	dragonfly_consumed = true
	dragonfly_spotted = false
	sprite_default.scale.x = 1.0
	sprite_default.position = Vector2.ZERO
	sprite_default.self_modulate = Color.TRANSPARENT
	sprite_lava.show()
	points_of_interest.clear()
	sprite = sprite_lava
	eat_sound.play()

func start_step(direction: Vector2, step_speed: float):
	super(direction, step_speed)
	croak_jump.play()

func be_gone():
	super()
	if dragonfly_consumed:
		spawn_lava_core()

func end_step():
	super()
	croak_land.play()

func animate():
	super()
	if step_in_progress:
		sprite.position.y = -parabolic(step_timer.time_left/step_timer.wait_time) * JUMP_HEIGHT

func _on_step_timer_timeout() -> void:
	if state == States.ATTACKING:
		end_attack()
	end_step()

func _on_aggro_area_body_entered(body: Node2D) -> void:
	super(body)
	if body is Dragonfly and !dragonfly_consumed:
		dragonfly_spotted = true
		combat_target = body
		state = States.HOSTILE


func _on_dragonfly_consumer_body_entered(body: Node2D) -> void:
	if body is Dragonfly and attacking and !dragonfly_consumed:
		consume_dragonfly(body)
