extends Enemy
class_name Toad

func attack():
	super()
	attack_component.begin_attack()
	var direction_to_target := global_position.direction_to(combat_target.global_position)
	start_step(direction_to_target, speed * 2.0)
	attacking = true

func animate():
	super()
	if step_in_progress:
		sprite.position.y = -parabolic(step_timer.time_left/step_timer.wait_time) * JUMP_HEIGHT
