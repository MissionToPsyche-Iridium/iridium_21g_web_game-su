extends Control

var text = [
		"Hello!",
		"My name is Kuiper (pronounced like KY-per) and I need your help!",
		"I am a part of the NASA-ASU Team.",
		"For the first time ever, we are exploring a world made not of rock or ice, but of metal.",
		"Most asteroids are made of a combination of rock and ice except this one.",
		"This metal-rich asteroid is named Psyche (pronounced like SY-kee).",
		"I need your help to get me to the control room to launch the spacecraft!",
		"I'll need your help on the computer carrying out parts of the mission!",
		"Let's go!"
		]
@onready var label := $Story/Label
const base_speed := 20
var started := true
var finished := false
var count := 0.0
var covered = true
var start = false
var ending := false

var volume = -35

func _ready() -> void:
	Audio.play_music_rooms(volume)
	$Cover.color = Color(0,0,0)
	$PromptCover.color = Color(0,0,0)
	$Cover.show()
	$PromptCover.show()
	$Ready.hide()
	await get_tree().create_timer(1.0).timeout
	$AnimationPlayer.play("cover_fade")
	await get_tree().create_timer(1.0).timeout
	$Cover.hide()
	start = true

func _process(delta: float) -> void:
	if (start):
		if(label.get_visible_ratio() != 1.0):
			if(count < 1):
				count += base_speed*delta
			else:
				label.set_visible_characters(label.get_visible_characters()+1)
				if (label.get_visible_characters() % 2 == 0):
					$Audio/sfx_dialogue.play()
				count -= 1
		else:
			if (covered):
				covered = false
				$AnimationPlayer.play("prompt_cover_fade")
		if(started):
			changeText()
			started = false

func changeText():
	if text.size() > 0:
		label.set_visible_ratio(0.0)
		label.text = text.pop_front()
		if label.text == "Most asteroids are made of a combination of rock and ice except this one.":
			$AnimationPlayer2.play("psyche_cover_fade")
		if label.text == "I need your help to get me to the control room to launch the spacecraft!":
			$AnimationPlayer2.play("psyche_cover")
	else: 
		finished = true

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		if !finished:
			covered = true
			$AnimationPlayer.play("prompt_cover")
			if(label.get_visible_ratio() == 1.0):
				changeText()
		if finished && !ending:
			ending = true
			Audio.volume_db += 5
			$Cover.show()
			await get_tree().create_timer(0.2).timeout
			$AnimationPlayer.play("cover")
			await get_tree().create_timer(1.1).timeout
			$Story.hide()
			$Player.hide()
			$Prompt.hide()
			$Psyche1.hide()
			Audio.volume_db += 5
			get_tree().change_scene_to_file("res://scavenger-hunt/scenes/world.tscn")
	if event.is_action_pressed("interact"):
		while text.size() != 0:
			covered = true
			$AnimationPlayer.play("prompt_cover")
			if(label.get_visible_ratio() == 1.0):
				changeText()
			else:
				label.set_visible_ratio(1.0)

#func _on_ready_pressed() -> void:
	
