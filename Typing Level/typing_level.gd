extends Node2D

const scrollSpeed = 100

@export var text: PackedScene
var texts = null
var blocks = []
var startPos
var lineTimer = 0
var lineTime = 0
var textBox = false
var state = 0
var nextLeter = 0
var label
var animationPlayer
var playing = false
const lineSpeed = 100


var rightTextBlocks = [
	"The Psyche sattellite will send out words. Hit [Enter] to continue",
	" To complete this section, type the words to analyze what they are.",
	"The sattellite will continue to send out information until all information has been recieved."
]


#[name, delay, text
var textBlocks = [
	["Psyche", 4.5, "A unique metal asteroid which provides a window into the formation of planetary cores."],
	["Multispectral Imager", 5, "The Multispectral Imager provides high-resolution images using filters to discriminate between Psyche’s metallic and silicate constituents."],
	["Spectrometer", 5, "The Spectrometer will detect, measure, and map Psyche’s elemental composition."],
	["Magnetometer", 5, "The Magnetometer is designed to detect and measure the remanent magnetic field of the asteroid."],
	["Asteriods", 5, "some text you see"],
	["bananaf", 5, "some text"],
	["bananag", 5, "some text"],
	["bananah", 5, "some text"]
]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	startPos = $Node2D.position
	label = $Node2D2/Label
	animationPlayer = $Node2D2/AnimationPlayer
	label.text = rightTextBlocks.pop_front()
	label.visible_ratio = 0
	return
	texts = text.instantiate(0)
	add_child(texts)
	texts.setPos(startPos)
	texts.setText("banana")
	blocks.append(texts)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == 0:
		cycleText(delta)
		return
	if state == 1:
		if not playing:
			animationPlayer.play("Start Cutscene")
			playing = true
			
		return
	if textBox:
		
		pass#simply exists as a check
	else:
		lineTimer += delta
		#if lineTimer >= lineTime:
		if blocks.size() == 0 && textBlocks.size() != 0:
			#lineTimer -= lineTime
			addBlock()
		elif blocks.size() > 0:
			if blocks.back().global_position.x + blocks.back().rightPoint() + 50 < startPos.x:
				addBlock()
			for i in blocks:
				i.move(-lineSpeed*delta)
				i.checkFail(delta)
				if i.global_position.x  < -i.rightPoint():
					if not i.completed():
						textBlocks.append(i.getInfo())
					blocks.erase(i)
					i.free()
		elif textBlocks.size() == 0:
			get_tree().change_scene_to_file("res://start_menu/start_menu.tscn")

#adds a block to the blocks list
func addBlock():
	if textBlocks.size() == 0:
		return
	var popValues = textBlocks.pop_front()
	var newText = text.instantiate(0)
	$Node2D2/Node2D.add_child(newText)
	#newText.setPos(startPos)
	newText.setText(popValues[0])
	newText.setInformation(popValues)
	lineTime = popValues[1]
	blocks.append(newText)

func _unhandled_input(event):
	if state == 0:
		if event.is_action_pressed("ui_accept"):
			if label.visible_ratio < 1:
				return
			if rightTextBlocks.size() > 0:
				label.visible_ratio = 0
				nextLeter = 0
				label.text = rightTextBlocks.pop_front()
			else:
				state+=1
		return
	if textBox:
		return
	if event is InputEventKey and not event.is_pressed():
		for i in blocks:
			i.typeChecking(event)
			if i.checkDone():
				$Control/Label.text = i.getInfo()[2]
				$Control.visible = true
				textBox = true


func _on_button_button_up() -> void:
	$Control.visible = false
	textBox = false
	pass # Replace with function body.

func cycleText(delta):
	if label.visible_ratio < 1:
		nextLeter += delta*30
		label.visible_characters = nextLeter
		

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	state = 2
	pass # Replace with function body.
