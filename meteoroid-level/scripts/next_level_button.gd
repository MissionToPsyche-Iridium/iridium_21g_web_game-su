extends Button

func _on_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://psychescan/scenes/tutorialLevel.tscn") # replace with next level
