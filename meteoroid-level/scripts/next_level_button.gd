# script for end of meteoroid level button to transition to next minigame (slingshot)

extends Button
@onready var clicksound: AudioStreamPlayer2D = $"../Clicksound"
@onready var timer: Timer = $"../Timer"

func _on_pressed() -> void:
	clicksound.play()
	timer.start()
	


func _on_timer_timeout() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://marsslingshot2.0/world.tscn") # replace with next level
