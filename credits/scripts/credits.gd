extends CanvasLayer

signal done
var from_start_menu := false

var going := true
var wait_time = 1.0

const section_time := 0.0
const line_time := 0.0
const base_speed := 150
const speed_up_multiplier := 10.0

var title_color = Color.html("#f9a000")

var scroll_speed := base_speed
var speed_up = false

@onready var line := $CreditsContainer/Label
var started := false

var section
var section_next := true
var section_timer := 0.0
var line_timer := 0.0
var curr_line := 0
var lines := []

var credits = [
	[
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
	],[
		"Programmers",
		"Grace Lane",
		"Kevin Bui",
		"Hanjin Jacobs",
		"Colin Curry",
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
		"Beta Testers",
		"Mason Welch",
		"Oliver - Kobe - Ryder - Jaxson",
		"Abram - Harper - Hunter - Oliver",
		"Hazel - Ben - Brendan - Emma - Ari",
		"Clyde - Halle - Harper - Yeji - Hazel",
		"Michael - Hannah - Yian - Whitney",
		"Makenna - Saylor - Fiona - Elliot",
		"Wyatt - Charlie - Lucas - Anton - Leila",
		"Luca - Taylor - Mia - Elliot - Ben",
		"Christopher - Abigail - Kailine",
		"Christian",
	],[
		"Special Thanks To",
		"Dr. Nate Kremer-Herman, PhD",
		"Dr. Cassie Bowman, Ed.D",
	],
]

func _ready() -> void:
	Globals.get_node("Hint").hide()

func _process(delta):
	if going:
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
	going = false
	started = false
	thank_you()

func thank_you():
	$AnimationPlayer.play("fade_in")
	await get_tree().create_timer(wait_time).timeout
	done.emit()

func add_line():
	var new_line = line.duplicate()
	new_line.text = section.pop_front()
	
	if curr_line == 0:
		new_line.set("theme_override_colors/font_color", title_color)

	$CreditsContainer.add_child(new_line)

	# Set initial position based on last line
	var y_offset = 0
	if lines.size() > 0:
		var last_line = lines[lines.size() - 1]
		
		# GDScript-style ternary operator
		var extra_spacing = 150 if curr_line == 0 else 50
		y_offset = last_line.global_position.y + last_line.get_line_height() + extra_spacing
	else:
		# Start offscreen at bottom
		y_offset = get_viewport().get_visible_rect().size.y

	var screen_center_x = get_viewport().get_visible_rect().size.x / 2
	new_line.global_position = Vector2(screen_center_x - new_line.size.x / 2, y_offset)

	lines.append(new_line)

	if section.size() > 0:
		curr_line += 1
		section_next = false
	else:
		section_next = true
