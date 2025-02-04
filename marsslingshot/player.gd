extends CharacterBody2D

const max_speed = 5000
const acceleration = 100
const friction = 12

var position_x
var position_y
var y_vec
var x_vec
const vscale = 30
const virtualG = vscale * 6.67 * pow(10, -20)
const mars = 6.39 * pow(10,23)
var input = Vector2.ZERO
var gravity = Vector2.ZERO
var xy = 0

@onready var endgame =  $"interaction/CollisionShape2D"

func _ready() -> void:
	set_i_gravity()
	add_to_group("detect")

func _physics_process(delta):
	player_movement(delta)
	
func _process(delta: float) -> void:
	set_gravity()
	velocity += gravity

func get_input():
	input.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return input.normalized()

func player_movement(delta):
	input = get_input()

	velocity += (input * acceleration * delta)
	velocity = velocity.limit_length(max_speed)
	look_at(get_position())
	
	move_and_slide()


func set_gravity():
	var y_ps = get_position().y
	var x_ps = get_position().x
	var angle = get_angle_to(get_position())
	print(rotation)
	xy = sqrt(y_ps * y_ps + x_ps * x_ps)
	y_vec = 1 / xy
	x_vec = 1 / xy
	gravity.x =  - x_vec * x_ps
	gravity.y =  - y_vec * y_ps
	gravity = Vector2(gravity.x, gravity.y)
	
func set_i_gravity():
	velocity = Vector2(0 , 50)


func _on_interaction_body_entered(body: Node2D) -> void:
	if body == $goal:
		print("entered")
		get_tree().quit()


func _on_interaction_area_entered(area: Area2D) -> void:
	if area == $detectarea:
		get_tree().quit()
