extends Control

var text = [
		"Credits",
		"A game by Us",
		"Programming",
		"Programmer Name",
		"Programmer Name 2",
		"Art",
		"Artist Name",
		"Music",
		"Musician Name",
		"Sound Effects",
		"SFX Name",
		"Testers",
		"Name 1",
		"Name 2",
		"Name 3",
		"Tools used",
		"Developed with Godot Engine",
		"https://godotengine.org/license",
		"",
		"Art created with My Favourite Art Program",
		"https://myfavouriteartprogram.com",
		"Special thanks",
		"My parents",
		"My friends",
		"My pet rabbit"
]
@onready var label := $Label
const base_speed := 20
var started := true
var finished := false
var count := 0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var typing_speed = base_speed * delta
	if(label.get_visible_ratio() != 1.0):
		if(count < 1):
			count += base_speed*delta
		else:
			label.set_visible_characters(label.get_visible_characters()+1)
			count -= 1
	if(started):
		changeText()
		started = false
	
	pass
	
func changeText():
	if text.size() > 0:
		label.set_visible_ratio(0.0)
		label.text = text.pop_front()

func finish():
	if not finished:
		# NOTE: This is called when the credits finish scrolling
		finished = true
		get_tree().change_scene_to_file("res://Scene.tscn")

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		finished = true
	if event.is_action_pressed("ui_accept"):
		if(label.get_visible_ratio() == 1.0):
			changeText()
		else:
			label.set_visible_ratio(1.0)
