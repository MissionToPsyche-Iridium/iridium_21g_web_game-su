# Meteoroid script to determine movement

extends Node2D

const MOVE = 1 # number of tiles to move over on grid
const ROTATION_SPEED = 0.5 # radians per second
var tile_size = 128
var animation_speed = 1.5 # speed of movement to next tile(s)
var moving = false 

var inputs = {1: "engine nozzle", # debris frames
2: "fueltank",
3: "satellitedish",
4: "solarpanel",
5: "wires"}

var rng = RandomNumberGenerator.new()
var random_rotation_num
var random_frame_num


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	random_rotation_num = rng.randi_range(1, 2)
	random_frame_num = rng.randi_range(1, 5)
	
	animated_sprite_2d.play(inputs[random_frame_num])
	
	var shuttle_node = get_tree().current_scene.get_node("Shuttle") # Meteoroids connect to the shuttle to move when shuttle moves
	shuttle_node.connect("meteoroid_movement", move) # signal

func _process(delta: float) -> void:
	if random_rotation_num == 1:
		rotation += ROTATION_SPEED * delta
	else:
		rotation -= ROTATION_SPEED * delta

func move() -> void:
	var tween = create_tween() # animate the movement
	tween.tween_property(self, "position", position + (Vector2.LEFT * tile_size * MOVE), 1.0/animation_speed)
	moving = true
	await tween.finished
	moving = false
