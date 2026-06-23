extends Enemy
class_name Dragonfly

@export var fireball_scene: PackedScene
@export var fireball_origin: Marker2D

func shoot_fireball():
	var fireball: Projectile = fireball_scene.instantiate()
	get_parent().add_child(fireball)
	fireball.global_position = fireball_origin.global_position
	fireball.launch(global_position.direction_to(combat_target.global_position))

func attack():
	super()
	shoot_fireball()
	attacking = true
	state = States.HOSTILE
	has_hyper_armor = false
	create_tween().tween_property(sprite, "rotation", 0.0, 0.08)
	attack_cooldown.start()
