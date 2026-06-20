extends CharacterBody2D

const ACCELERATION_TIME: float = 0.085
const DECCELERATION_TIME: float = 0.05

@export var max_speed := 250.0
@export_subgroup("Deps")
@export var boomerang: Boomerang
@export var sprite: AnimatedSprite2D

var last_direction := Vector2.ONE

# Called when the node enters the scene tree for the first time.	
func _ready() -> void:
	boomerang.return_target = self

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and !boomerang.launched:
		var dir_to_mouse := global_position.direction_to(get_global_mouse_position())
		boomerang.launch(global_position, dir_to_mouse.angle(), velocity)
	if event.is_action_pressed("rotate"):
		get_parent().find_child("CellsSystem").find_child("Tile").rotate_self()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
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

func animate():
	var anim := "idle"
	if get_movement_vector():
		anim = "run"
	
	if last_direction.x >= 0:
		sprite.scale.x = 1
	else:
		sprite.scale.x = -1
	
	sprite.play(anim)


func get_movement_vector():
	var movement_x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var movement_y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(movement_x, movement_y)
