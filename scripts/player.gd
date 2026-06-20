extends CharacterBody2D

var max_speed = 200
@export var boomerang: Boomerang

# Called when the node enters the scene tree for the first time.	
func _ready() -> void:
	boomerang.return_target = self

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and !boomerang.launched:
		var dir_to_mouse := global_position.direction_to(get_global_mouse_position())
		boomerang.launch(global_position, dir_to_mouse.angle(), velocity)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var movement = get_movement_vector()
	var direction = movement.normalized()
	velocity = max_speed * direction
	move_and_slide()


func get_movement_vector():
	var movement_x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var movement_y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(movement_x, movement_y)
