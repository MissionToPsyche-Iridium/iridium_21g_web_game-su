extends Node2D

@onready var label: Label = $Label
@onready var timer: Timer = $Label/Timer


func win_screen():
	timer.start()
	label.show()


func load_end_screen():
	get_tree().call_deferred("change_scene_to_file", "res://scenes/end_screen.tscn")


func _on_ready() -> void:
	label.hide()


func _on_timer_timeout() -> void:
	load_end_screen()
