extends Enemy
class_name Toad

@export var croak_hit: AudioStreamPlayer2D
@export var croak_jump: AudioStreamPlayer2D
@export var croak_land: AudioStreamPlayer2D


func attack():
	super()
	attack_component.begin_attack()
	var direction_to_target := global_position.direction_to(combat_target.global_position)
	start_step(direction_to_target, speed * 2.0)
	attacking = true

func start_step(direction: Vector2, step_speed: float):
	super(direction, step_speed)
	croak_jump.play()

func end_step():
	super()
	croak_land.play()

func animate():
	super()
	if step_in_progress:
		sprite.position.y = -parabolic(step_timer.time_left/step_timer.wait_time) * JUMP_HEIGHT

func _on_step_timer_timeout() -> void:
	if state == States.ATTACKING:
		state = States.HOSTILE
		has_hyper_armor = false
		create_tween().tween_property(sprite, "rotation", 0.0, 0.08)
		attack_cooldown.start()
