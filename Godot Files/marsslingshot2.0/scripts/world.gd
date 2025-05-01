extends Node2D



var base_speed := 20
var count := 0.0
var auto_advance_timer := 0.0
var auto_advance_delay := 2.0  # Seconds to wait after line fully shown
var top_text = [
		"Complete a Mars gravity assist to save fuel on the way to Psyche",
		"Controls:\n[WASD]\n[Arrows]",
		]
var outside_text = [
		"Oh no! You went too far out of range! Try again.",
		]
var crash_text = [
		"Oh no! Mar's gravity was too strong! Try again.",
		]
@onready var top_label := $Instructions/Top
var top_started := true
var top_finished := false
var top_start = false
var bottom_text = [
		"Get ready!",
		]
@onready var bottom_label := $Instructions/Bottom
var bottom_started := true
var bottom_finished := false
var bottom_start = false

var outside := false
var crash := false

var end := false

var open := false

func _ready() -> void:
	Globals.hint_open.connect(_on_hint_open)
	Globals.hint_close.connect(_on_hint_close)
	top_start = true
	$space_ship.movement_allowed = false

func _on_hint_open():
	open = true
	$space_ship.movement_allowed = false

func _on_hint_close():
	open = false
	$space_ship.movement_allowed = true
	
func _process(delta: float) -> void:
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
			if auto_advance_timer > auto_advance_delay and not top_finished:
				changeText()
				auto_advance_timer = 0.0
			if top_finished:
				if outside:
					outside = false
					crash = false
					reset()
				elif crash:
					outside = false
					crash = false
					reset()
				elif end:
					next_game()
				top_start = false
				bottom_start = true
		if top_started:
			changeText()
			top_started = false
	
	if (bottom_start) and !end:
		if bottom_label.get_visible_ratio() != 1.0:
			if count < 1:
				count += base_speed * delta
			else:
				bottom_label.set_visible_characters(bottom_label.get_visible_characters() + 1)
				count -= 1
			auto_advance_timer = 0.0  # Reset if it's still typing
		else:
			auto_advance_timer += delta
			if auto_advance_timer > auto_advance_delay and not bottom_finished:
				changeText()
				auto_advance_timer = 0.0
			if bottom_finished:
				bottom_start = false
				bottom_done()
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

func bottom_done():
	await get_tree().create_timer(2.0).timeout
	bottom_label.hide()
	end_dialogue()

func end_dialogue():
	await get_tree().create_timer(2.0).timeout
	if !open:
		$space_ship.movement_allowed = true

func _on_game_area_body_exited(body: Node2D) -> void:
	if !crash and !end:
		$space_ship.hide()
		$space_ship.movement_allowed = false
		outside = true
		top_label.set_visible_characters(0)
		top_label.text = "Oh no! You went too far out of range! Try again."
		top_label.set_visible_ratio(0.0)
		top_start = true
		top_started = true
	
func reset():
	$space_ship.movement_allowed = false
	outside = false
	crash = false
	await get_tree().create_timer(2.0).timeout
	$space_ship.rotation = 0
	$space_ship.show()
	$space_ship.position = Vector2(76,479)
	$space_ship.velocity = Vector2(0,0)
	top_label.set_visible_characters(0)
	top_label.text = "Controls:\n[WASD]\n[Arrows]"
	top_label.set_visible_ratio(0.0)
	top_start = true
	top_started = true
	bottom_label.text = "Get ready!"
	bottom_label.show()
	

func _on_mars_crash() -> void:
	$space_ship.hide()
	$space_ship.movement_allowed = false
	crash = true
	top_label.set_visible_characters(0)
	top_label.text = "Oh no! Mar's gravity was too strong! Try again."
	top_label.set_visible_ratio(0.0)
	top_start = true
	top_started = true


func _on_checkpoint_win() -> void:
	$space_ship.hide()
	$space_ship.movement_allowed = false
	end = true
	top_label.set_visible_characters(0)
	top_label.text = "Well done!"
	top_label.set_visible_ratio(0.0)
	top_start = true
	top_started = true
	
func next_game():
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://psychescan/levels/tutorialLevel.tscn")
	
