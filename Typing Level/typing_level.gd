extends Node2D

const scrollSpeed = 200

@export var text: PackedScene
var texts = null
var blocks = []
var startPos
var lineTimer = 0
var lineTime = 0
var textBox = false
const lineSpeed = 500
#[name, delay, text
var textBlocks = [
	["banana", .9, "some text idk what to say here you see"],
	["bananab", 1, "some text ove here"],
	["bananac", 1, "some text idk"],
	["bananad", 1, "some text well"],
	["bananae", 1, "some text you see"],
	["bananaf", 1, "some text"],
	["bananag", 1, "some text"],
	["bananah", 1, "some text"]
]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	startPos = $Node2D.position
	return
	texts = text.instantiate(0)
	add_child(texts)
	texts.setPos(startPos)
	texts.setText("banana")
	blocks.append(texts)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if textBox:
		pass#simply exists as a check
	else:
		lineTimer += delta
		if lineTimer >= lineTime:
			lineTimer -= lineTime
			addBlock()
		if blocks.size() > 0:
			for i in blocks:
				i.move(-lineSpeed*delta)
				i.checkFail(delta)
				if i.global_position.x < i.rightPoint():
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
	add_child(newText)
	newText.setPos(startPos)
	newText.setText(popValues[0])
	newText.setInformation(popValues)
	lineTime = popValues[1]
	blocks.append(newText)

func _unhandled_input(event):
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
