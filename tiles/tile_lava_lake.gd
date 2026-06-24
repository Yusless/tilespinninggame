extends Tile
class_name TileLavaLake

@export var enemy_spawner: EnemySpawner

func interact(neighbour: Tile, _side: Side.Sides):
	enemy_spawner.points_of_interest.clear()
	match neighbour.tile_type:
		TileTypes.WHEAT:
			enemy_spawner.points_of_interest.push_back(neighbour.global_position)
		TileTypes.FOREST:
			enemy_spawner.points_of_interest.push_front(neighbour.global_position)
	if neighbour.has_method("burn"):
		neighbour.burn()
