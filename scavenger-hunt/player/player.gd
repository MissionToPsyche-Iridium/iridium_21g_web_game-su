extends CharacterBody2D

const WALK_FORCE = 1200
const WALK_MAX_SPEED = 200
const STOP_FORCE = 2600

var direction
var movable = false
var facing = false

signal interact
signal no_interact

func _ready() -> void:
	pass

func _physics_process(delta):
	if movable:
		# Horizontal movement code. First, get the player's input.
		var walk_x = WALK_FORCE * (Input.get_axis(&"ui_left", &"ui_right"))
		if Input.is_action_pressed("ui_left"):
			direction = "left"
			$RayCast2D.target_position = Vector2(-20, 0)
		if Input.is_action_pressed("ui_right"):
			direction = "right"
			$RayCast2D.target_position = Vector2(20, 0)
		# Slow down the player if they're not trying to move.
		if abs(walk_x) < WALK_FORCE * 0.2:
			if direction == "left":
				$PlayerSprite.play("idle_left")
			if direction == "right":
				$PlayerSprite.play("idle_right")
			# The velocity, slowed down a bit, and then reassigned.
			velocity.x = move_toward(velocity.x, 0, STOP_FORCE * delta)
		else:
			if direction == "left":
				$PlayerSprite.play("walk_left")
			if direction == "right":
				$PlayerSprite.play("walk_right")
			velocity.x += walk_x * delta
		# Clamp to the maximum horizontal movement speed.
		velocity.x = clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)

		# Vertical movement code. First, get the player's input.
		var walk_y = WALK_FORCE * (Input.get_axis(&"ui_up", &"ui_down"))
		if Input.is_action_pressed("ui_up"):
			direction = "up"
			$RayCast2D.target_position = Vector2(0, -20)
		if Input.is_action_pressed("ui_down"):
			direction = "down"
			$RayCast2D.target_position = Vector2(0, 20)
		# Slow down the player if they're not trying to move.
		if abs(walk_y) < WALK_FORCE * 0.2:
			if direction == "up":
				$PlayerSprite.play("idle_up")
			if direction == "down":
				$PlayerSprite.play("idle_down")
			# The velocity, slowed down a bit, and then reassigned.
			velocity.y = move_toward(velocity.y, 0, STOP_FORCE * delta)
			
		else:
			if direction == "up":
				$PlayerSprite.play("walk_up")
			if direction == "down":
				$PlayerSprite.play("walk_down")
			velocity.y += walk_y * delta


		# Clamp to the maximum horizontal movement speed.
		velocity.y = clamp(velocity.y, -WALK_MAX_SPEED, WALK_MAX_SPEED)

		# Move based on the velocity.
		move_and_slide()
		
		if ($RayCast2D.is_colliding()):
			interact.emit()
			
		if (!$RayCast2D.is_colliding()):
			no_interact.emit()
	

func _on_room_1_popup_close() -> void:
	movable = true

func _on_room_1_popup_open() -> void:
	movable = false

func _on_room_2_popup_close() -> void:
	movable = true

func _on_room_2_popup_open() -> void:
	movable = false
	
func _on_room_3_popup_close() -> void:
	movable = true

func _on_room_3_popup_open() -> void:
	movable = false


	
