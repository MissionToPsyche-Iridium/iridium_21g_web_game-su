extends CharacterBody2D

const WALK_FORCE = 1200
const WALK_MAX_SPEED = 400
const STOP_FORCE = 2600

var direction
var movable = true

func _physics_process(delta):
	if movable:
		# Horizontal movement code. First, get the player's input.
		var walk_x = WALK_FORCE * (Input.get_axis(&"move_left", &"move_right"))
		if Input.is_action_just_pressed("move_left"):
			direction = "left"
		if Input.is_action_just_pressed("move_right"):
			direction = "right"
		# Slow down the player if they're not trying to move.
		if abs(walk_x) < WALK_FORCE * 0.2:
			if direction == "left":
				$AnimatedSprite2D.play("left_still")
			if direction == "right":
				$AnimatedSprite2D.play("right_still")
			# The velocity, slowed down a bit, and then reassigned.
			velocity.x = move_toward(velocity.x, 0, STOP_FORCE * delta)
		else:
			if direction == "left":
				$AnimatedSprite2D.play("left_walk")
			if direction == "right":
				$AnimatedSprite2D.play("right_walk")
			velocity.x += walk_x * delta
		# Clamp to the maximum horizontal movement speed.
		velocity.x = clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)

		# Vertical movement code. First, get the player's input.
		var walk_y = WALK_FORCE * (Input.get_axis(&"move_up", &"move_down"))
		if Input.is_action_just_pressed("move_up"):
			direction = "up"
		if Input.is_action_just_pressed("move_down"):
			direction = "down"
		# Slow down the player if they're not trying to move.
		if abs(walk_y) < WALK_FORCE * 0.2:
			if direction == "up":
				$AnimatedSprite2D.play("up_still")
			if direction == "down":
				$AnimatedSprite2D.play("down_still")
			# The velocity, slowed down a bit, and then reassigned.
			velocity.y = move_toward(velocity.y, 0, STOP_FORCE * delta)
		else:
			if direction == "up":
				$AnimatedSprite2D.play("up_walk")
			if direction == "down":
				$AnimatedSprite2D.play("down_walk")
			velocity.y += walk_y * delta

		# Clamp to the maximum horizontal movement speed.
		velocity.y = clamp(velocity.y, -WALK_MAX_SPEED, WALK_MAX_SPEED)


		# Move based on the velocity.
		move_and_slide()
	
	



func _on_collectible_hit() -> void:
	print("hit in player")
	velocity.x = 0
	velocity.y = 0
	if direction == "up":
		$AnimatedSprite2D.play("up_still")
	elif direction == "down":
		$AnimatedSprite2D.play("down_still")
	elif direction == "right":
		$AnimatedSprite2D.play("right_still")
	elif direction == "left":
		$AnimatedSprite2D.play("left_still")
	movable = false
	


func _on_pop_up_close() -> void:
	movable = true
	


func _on_win_area_win() -> void:
	movable = false
