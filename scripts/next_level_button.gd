# script for end of meteoroid level button to transition to next minigame (slingshot)

extends Button

func _on_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://marsslingshot2.0/world.tscn") # replace with next level
