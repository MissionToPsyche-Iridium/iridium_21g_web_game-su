extends Control

const prelaunch = preload("res://scavenger-hunt/assets/launch/prelaunch.ogv")
const launch = preload("res://scavenger-hunt/assets/launch/launch.ogv")

var direction
var valid

var top_text = [
		"Greetings Kuiper",
		"Your first task is to launch the SpaceX Falcon Heavy rocket",
		"Controls:\n[Enter]\n[Space]",
		]
@onready var top_label := $Instructions/Top
var top_started := true
var top_finished := false
var top_start = false

var bottom_text = [
		"Launch the rocket when the black line is in the green area",
		]
@onready var bottom_label := $Instructions/Bottom
var bottom_started := true
var bottom_finished := false
var bottom_start = false

const base_speed := 20
var count := 0.0

var input_allowed := false

var auto_advance_timer := 0.0
const AUTO_ADVANCE_DELAY := 2.0  # Seconds to wait after line fully shown

func _ready() -> void:
	$Meter/LineArea.position.y = 20
	$VideoStreamPlayer.stream = prelaunch
	$VideoStreamPlayer.play()
	$VideoStreamPlayer.loop = true
	direction = "down"
	top_start = true


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
	if Input.is_action_just_pressed("ui_accept") and input_allowed:
		if valid:
			top_label.set_visible_characters(0)
			top_label.text = "Well done"
			top_label.set_visible_ratio(0.0)
			top_started = true
			$Instructions/Bottom.hide()
			$Meter.hide()
			await get_tree().create_timer(2.0).timeout
			$VideoStreamPlayer.stream = launch
			$VideoStreamPlayer.play()
			$VideoStreamPlayer.loop = false
		else:
			$AnimationPlayer.play("flash_wrong")


	if (top_start):
		if top_label.get_visible_ratio() != 1.0:
			if count < 1:
				count += base_speed * delta
			else:
				top_label.set_visible_characters(top_label.get_visible_characters() + 1)
				count -= 1
			auto_advance_timer = 0.0  # Reset if it's still typing
		else:
			auto_advance_timer += delta
			if auto_advance_timer > AUTO_ADVANCE_DELAY and not top_finished:
				changeText()
				auto_advance_timer = 0.0
			if top_finished:
				bottom_start = true     # Allow input only when dialogue is done
		if top_started:
			changeText()
			top_started = false
	
	if (bottom_start):
		if bottom_label.get_visible_ratio() != 1.0:
			if count < 1:
				count += base_speed * delta
			else:
				bottom_label.set_visible_characters(bottom_label.get_visible_characters() + 1)
				count -= 1
			auto_advance_timer = 0.0  # Reset if it's still typing
		else:
			auto_advance_timer += delta
			if auto_advance_timer > AUTO_ADVANCE_DELAY and not bottom_finished:
				changeText()
				auto_advance_timer = 0.0
			if bottom_finished:
				input_allowed = true
		if bottom_started:
			changeText()
			bottom_started = false


func changeText():
	if top_text.size() > 0:
		top_label.set_visible_ratio(0.0)
		top_label.text = top_text.pop_front()
	else: 
		top_finished = true
		
	if bottom_text.size() > 0:
		bottom_label.set_visible_ratio(0.0)
		bottom_label.text = bottom_text.pop_front()
	else: 
		await get_tree().create_timer(0.5).timeout
		bottom_finished = true


func _on_video_stream_player_finished() -> void:
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://meteoroid-level/scenes/start_screen.tscn")


func _on_red_area_area_entered(area: Area2D) -> void:
	valid = false


func _on_green_area_area_entered(area: Area2D) -> void:
	valid = true
