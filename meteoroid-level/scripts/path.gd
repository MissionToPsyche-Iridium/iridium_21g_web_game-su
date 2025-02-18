extends Line2D

const MOVE = 1 # number of tiles to move

var tile_size = 128
var starting_tile = (Vector2(0, -1) * tile_size) + Vector2.ONE * tile_size/2 # centers line

var visited_lines = {}

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
	var step = inputs[dir] * tile_size * MOVE
	ray_cast_2d.target_position = step # moves the ray to new position and checks if it is against a border, restricts movements
	ray_cast_2d.force_raycast_update()
	if !ray_cast_2d.is_colliding():
		add_point(last_tile + step)
		
		var pair = [last_tile, last_tile + step]
		pair.sort()
		
		if visited_lines.has(pair):
			visited_lines[pair].append(create_overlap(last_tile, last_tile + step))
		else:
			visited_lines[pair] = []
		
		last_tile = get_point_position(get_point_count() - 1)
		ray_cast_2d.position = last_tile
		ray_cast_2d.force_raycast_update()
		return true
	return false

func remove_last_point() -> void:
	if get_point_count() > 1:
		
		var step = get_point_position(get_point_count() - 1)
		
		remove_point(get_point_count() - 1)
		last_tile = get_point_position(get_point_count() - 1)
		ray_cast_2d.position = last_tile
		
		remove_overlap(last_tile, step)


func create_overlap(point_a: Vector2, point_b: Vector2):
	var overlap_line = Line2D.new()
	overlap_line.default_color = Color(0.792, 0.298, 0.38)
	
	overlap_line.add_point(point_a)
	overlap_line.add_point(point_b)
	
	add_child(overlap_line)
	
	return overlap_line

func remove_overlap(point_a: Vector2, point_b: Vector2) -> void:
	var pair = [point_a, point_b]
	pair.sort()
	
	if visited_lines.has(pair):
		if !visited_lines[pair].is_empty():
			var overlap_line = visited_lines[pair].pop_back()
			overlap_line.queue_free()
		else:
			visited_lines.erase(pair)
