extends CharacterBody2D

@export var speed = 200 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var direction

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		direction = "right"
		velocity.x = 1
	if Input.is_action_pressed("move_left"):
		direction = "left"
		velocity.x = -1
	if Input.is_action_pressed("move_down"):
		direction = "down"
		velocity.y = -1
	if Input.is_action_pressed("move_up"):
		direction = "up"
		velocity.y = -1
	velocity = velocity.normalized()
	
	#
	position += velocity * delta
	#position = position.clamp(Vector2.ZERO, screen_size)
