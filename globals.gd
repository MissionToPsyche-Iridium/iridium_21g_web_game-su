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
		Audio.play_music_rooms(-15)
		get_tree().change_scene_to_file("res://scavenger-hunt/world.tscn")
	if input_text == ("2"):
		Audio.play_music_minigame(-15)
		get_tree().change_scene_to_file("res://meteoroid-level/scenes/level_1_screen.tscn")
	if input_text == ("3"):
		Audio.play_music_minigame(-15)
		get_tree().change_scene_to_file("res://marsslingshot2.0/slingshot/world.tscn")
	if input_text == ("4"):
		Audio.play_music_minigame(-15)
		get_tree().change_scene_to_file("res://psychescan/levels/main_level.tscn")
	if input_text == ("5"):
		Audio.play_music_minigame(-15)
		get_tree().change_scene_to_file("res://Finished Screen/Scene.tscn")
	

func _on_mute_toggled(toggled_on: bool) -> void:
	var master_bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(master_bus_index, toggled_on)
	$Mute.focus_mode = false
