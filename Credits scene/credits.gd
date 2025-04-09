extends Node2D

const section_time := 2.0
const line_time := 0.3
const base_speed := 100
const speed_up_multiplier := 10.0
const title_color := Color.BLUE_VIOLET

var scroll_speed := base_speed
var speed_up = false

@onready var line := $CreditsContainer/Label
var started := false
var finished := false

var section
var section_next := true
var section_timer := 0.0
var line_timer := 0.0
var curr_line := 0
var lines := []

var credits = [
	[
		"Credits",
		"A game by Us"
	],[
		"Programmers",
		"Kevin Bui",
		"Colin Curry",
		"Hanjin Jacobs",
		"Grace Lane",
		"Lyle Vitales",
	],[
		"Artists",
		"Adapted by Grace Lane from LimeZu (https://limezu.itch.io/)",
		"Grace Lane",
		"Kevin Bui",
	],[
		"Music",
		"https://haberchuck.itch.io/pc-98-visual-novel-bgm-pack",
	],[
		"Sound Effects",
		"https://dryoma.itch.io/footsteps-sounds",
		"https://liminal-space-dev.itch.io/free-horror-sfx-sounds",
	],[
		"Tools",
		"Developed with Godot Engine https://godotengine.org/license",
		"Procreate",
		"Microsoft Paint"
	],[
		"Special thanks",
		"Dr. Nate Kremer-Herman, PhD",
		"Dr. Cassie Bowman, Ed.D",
	],[
		"Beta Testers",
		"Mason Welch",
	],[
		"Disclaimer",
		"This work was created in partial fulfillment of Seattle ",
		"University Capstone Program. The work is a result ",
		"of the Psyche Student Collaborations component of NASA's ",
		"Psyche Mission (https://psyche.asu.edu). 'Psyche: A Journey to ",
		"a Metal World'[Contract number NNM16AA09C] is part of the ",
		"NASA Discovery Program mission to solar system targets.",
		"Trade names and trademarks of ASU and NASA are used in this",
		"work for identification only. Their usage does not constitute",
		"an official endorsement, either expressed or implied, by",
		"Arizona State University or National Aeronautics and Space",
		"Administration. The content is solely the responsibility of",
		"the authors and does not necessarily represent the official",
		"views of ASU or NASA."
	],
]


func _process(delta):
	var scroll_speed = base_speed * delta
	
	if section_next:
		section_timer += delta * speed_up_multiplier if speed_up else delta
		if section_timer >= section_time:
			section_timer -= section_time
			
			if credits.size() > 0:
				started = true
				section = credits.pop_front()
				curr_line = 0
				add_line()
	
	else:
		line_timer += delta * speed_up_multiplier if speed_up else delta
		if line_timer >= line_time:
			line_timer -= line_time
			add_line()
	
	if speed_up:
		scroll_speed *= speed_up_multiplier
	
	if lines.size() > 0:
		for l in lines:
			l.global_position.y -= scroll_speed
			if l.global_position.y < -l.get_line_height():
				lines.erase(l)
				l.queue_free()
	elif started:
		finish()


func finish():
	if not finished:
		# NOTE: This is called when the credits finish scrolling
		finished = true
		get_tree().change_scene_to_file("res://start_menu/start_menu.tscn")


func add_line():
	var new_line = line.duplicate()
	new_line.text = section.pop_front()
	lines.append(new_line)
	if curr_line == 0:
		new_line.set("theme_override_colors/font_color",title_color)
	$CreditsContainer.add_child(new_line)
	
	if section.size() > 0:
		curr_line += 1
		section_next = false
	else:
		section_next = true


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		finish()
	if event.is_action_pressed("ui_down") and !event.is_echo():
		speed_up = true
	if event.is_action_released("ui_down") and !event.is_echo():
		speed_up = false
