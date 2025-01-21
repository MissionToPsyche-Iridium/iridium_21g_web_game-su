# Meteoroid script to determine movement

extends Node2D

const MOVE = 2 # number of tiles to move over on grid

var tile_size = 128
var animation_speed = 1 # speed of movement to next tile(s)
var moving = false 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var shuttle_node = get_tree().current_scene.get_node("Shuttle") # Meteoroids connect to the shuttle to move when shuttle moves
	shuttle_node.connect("meteoroid_movement", move) # signal

func move() -> void:
	var tween = create_tween() # animate the movement
	tween.tween_property(self, "position", position + (Vector2.LEFT * tile_size * MOVE), 1.0/animation_speed).set_trans(Tween.TRANS_SINE)
	moving = true
	await tween.finished
	moving = false
