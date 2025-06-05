extends Node2D

var text = [
"
Use the up arrow or 'W' to boost

and the side arrows or 'A'/'D' to

rotate the spacecraft"
]

var start = false
const base_speed := 40
var started := true
var finished := false
var count := 0.0
var covered = true
@onready var message : Label = $Label2

var number: float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (start):
		if(message.get_visible_ratio() != 1.0):
			if(count < 1):
				count += base_speed*delta
			else:
				message.set_visible_characters(message.get_visible_characters()+1)
				count -= 1
		else:
			if text.is_empty() && !finished:
				finished = true
			else:
				if (covered):
					covered = false
		if(started):
			changeText()
			started = false
		if (finished):
			covered = false
			
	set_label()
	set_size_colorrect()

func set_label() -> void:
	number = sqrt($space_ship.velocity.x*$space_ship.velocity.x + $space_ship.velocity.y * $space_ship.velocity.y)
	$Label.text = str(number).pad_decimals(2)

func changeText():
	if text.size() > 0:
		message.set_visible_ratio(0.0)
		message.text = text.pop_front()
	else: 
		finished = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	get_tree().reload_current_scene()

func set_size_colorrect() :
	$ColorRect.size.x = $space_ship/Timer.get_time_left() * 500


func _on_timer_timeout() -> void:
	$ColorRect.visible = false




func _on_area_2d_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://marsslingshot2.0/scenes/TransitionScreen.tscn") # Replace with function body.


func _on_wait_1_second_timeout() -> void:
	$Label2.visible = false
