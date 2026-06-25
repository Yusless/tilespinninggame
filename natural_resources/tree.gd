extends NaturalResourceNode
class_name TreeNode

@export var coal_res: NaturalResource
@export var wood_res: NaturalResource

func burn():
	sprite.play("burnt")
	resource = coal_res

func reset():
	super()
	resource = wood_res

func _on_hit():
	if not harvested:
		spawn_collectable()
