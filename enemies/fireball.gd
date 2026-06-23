extends Node2D
class_name Projectile

@export var speed := 480
@export var expire_time := 6.0
@export var expire_timer: Timer
@export var destroyed_on_attack := true
@export var attack_component: AttackComponent

var velocity := Vector2.ZERO

func _ready() -> void:
	attack_component.hit.connect(_on_attack_hit)

func launch(direction: Vector2):
	expire_timer.wait_time = expire_time
	expire_timer.start()
	velocity = speed * direction
	attack_component.begin_attack()

func _physics_process(delta: float) -> void:
	position += velocity * delta

func be_gone():
	queue_free()
	attack_component.end_attack()

func _on_expire_timer_timeout() -> void:
	be_gone()

func _on_attack_hit():
	if destroyed_on_attack:
		be_gone()
