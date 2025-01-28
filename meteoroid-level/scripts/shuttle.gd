extends CharacterBody2D

signal meteoroid_movement # signal for meteoroids when the shuttle moves

const MOVE = 2 # number of tiles to move
const MAX_MOVES = 10
var tile_size = 128
var animation_speed = 1
var moving = false
var target_tile = (Vector2(8, -1) * tile_size) + (Vector2.ONE * tile_size/2)
var animation_tile = Vector2(-5, -1) * tile_size
var starting_tile = Vector2(0, -1) * tile_size # starting tile for the game

var inputs = {"ui_right": Vector2.RIGHT, # directional inputs using arrow keys
"ui_left": Vector2.LEFT,
"ui_up": Vector2.UP,
"ui_down": Vector2.DOWN}

@onready var game: Node2D = $".."
@onready var input_container: HBoxContainer = $"../CanvasLayer/InputContainer"
@onready var path: Line2D = $"../Path"


var input_array = [] # array to store inputs

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = animation_tile
	position += Vector2.ONE * tile_size/2  # centers shuttle in tile
	
	
	#  animation for shuttle to move to starting tile
	var tween = create_tween()
	tween.tween_property(self, "position", starting_tile + (Vector2.ONE * tile_size/2), 1.0/animation_speed).set_trans(Tween.TRANS_SINE) # set starting tile
	moving = true
	await tween.finished
	moving = false

func _unhandled_input(event: InputEvent) -> void:
	if moving:
		return # restricts input until move complete
	for dir in inputs.keys(): # checks through list of allowed inputs to store into array
		if event.is_action_pressed(dir):
			add_input(dir)
	if event.is_action_pressed("ui_cancel"):
		remove_input()
	if event.is_action_pressed("ui_accept"): # if user presses enter to finalize inputs
		move()

func move():
	for dir in input_array:
		call_meteoroids_move() # signals to meteoroids
		
		var tween = create_tween()
		tween.tween_property(self, "position", position + inputs[dir] * tile_size * MOVE, 1.0/animation_speed).set_trans(Tween.TRANS_SINE)
		moving = true
		await tween.finished
		moving = false
	input_array.clear()
	win_condition()

func call_meteoroids_move() -> void:
	emit_signal("meteoroid_movement")
	
func add_input(dir: String) -> void:
	if input_array.size() < MAX_MOVES:
		if(path.trace(dir)):
			input_array.append(dir)
			input_container.create_arrow(dir)

func remove_input() -> void:
	input_array.pop_back()
	input_container.remove_arrow()
	path.remove_last_point()

func win_condition() -> void:
	if position == target_tile:
		game.win_screen()
	else:
		get_tree().call_deferred("change_scene_to_file", "res://scenes/game.tscn")
