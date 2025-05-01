extends Node

@onready var minigame_level
@onready var minigame_index

@onready var minigame_hints = [
	$EscapeRoomHints,
	$LaunchHints,
	$MeteoroidHints,
	$MarsHints,
	$ScanHints,
	$TypingHints,
]

signal hint_open
signal hint_close

var previous_scene_path := ""

func _process(delta: float) -> void:
	if get_tree().current_scene == null:
		return

	var scene_path = get_tree().current_scene.scene_file_path
	
	if scene_path != previous_scene_path:
		previous_scene_path = scene_path

		var folder_name = scene_path.get_base_dir().replace("res://", "").split("/")[0]
		minigame_level = folder_name
		match minigame_level:
			"scavenger-hunt": 
				minigame_index = 0
			"launch": 
				minigame_index = 1
			"meteoroid-level": 
				minigame_index = 2
			"marsslingshot2.0": 
				minigame_index = 3
			"psychescan": 
				minigame_index = 4
			"Typing Level": 
				minigame_index = 5
		
		for hint in minigame_hints:
			if hint:
				hint.visible = false
	
	if minigame_index:
		if !minigame_hints[minigame_index]:
			$Hint.hide()
		elif minigame_hints[minigame_index]:
			$Hint.show()

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
		get_tree().change_scene_to_file("res://scavenger-hunt/scenes/world.tscn")
	if input_text == ("2"):
		Audio.play_music_minigame(-15)
		get_tree().change_scene_to_file("res://meteoroid-level/scenes/start_screen.tscn")
	if input_text == ("3"):
		Audio.play_music_minigame(-15)
		get_tree().change_scene_to_file("res://marsslingshot2.0/scenes/world.tscn")
	if input_text == ("4"):
		Audio.play_music_minigame(-15)
		get_tree().change_scene_to_file("res://psychescan/levels/main_level.tscn")
	if input_text == ("5"):
		Audio.play_music_minigame(-15)
		get_tree().change_scene_to_file("res://Typing Level/TypingLevel.tscn")
	

func _on_mute_toggled(toggled_on: bool) -> void:
	var master_bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(master_bus_index, toggled_on)
	$Mute.focus_mode = false


func _on_check_box_toggled(toggled_on: bool) -> void:
	if minigame_hints[minigame_index]:
		minigame_hints[minigame_index].visible = toggled_on
		$Hint.focus_mode = false
		if toggled_on:
			hint_open.emit()
		else:
			hint_close.emit()
