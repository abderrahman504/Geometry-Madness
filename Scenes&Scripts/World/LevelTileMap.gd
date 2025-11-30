extends TileMap
class_name LevelTileMap

const FLOOR_SOURCE : int = 1
const WALL_SOURCE : int = 0


func _ready() -> void:
	GlobalReferences.level_tilemap = self


## Returns the indeces of all floor tiles
func get_floor_tiles() -> PackedVector2Array:
	return get_used_cells_by_id(0, FLOOR_SOURCE)


## Returns the global position in pixels of the top left corner of the tile at the given coordinates.
func get_global_tile_pos(coords : Vector2i) -> Vector2:
	var local_pos : Vector2i = tile_set.tile_size * coords

	return Vector2(local_pos.x * global_scale.x, local_pos.y * global_scale.y) + global_position


func get_global_tile_size() -> Vector2:
	return Vector2(tile_set.tile_size.x * global_scale.x, tile_set.tile_size.y * global_scale.y)
