extends CharacterBody2D
class_name Boomerang

@export var fly_distance := 16.0 * 8
@export var fly_speed := 480.0
@export var max_fly_speed := 480.0 * 2.0
@export var inherited_speed_multiplier := 0.0
@export var decceleration_strength := 4800.0
@export var sprite_rotation_speed := PI * 12

@export_group("Deps")
@export var sprite: Sprite2D
@export var hitbox: AttackComponent


var launched := false
var returning := false
var returning_straight := false
var decceleration := Vector2.ZERO
var return_target: CharacterBody2D
var distance_flied := 0.0
var target_fly_distance := 0.0

func launch(origin: Vector2, direction: float, inherited_speed: Vector2):
	var base_velocity := Vector2.RIGHT * fly_speed
	velocity = base_velocity.rotated(direction) + inherited_speed * inherited_speed_multiplier
	launched = true
	returning = false
	returning_straight = false
	global_position = origin
	distance_flied = 0.0
	hitbox.begin_attack()
	show()

func retrieve():
	launched = false
	hitbox.end_attack()
	hide()

func _physics_process(delta: float) -> void:
	
	if launched:
		distance_flied += velocity.length() * delta
		if distance_flied >= fly_distance and !returning:
			returning = true
			hitbox.begin_attack()
		if returning and !returning_straight:
			decceleration = global_position.direction_to(return_target.global_position) * decceleration_strength
			velocity += decceleration * delta
		if max_fly_speed - velocity.length() <= 20 and returning:
			returning_straight = true
		if returning_straight:
			velocity = max_fly_speed * global_position.direction_to(return_target.global_position)
		sprite.rotate(sprite_rotation_speed * delta)
	velocity.limit_length(max_fly_speed)
	move_and_slide()

func bounce():
	returning = true
	returning_straight = false
	hitbox.begin_attack()
	velocity = -velocity*0.75
	velocity += velocity.rotated(randf_range(-PI/2, PI/2)) * 0.5

func _on_return_detector_body_entered(body: Node2D) -> void:
	if body == return_target and returning:
		retrieve()


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bouncers"):
		bounce()
