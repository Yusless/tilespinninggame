extends NaturalResourceNode
class_name TreeNode

@export var coal_res: NaturalResource
@export var wood_res: NaturalResource
@export var fires: Node2D

func burn():
	sprite.play("burnt")
	resource = coal_res
	var fire_options := fires.get_children()
	fire_options.shuffle()
	for i in range(2):
		fire_options[i].show()

func reset():
	super()
	resource = wood_res
	for fire in fires.get_children():
		fire.hide()

func harvest():
	super()
	for fire in fires.get_children():
		fire.hide()

func _on_hit():
	if not harvested:
		spawn_collectable()
