extends CharacterBody2D

const SPEED = 50.0
var gas = true

var movement_allowed = false

func _physics_process(delta: float) -> void:
	if movement_allowed:
		player_movement(delta)
		velocity += get_gravity()
		move_and_slide()

func player_movement(delta):
	if not gas:
		print("out of gas")
	if Input.is_action_pressed("ui_left"):
		rotate(-.05)
	if Input.is_action_pressed("ui_right"):
		rotate(.05)
	if Input.is_action_pressed("ui_up"):
		velocity += transform.x * SPEED * delta
	move_and_slide()

func _on_timer_timeout() -> void:
	gas = false
	print("out of gas")
