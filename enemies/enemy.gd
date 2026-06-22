extends CharacterBody2D
class_name Enemy

signal destination_reached
signal defeated(enemy: Enemy)

enum States {
	IDLE,
	CURIOUS,
	HOSTILE,
	ATTACKING,
	STUNNED,
	DEAD,
}

const JUMP_HEIGHT := 16.0

@export var speed := 160.0
@export var step_distance := 120.0
@export var rest_time := 0.6
@export var attack_distance := 96.0
@export var health_component: HealthComponent
@export var hurtbox_component: HurtboxComponent
@export var nav_agent: NavigationAgent2D
@export var aggro_area: Area2D
@export var rest_timer: Timer
@export var step_timer: Timer
@export var animation_player: AnimationPlayer
@export var stun_timer: Timer
@export var attack_component: AttackComponent
@export var attack_cooldown: Timer
@export var attack_delay: Timer
@export var sprite: AnimatedSprite2D

var state := States.IDLE
var has_movement_target := false
var combat_target: Node2D
var step_distance_covered := 0.0
var step_in_progress := false
var has_hyper_armor := false
var attacking := false

var points_of_interest := []

func _ready() -> void:
	rest_timer.wait_time = rest_time
	hurtbox_component.hit.connect(_on_hurtbox_hit)
	health_component.health_depleted.connect(_on_health_depleted)

func set_movement_target(pos: Vector2):
	nav_agent.target_position = pos
	has_movement_target = true

func remove_movement_target():
	has_movement_target = false

func start_step(direction: Vector2, step_speed: float):
	velocity = direction * step_speed
	step_in_progress = true
	step_timer.wait_time = step_distance / step_speed
	step_timer.start()

func end_step():
	step_timer.stop()
	velocity = Vector2.ZERO
	rest_timer.wait_time = rest_time + randf_range(-rest_time * 0.3, rest_time * 0.3)
	attack_component.end_attack()
	step_in_progress = false
	rest_timer.start()

func charge_attack():
	state = States.ATTACKING
	has_hyper_armor = true
	end_step()
	animation_player.play("attack")
	attack_delay.start()

func attack():
	attack_component.begin_attack()
	var direction_to_target := global_position.direction_to(combat_target.global_position)
	start_step(direction_to_target, speed * 2.0)
	#var tween := create_tween()
	#tween.tween_property(sprite, "rotation", direction_to_target.angle() + PI/2, 0.08)
	attacking = true

func navigate(_delta: float):
	if !has_movement_target:
		return
	
	var next_path_pos = nav_agent.get_next_path_position()
	var direction = global_position.direction_to(next_path_pos)
	
	if nav_agent.is_navigation_finished() and has_movement_target:
		has_movement_target = false
		#end_step()
		destination_reached.emit()
		return
	
	if rest_timer.is_stopped() and !step_in_progress:
		start_step(direction, speed)
	
	move_and_slide()

func die():
	animation_player.play("dead")
	state = States.DEAD
	step_timer.stop()
	rest_timer.stop()
	attack_component.end_attack()
	hurtbox_component.disable()
	defeated.emit(self)

func parabolic(x: float):
	return (-4 *(x**2)) + 4*x

func animate():
	var anim := "idle"
	sprite.position.y = 0.0
	if step_in_progress:
		if state == States.ATTACKING:
			anim = "attack"
		else:
			anim = "move"
		sprite.position.y = -parabolic(step_timer.time_left/step_timer.wait_time) * JUMP_HEIGHT
	if anim != sprite.animation:
		sprite.play(anim)
	
	if velocity.x:
		sprite.scale.x = sign(velocity.x)

func simple_state_machine(delta: float):
	match state:
		States.IDLE:
			if combat_target:
				state = States.HOSTILE
		States.CURIOUS:
			navigate(delta)
		States.HOSTILE:
			set_movement_target(combat_target.global_position)
			navigate(delta)
			if combat_target.global_position.distance_to(global_position) <= attack_distance and attack_cooldown.is_stopped() and !step_in_progress:
				charge_attack()
		States.STUNNED:
			if stun_timer.is_stopped():
				state = States.IDLE
		States.ATTACKING:
			move_and_slide()

func _physics_process(delta: float) -> void:
	simple_state_machine(delta)
	animate()

func add_point_of_interest(poi: Node2D):
	points_of_interest.push_back(poi)
	set_movement_target(poi.global_position)
	state = States.CURIOUS

func _on_aggro_area_body_entered(body: Node2D) -> void:
	if state in [States.IDLE, States.CURIOUS]:
		if body.is_in_group("Player"):
			points_of_interest.clear()
			combat_target = body
			state = States.HOSTILE
		else:
			add_point_of_interest(body)


func _on_aggro_area_area_entered(area: Area2D) -> void:
	if state in [States.IDLE, States.CURIOUS]:
		add_point_of_interest(area)


func _on_rest_timer_timeout() -> void:
	pass # Replace with function body.


func _on_step_timer_timeout() -> void:
	end_step()
	if state == States.ATTACKING:
		state = States.HOSTILE
		has_hyper_armor = false
		create_tween().tween_property(sprite, "rotation", 0.0, 0.08)
		attack_cooldown.start()

func _on_hurtbox_hit():
	if state not in [States.DEAD]:
		animation_player.play("damaged")
		if !has_hyper_armor:
			state = States.STUNNED
			stun_timer.start()

func _on_health_depleted():
	die()


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	pass


func _on_attack_delay_timeout() -> void:
	attack()
