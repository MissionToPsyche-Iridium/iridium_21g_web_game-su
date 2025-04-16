extends Control

var text = [
	"The Psyche spacecraft travels through space using solar-electric propulsion. Changes in movements are slow. When obstacles like space debris are detected, scientists must calculate course corrections to avoid the obstacles in the best way to save fuel."
]
@onready var message: Label = $Message
@onready var next_level_button: Button = $NextLevelButton

const base_speed := 50
var started := true
var finished := false
var count := 0.0
var covered = true
var start = false

func _ready() -> void:
	next_level_button.hide()
	await get_tree().create_timer(1.0).timeout
	start = true

func _process(delta: float) -> void:
	if (start):
		if(message.get_visible_ratio() != 1.0):
			if(count < 1):
				count += base_speed*delta
			else:
				message.set_visible_characters(message.get_visible_characters()+1)
				#if (message.get_visible_characters() % 2 == 0):
					#$Audio/sfx_dialogue.play()
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
			next_level_button.show()

func changeText():
	if text.size() > 0:
		message.set_visible_ratio(0.0)
		message.text = text.pop_front()
	else: 
		finished = true

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		covered = true
		if(message.get_visible_ratio() == 1.0):
			changeText()
		else:
			message.set_visible_ratio(1.0)
	if event.is_action_pressed("interact"):
		while text.size() != 0:
			covered = true
			if(message.get_visible_ratio() == 1.0):
				changeText()
			else:
				message.set_visible_ratio(1.0)

#func _on_ready_pressed() -> void:
	#await get_tree().create_timer(0.2).timeout
	#get_tree().change_scene_to_file("res://scavenger-hunt/world.tscn")
