extends CharacterBody2D

var input = Vector2.ZERO
const acceleration = 100
const max_speed = 5000
const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	player_movement(delta)
	velocity += get_gravity()
	move_and_slide()

func get_input():
	input.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return input.normalized()
	
func player_movement(delta):
	input = get_input()

	velocity += (input * acceleration * delta)
	velocity = velocity.limit_length(max_speed)
	
	move_and_slide()
