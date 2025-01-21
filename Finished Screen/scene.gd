extends Node2D

const section_time := 2.0
const base_speed := 500
const speed_up_multiplier := 10.0

var scroll_speed := base_speed
var speed_up = false

@onready var label = $PageContainer/Control/Label4
@onready var container = $PageContainer
var scrollDone = false
var textDone = false
var fadeDone = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var scroll_speed = base_speed * delta
	
	if container.global_position.y > 0:
		container.global_position.y -= scroll_speed
	else:
		scrollDone = true
	if scrollDone && !textDone:
		if label.get_visible_ratio() < 1:
			label.set_visible_ratio(label.get_visible_ratio()+(.5*delta))
		else:
			textDone = true
	elif textDone && !fadeDone:
		if get_modulate() == Color(1,1,1,1):
			fadeDone = true
		else:
			set_modulate(lerp(get_modulate(), Color(1,1,1,0), 0.2))
	elif fadeDone:
		get_tree().change_scene_to_file("res://credits.tscn")
		
		
