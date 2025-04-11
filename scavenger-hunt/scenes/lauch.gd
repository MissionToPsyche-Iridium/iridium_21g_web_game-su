extends Control

const prelaunch = preload("res://scavenger-hunt/assets/launch/prelaunch.ogv")
const launch = preload("res://scavenger-hunt/assets/launch/launch.ogv")

var direction
var valid

func _ready() -> void:
	$Meter/LineArea.position.y = 20
	$VideoStreamPlayer.stream = prelaunch
	$VideoStreamPlayer.play()
	$VideoStreamPlayer.loop = true
	direction = "down"

func _process(delta: float) -> void:
	if (direction == "down"):
		if ($Meter/LineArea.position.y >= 0):
			$Meter/LineArea.position.y += 10
		if ($Meter/LineArea.position.y >= 810):
			direction = "up"
	if (direction == "up"):
		if ($Meter/LineArea.position.y <= 810):
			$Meter/LineArea.position.y -= 10
		if ($Meter/LineArea.position.y == 0):
			direction = "down"
	if Input.is_action_pressed("ui_accept"):
		if valid:
			$Meter.hide()
			await get_tree().create_timer(1.0).timeout
			$VideoStreamPlayer.stream = launch
			$VideoStreamPlayer.play()
			$VideoStreamPlayer.loop = false

func _on_video_stream_player_finished() -> void:
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://meteoroid-level/scenes/start_screen.tscn")


func _on_red_area_area_entered(area: Area2D) -> void:
	valid = false


func _on_green_area_area_entered(area: Area2D) -> void:
	valid = true
