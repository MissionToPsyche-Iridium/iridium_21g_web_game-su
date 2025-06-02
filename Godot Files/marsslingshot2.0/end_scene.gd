# script for the end screen dialogue

extends Control

var text = [
	"Great work! The Psyche Mission is using
	
	the sling shot maneuver. This maneuver
	
	is used to set trajectory and speed
	
	using minimal fuel. The Psyche Mission
	
	uses mars as a gravitational assist. 
	
	This allows the spacecraft to speed
	
	up, slow down and change course."
]
@onready var message: Label = $Message
@onready var next_level_button: Button = $NextLevelButton
@onready var typing_sound: AudioStreamPlayer2D = $TypingSound

const base_speed := 40
var started := true
var finished := false
var count := 0.0
var covered = true
var start = false

func _ready() -> void:
	next_level_button.hide() # hide button until dialogue done
	await get_tree().create_timer(1.0).timeout
	start = true

# function to read stream of text and type it out
func _process(delta: float) -> void:
	if (start):
		if(message.get_visible_ratio() != 1.0):
			if(count < 1):
				count += base_speed*delta
			else:
				message.set_visible_characters(message.get_visible_characters()+1)
				if (message.get_visible_characters() % 2 == 0):
					typing_sound.play()
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

# can skip dialogue
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
