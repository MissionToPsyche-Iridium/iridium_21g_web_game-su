extends CharacterBody2D
signal hit

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
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		direction = "left"
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		direction = "down"
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		direction = "up"
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		if direction == "right":
			$AnimatedSprite2D.play("right_walk")
		if direction == "left":
			$AnimatedSprite2D.play("left_walk")
		if direction == "down":
			$AnimatedSprite2D.play("down_walk")
		if direction == "up":
			$AnimatedSprite2D.play("up_walk")
	else:
		if direction == "right":
			$AnimatedSprite2D.play("right_still")
		if direction == "left":
			$AnimatedSprite2D.play("left_still")
		if direction == "down":
			$AnimatedSprite2D.play("down_still")
		if direction == "up":
			$AnimatedSprite2D.play("up_still")
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)


func _on_body_entered(body: Node2D) -> void:
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
	

func _on_hit() -> void:
	print("Hit")
