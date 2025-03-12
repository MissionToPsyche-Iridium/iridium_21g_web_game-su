extends Node

var input_buffer = ""

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.unicode > 0:  # Check if it's a printable character
			input_buffer += char(event.unicode)
		
	if event.is_action_pressed("ui_accept"):  # When Enter is pressed
		process_input(input_buffer)
		input_buffer = ""  # Clear buffer for next input

func process_input(input_text):
	if input_text == ("1"):
		get_tree().change_scene_to_file("res://scavenger-hunt/world.tscn")
	if input_text == ("2"):
		get_tree().change_scene_to_file("res://meteoroid-level/scenes/level_1_screen.tscn")
	if input_text == ("3"):
		get_tree().change_scene_to_file("res://marsslingshot2.0/slingshot/world.tscn")
	if input_text == ("4"):
		get_tree().change_scene_to_file("res://psychescan/levels/main_level.tscn")
	if input_text == ("5"):
		get_tree().change_scene_to_file("res://Finished Screen/Scene.tscn")
