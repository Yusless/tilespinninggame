extends CharacterBody2D
class_name Player

signal lighthouse_entered
signal lighthouse_exited
signal died

enum States {
	IDLE,
	MOVING,
	STUNNED,
	DEAD,
	INSIDE
}

const ACCELERATION_TIME: float = 0.085
const DECCELERATION_TIME: float = 0.05
const STEP_FRAMES := [1, 4]

@export var max_speed := 250.0
@export var max_camera_speed := 750.0
@export var dash_speed := 700.0
@export var max_dashes := 100

@export_subgroup("Deps")
@export var check_for_dead_area: Timer
@export var dash_timer: Timer
@export var dash_cooldown: Timer
@export var drowned_timer: Timer
@export var boomerang: Boomerang
@export var sprite: AnimatedSprite2D
@export var stun_timer: Timer
@export var hurtbox: HurtboxComponent
@export var animation_player: AnimationPlayer
@export var health_component: HealthComponent
@export var camera: Camera2D
@export var cells_system: Node2D
@export var spawn_point: Marker2D
@export var resource_manager: ResourceManager
@export var step_sound_1: AudioStreamPlayer2D
@export var step_sound_2: AudioStreamPlayer2D
@export var visual_boomerang: Sprite2D

var has_dash = true
var can_dash = true
var dash_direction = Vector2()
var life_areas = []
var dash_count = 0

var temp_pos
var last_inside_pos := Vector2.ZERO

var last_direction := Vector2.ONE
var state := States.IDLE
var camera_velocity := Vector2.ZERO
var in_lighthouse := false

func _ready() -> void:
	boomerang.return_target = self
	hurtbox.hit.connect(_on_hurtbox_hit)
	health_component.health_depleted.connect(_on_health_depleted)
	spawn()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and state not in [States.DEAD, States.INSIDE]:
		if !boomerang.is_launched:
			var dir_to_mouse := global_position.direction_to(get_global_mouse_position())
			boomerang.launch(global_position, dir_to_mouse.angle(), velocity)
		elif boomerang.distance_flied > boomerang.minimum_fly_distance:
			boomerang.force_return()
	if event.is_action_pressed("dash") and state != States.INSIDE and can_dash:
		dash()
	if event.is_action_pressed("restart") and state not in [States.DEAD, States.INSIDE] and !in_lighthouse:
		die()

func spawn():
	health_component.reset()
	position = spawn_point.global_position
	state = States.IDLE

func die():
	state = States.DEAD
	died.emit()
	resource_manager.clear()

func animate_boomerang():
	visual_boomerang.rotation = PI/3 - max(
		PI/12 * velocity.length() / max_speed,
		-PI/12
	)

func move(delta):
	var movement = get_movement_vector()
	var direction = movement.normalized()
	var acceleration = max_speed / (ACCELERATION_TIME if direction else DECCELERATION_TIME)
	velocity = Vector2(
		move_toward(velocity.x, max_speed * direction.x, delta * acceleration),
		move_toward(velocity.y, max_speed * direction.y, delta * acceleration)
	)
	last_direction = Vector2(
		sign(direction.x) if direction.x else last_direction.x,
		sign(direction.y) if direction.y else last_direction.y,
	)
	animate()
	move_and_slide()

func simple_state_machine(delta):
	match state:
		States.IDLE:
			if get_movement_vector():
				state = States.MOVING
		States.MOVING:
			move(delta)
		States.STUNNED:
			if stun_timer.is_stopped():
				state = States.IDLE
		States.INSIDE:
			move_camera(delta)
		States.DEAD:
			pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	simple_state_machine(delta)
	animate()

func move_camera(delta):
	var movement = get_movement_vector()
	var direction = movement.normalized()
	var acceleration = max_camera_speed / (ACCELERATION_TIME if direction else DECCELERATION_TIME)
	camera_velocity = Vector2(
		move_toward(camera_velocity.x, max_camera_speed * direction.x, delta * acceleration),
		move_toward(camera_velocity.y, max_camera_speed * direction.y, delta * acceleration)
	)
	last_direction = Vector2(
		sign(direction.x) if direction.x else last_direction.x,
		sign(direction.y) if direction.y else last_direction.y,
	)
	animate()
	camera.position += camera_velocity*delta

func animate():
	var anim := "idle"
	if get_movement_vector() and velocity and not state ==  States.STUNNED:
		anim = "run"
	
	if last_direction.x >= 0:
		sprite.scale.x = 1
	else:
		sprite.scale.x = -1
	
	animate_boomerang()
	sprite.play(anim)


func get_movement_vector():
	var movement_x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var movement_y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(movement_x, movement_y)


func _on_hurtbox_hit():
	animation_player.play("damaged")
	state = States.STUNNED
	stun_timer.start()

func _on_health_depleted():
	die()

func enter_spin_mode():
	create_tween().tween_property(camera, "zoom", Vector2(0.3,0.3), 0.15).set_ease(Tween.EASE_OUT)
	state = States.INSIDE

func exit_spin_mode():
	create_tween().tween_property(camera, "position", Vector2.ZERO, 0.3).set_ease(Tween.EASE_OUT)
	create_tween().tween_property(camera, "zoom", Vector2(1,1), 0.3).set_ease(Tween.EASE_OUT)
	state = States.IDLE

func get_inside(spawn_pos: Vector2):
	lighthouse_entered.emit()
	global_position = spawn_pos
	z_index = 2
	last_inside_pos = spawn_pos
	in_lighthouse = true
	
func get_outside():
	spawn()
	lighthouse_exited.emit()
	z_index = 1
	in_lighthouse = false


func _on_sprite_frame_changed() -> void:
	if sprite.animation in ["run"] and sprite.frame in STEP_FRAMES and state != States.INSIDE:
		if !step_sound_1.playing:
			step_sound_1.play()
		else:
			step_sound_2.play()


func _on_boomerang_launched() -> void:
	visual_boomerang.hide()


func _on_boomerang_returned() -> void:
	visual_boomerang.show()


func dash():
	if has_dash:
		temp_pos = position
		can_dash = false
		dash_count +=1
		set_collision_mask_value(7, false)
		var dir_to_mouse := global_position.direction_to(get_global_mouse_position())
		dash_direction = dir_to_mouse
		velocity = dash_direction * dash_speed
		check_for_dead_area.start()
		dash_timer.start()
		dash_cooldown.start()

func _on_dash_timer_timeout() -> void:
	set_collision_mask_value(7, true)

func _on_dash_cooldown_timeout() -> void:
	if dash_count < max_dashes:
		can_dash = true

func _on_drowned_timer_timeout() -> void:
	print("returned")
	state = States.IDLE
	position = temp_pos


func _on_check_for_dead_area_timeout() -> void:
	if !life_areas:
		state = States.STUNNED
		stun_timer.start(1)
		drowned_timer.start()


func _on_standbox_area_entered(area: Area2D) -> void:
	life_areas.append(area)


func _on_standbox_area_exited(area: Area2D) -> void:
	life_areas.erase(area)
