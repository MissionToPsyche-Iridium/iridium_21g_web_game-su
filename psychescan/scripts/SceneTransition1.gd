extends Area2D

@export var new_scene_path: String = "res://psychescan/levels/level2.tscn"
#@export var new_scene_path: String

# Tracks the player object currently in the area
var is_overlap = false # Used to track if player is aligned with the correct area
var player_node: CharacterBody2D = null
var correctNode
var incorrectNode
var is_scene_change_pending = false

func _ready():
	monitoring = true
	correctNode = get_parent().get_node("Correct")
	incorrectNode = get_parent().get_node("Incorrect")
	correctNode.visible = false
	incorrectNode.visible = false

# Signals for collision detection
func _on_area2d_body_entered(body):
	if body is CharacterBody2D: 
		player_node = body
		is_overlap = true
		print("Player entered area")

func _on_area2d_body_exited(body):
	if body == player_node:
		player_node = null
		is_overlap = false
		print("Player exited area")

func _process(delta):
	if is_overlap and Input.is_action_just_pressed("ui_accept"): # If the player is aligned with the target area and presses enter
		print("Input accepted")
		is_overlap = false
		is_scene_change_pending = true
		show_correct_indicator()
	elif not is_overlap and Input.is_action_just_pressed("ui_accept"):
		print("target misaligned")
		show_incorrect_indicator()


func change_scene():
	print("Transition from: " + get_tree().current_scene.name)
	if new_scene_path.length() == 0:
		print("Error: no scene path specified")
		return
		
	var result = get_tree().change_scene_to_file(new_scene_path)
	if result == OK:
		print("Transition success")
	else:
		print("Transition failure") 


# Displays an indicator for 2 seconds for a correct or incorrect scan
func show_correct_indicator():
	correctNode.visible = true
	await(get_tree().create_timer(2.0).timeout)  # Wait for 2 seconds
	correctNode.visible = false
	print("Hiding Correct indicator")
	if is_scene_change_pending:
		change_scene() # Scene is changed here because scene would change too fast to display the indicator if used in _process.

func show_incorrect_indicator():
	incorrectNode.visible = true
	await(get_tree().create_timer(2.0).timeout)
	incorrectNode.visible = false
	print("Hiding Incorrect indicator")