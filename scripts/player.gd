extends CharacterBody2D

var max_speed = 200

# Called when the node enters the scene tree for the first time.	
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	var movement = get_movement_vector()
	var direction = movement.normalized()
	velocity = max_speed * direction
	move_and_slide()


func get_movement_vector():
	var movement_x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var movement_y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(movement_x, movement_y)
