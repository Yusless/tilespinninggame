extends Enemy
class_name Dragonfly

@export var fireball_scene: PackedScene
@export var fireball_origin: Marker2D
@export var fly_sound: AudioStreamPlayer2D

func _ready() -> void:
	super()
	fly_sound.play()

func shoot_fireball():
	var fireball: Projectile = fireball_scene.instantiate()
	get_parent().add_child(fireball)
	fireball.global_position = fireball_origin.global_position
	fireball.launch(global_position.direction_to(combat_target.global_position))

func attack():
	super()
	attacking = true


func _on_sprite_frame_changed() -> void:
	if sprite.frame == 4 and sprite.animation == "attack":
		shoot_fireball()

func die():
	super()
	fly_sound.stop()

func _on_sprite_animation_finished() -> void:
	if sprite.animation == "attack":
		end_attack()


func _on_fly_sound_finished() -> void:
	fly_sound.play()
