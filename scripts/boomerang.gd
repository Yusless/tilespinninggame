extends CharacterBody2D
class_name Boomerang

@export var fly_distance := 16.0 * 8
@export var fly_speed := 480.0
@export var max_fly_speed := 480.0 * 2.0
@export var inherited_speed_multiplier := 0.4
@export var decceleration_strength := 4800.0
@export var sprite_rotation_speed := PI * 12
@export_group("Deps")
@export var sprite: Sprite2D
@export var hitbox: Area2D


var launched := false
var returning := false
var decceleration := Vector2.ZERO
var return_target: CharacterBody2D
var distance_flied := 0.0

func _ready() -> void:
	hitbox.body_entered.connect(_on_hitbox_body_entered)

func launch(origin: Vector2, direction: float, inherited_speed: Vector2):
	var base_velocity := Vector2.RIGHT * fly_speed
	velocity = base_velocity.rotated(direction) + inherited_speed * inherited_speed_multiplier
	launched = true
	returning = false
	global_position = origin
	distance_flied = 0.0
	show()

func retrieve():
	launched = false
	hide()

func _physics_process(delta: float) -> void:
	
	if launched:
		distance_flied += velocity.length() * delta
		if distance_flied >= fly_distance:
			decceleration = global_position.direction_to(return_target.global_position) * decceleration_strength
			velocity += decceleration * delta
			returning = true
		sprite.rotate(sprite_rotation_speed * delta)
	
	velocity.limit_length(max_fly_speed)
	move_and_slide()


func _on_hitbox_body_entered(body: PhysicsBody2D) -> void:
	if body == return_target and returning:
		retrieve()
