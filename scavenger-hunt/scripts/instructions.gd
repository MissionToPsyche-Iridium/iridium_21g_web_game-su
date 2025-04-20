extends Node2D

var text = [
		"Hello!",
		"My name is Kuiper and I need your help!",
		"I am a part of the NASA-ASU Team.",
		"For the first time ever, we are exploring a world made not of rock or ice, but of metal.",
		"This metal-rich asteroid is named Psyche.",
		"I need your help to get me to the control room to launch the spacecraft!",
		"I'll need your help on the computer carrying out parts of the mission!",
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
	Audio.play_music_rooms(-25)
	#$Prompt.hide()
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
	if event.is_action_pressed("interact"):
		while text.size() != 0:
			covered = true
			$AnimationPlayer.play("prompt_cover")
			if(label.get_visible_ratio() == 1.0):
				changeText()
			else:
				label.set_visible_ratio(1.0)

func _on_ready_pressed() -> void:
	Audio.volume_db = -23
	$Cover.show()
	await get_tree().create_timer(0.2).timeout
	$AnimationPlayer.play("cover")
	await get_tree().create_timer(1.2).timeout
	Audio.volume_db = -20
	get_tree().change_scene_to_file("res://scavenger-hunt/scenes/world.tscn")
