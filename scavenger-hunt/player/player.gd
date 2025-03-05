extends CharacterBody2D

const WALK_FORCE = 1200
const WALK_MAX_SPEED = 200
const STOP_FORCE = 2600

var direction
var movable = false
var facing = false
var moving = false

@export var sfx_footsteps : AudioStream
var footstep_frames : Array = [1,4]

signal interact
signal no_interact

func _ready() -> void:
	pass

func _physics_process(delta):
	if movable:                                                                 # If player is movable
		# Horizontal movement                                   
		var walk_x = WALK_FORCE * (Input.get_axis(&"ui_left", &"ui_right"))     # Get the player's input: left is negative (-1200), right is positive (1200)
		if Input.is_action_pressed("ui_left"):                                  # If left was pressed
			direction = "left"                                                  # Set direction to "left"
			$RayCast2D.target_position = Vector2(-20, 0)                        # Set direction of RayCast2D to face left
		if Input.is_action_pressed("ui_right"):                                 # If right was pressed
			direction = "right"                                                 # Set direciton to "right"
			$RayCast2D.target_position = Vector2(20, 0)                         # Set direction of RayCast2D to face right 
		if abs(walk_x) < WALK_FORCE * 0.2:                                      # Slow down the player if they're not trying to move.
			if direction == "left":                                             
				$PlayerSprite.play("idle_left")
			if direction == "right":
				$PlayerSprite.play("idle_right")
			# The velocity, slowed down a bit, and then reassigned.
			velocity.x = move_toward(velocity.x, 0, STOP_FORCE * delta)
		else:
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
			velocity.y += walk_y * delta
			
		# Ensure correct animation is playing 
		if velocity.length() > 0:  # If moving
			moving = true
			if direction == "up" and $PlayerSprite.animation != "walk_up":
				$PlayerSprite.play("walk_up")
			elif direction == "down" and $PlayerSprite.animation != "walk_down":
				$PlayerSprite.play("walk_down")
			elif direction == "left" and $PlayerSprite.animation != "walk_left":
				$PlayerSprite.play("walk_left")
			elif direction == "right" and $PlayerSprite.animation != "walk_right":
				$PlayerSprite.play("walk_right")
		else:  # If stopped, play idle animation
			moving = false
			if direction == "up" and $PlayerSprite.animation != "idle_up":
				$PlayerSprite.play("idle_up")
			elif direction == "down" and $PlayerSprite.animation != "idle_down":
				$PlayerSprite.play("idle_down")
			elif direction == "left" and $PlayerSprite.animation != "idle_left":
				$PlayerSprite.play("idle_left")
			elif direction == "right" and $PlayerSprite.animation != "idle_right":
				$PlayerSprite.play("idle_right")

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
	moving = false

func _on_room_2_popup_close() -> void:
	movable = true

func _on_room_2_popup_open() -> void:
	movable = false
	moving = false
	
func _on_room_3_popup_close() -> void:
	movable = true

func _on_room_3_popup_open() -> void:
	movable = false
	moving = false


func load_sfx(sfx_to_load):
	if $Audio/sfx_player.stream != sfx_to_load:
		$Audio/sfx_player.stop()
		$Audio/sfx_player.stream = sfx_to_load

func _on_player_sprite_frame_changed() -> void:
	if "idle" in $PlayerSprite.animation:  # Skip if idle
		return

	if sfx_footsteps:  # Ensure the sound is assigned
		load_sfx(sfx_footsteps)

	if $PlayerSprite.frame in footstep_frames and moving:
		if !$Audio/sfx_player.playing:  # Prevent overlapping sounds
			$Audio/sfx_player.play()


func _on_world_is_moving() -> void:
	moving = true
