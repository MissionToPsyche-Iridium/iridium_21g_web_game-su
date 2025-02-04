extends Line2D

const MOVE = 1 # number of tiles to move

var tile_size = 128
var starting_tile = (Vector2(0, -1) * tile_size) + Vector2.ONE * tile_size/2 # centers line

var inputs = {"ui_right": Vector2.RIGHT, # directional inputs using arrow keys
"ui_left": Vector2.LEFT,
"ui_up": Vector2.UP,
"ui_down": Vector2.DOWN}

var last_tile = starting_tile

@onready var ray_cast_2d: RayCast2D = $RayCast2D

func _ready() -> void:
	add_point(starting_tile)
	ray_cast_2d.position = starting_tile

func trace(dir: String):
	ray_cast_2d.target_position = (inputs[dir] * tile_size * MOVE) # moves the ray to new position and checks if it is against a border, restricts movements
	ray_cast_2d.force_raycast_update()
	if !ray_cast_2d.is_colliding():
		add_point(last_tile + (inputs[dir] * tile_size * MOVE))
		last_tile = get_point_position(get_point_count() - 1)
		ray_cast_2d.position = last_tile
		# ray_cast_2d.force_raycast_update()
		return true
	return false

func remove_last_point() -> void:
	if get_point_count() > 1:
		remove_point(get_point_count() - 1)
		last_tile = get_point_position(get_point_count() - 1)
		ray_cast_2d.position = last_tile
