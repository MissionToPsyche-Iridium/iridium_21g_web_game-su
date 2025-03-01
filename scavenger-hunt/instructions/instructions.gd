extends Node2D

var text = [
		"Hello!",
		"My name is Kuiper and I need your help!",
		"I am a part of the NASA-ASU Team.",
		"For the first time ever, we are exploring a world made not of rock or ice, but of metal.",
		"This metal-rich asteroid is named Psyche.",
		"I need your help to get me to the control room to launch the spacecraft!",
		"Use WASD or arrow keys to move me around.", 
		"Look for hints by walking up to things. If you can interact with it, a message will appear prompting you to hit the [E] key.",
		"Please help me answer the question in each room so we can get to the control room!",
		"After we get to the control room, I'll need your help on the computer carrying out parts of the mission!",
		"Are you ready?"
		]
@onready var label := $Story/Label
const base_speed := 20
var started := true
var finished := false
var count := 0.0
var covered = true
var start = false

func _ready() -> void:
	#$Prompt.hide()
	$Cover.color = Color(0,0,0)
	$PromptCover.color = Color(0,0,0)
	$Cover.show()
	$PromptCover.show()
	$Player.play("idle")
	$Ready.hide()
	await get_tree().create_timer(1.0).timeout
	$AnimationPlayer.play("cover_fade")
	await get_tree().create_timer(1.0).timeout
	$Cover.hide()
	start = true
	#$Player.play("default")
	#label.add_theme_color_override("font_color", Color("White"))

func _process(delta: float) -> void:
	if (start):
		#var typing_speed = base_speed * delta
		if(label.get_visible_ratio() != 1.0):
			if(count < 1):
				count += base_speed*delta
			else:
				label.set_visible_characters(label.get_visible_characters()+1)
				count -= 1
		else:
			if (covered):
				covered = false
				$AnimationPlayer.play("prompt_cover_fade")
		if(started):
			changeText()
			started = false
		if (finished):
			$Prompt.hide()
			covered = false
			$Ready.show()

func changeText():
	if text.size() > 0:
		label.set_visible_ratio(0.0)
		label.text = text.pop_front()
	else: 
		finished = true

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		covered = true
		$AnimationPlayer.play("prompt_cover")
		if(label.get_visible_ratio() == 1.0):
			changeText()
		else:
			label.set_visible_ratio(1.0)

func _on_ready_pressed() -> void:
	get_tree().change_scene_to_file("res://scavenger-hunt/world.tscn")
