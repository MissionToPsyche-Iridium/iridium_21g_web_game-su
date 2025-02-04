extends Node2D

@onready var label: Label = $Label
@onready var timer: Timer = $Label/Timer
@onready var shuttle: CharacterBody2D = $Shuttle


func win_screen():
	timer.start()
	label.show()


func load_next_screen():
	get_tree().call_deferred("change_scene_to_file", "res://scenes/level_3_screen.tscn")


func _on_ready() -> void:
	label.hide()
	shuttle.level_2_changes()


func _on_timer_timeout() -> void:
	load_next_screen()
