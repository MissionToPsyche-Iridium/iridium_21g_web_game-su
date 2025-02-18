extends Node2D

@onready var timer: Timer = $Timer
@onready var shuttle: CharacterBody2D = $Shuttle
@onready var color_rect: ColorRect = $ColorRect
@onready var win_sound: AudioStreamPlayer2D = $WinSound
@onready var lose_sound: AudioStreamPlayer2D = $LoseSound

func win_screen():
	win_sound.play()
	timer.start()
	var tween = create_tween()
	tween.tween_property(color_rect, "color", Color8(0, 255, 0, 100), 2.0)
	await tween.finished

func load_next_screen():
	get_tree().call_deferred("change_scene_to_file", "res://meteoroid-level/scenes/level_3_screen.tscn")


func _on_ready() -> void:
	color_rect.color = Color8(0, 255, 0, 0)
	shuttle.level_2_changes()


func _on_timer_timeout() -> void:
	load_next_screen()


func lose_screen() -> void:
	lose_sound.play()
	color_rect.color = Color8(255, 0, 0, 0)
	
	var tween = create_tween()
	tween.tween_property(color_rect, "color", Color8(255, 0, 0, 100), 2.0)
	await tween.finished
