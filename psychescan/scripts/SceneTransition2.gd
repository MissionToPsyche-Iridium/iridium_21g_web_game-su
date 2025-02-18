extends Area2D

@export var new_scene_path: String = "res://psychescan/levels/level3.tscn"
# Tracks the player object currently in the area
var is_overlap = false
var player_node: CharacterBody2D = null
var overlapping_box: CollisionShape2D = null
var valid_scan_count: int = 0
var scanned_boxes := []  # List to keep track of scanned boxes
var correctNode
var incorrectNode
var is_scene_change_pending = false 
var correctSound
var incorrectSound

func _ready():
	monitoring = true
	correctNode = get_parent().get_node("Correct")
	incorrectNode = get_parent().get_node("Incorrect")
	correctNode.visible = false
	incorrectNode.visible = false
	correctSound = get_parent().get_node("CorrectSound")
	incorrectSound = get_parent().get_node("IncorrectSound")

# Signals for collision detection required for switching scenes at the proper events
func _on_area2d_body_entered(body):
	if body is CharacterBody2D:
		player_node = body
		overlapping_box = find_collision_box(body)
		if overlapping_box:
			is_overlap = true
			
			print("Player entered area")

func _on_area2d_body_exited(body):
	if body == player_node:
		player_node = null
		is_overlap = false
		overlapping_box = null
		print("Player exited area")

func _process(delta):
	if is_overlap and Input.is_action_just_pressed("ui_accept"):
		if overlapping_box and not has_been_scanned(overlapping_box):
			print("Input accepted")
			scanned_boxes.append(overlapping_box) # Scanned boxes are added to list so player cannot use them again
			valid_scan_count += 1
			is_overlap = false
			show_correct_only()
			correctSound.play()
			await correctSound.finished
			
			if valid_scan_count == 2:
				# When player has scanned all target areas
				print("all boxes successsfully scanned. Transitioning...")
				is_scene_change_pending = true
				show_correct_indicator() 
			


		elif overlapping_box and has_been_scanned(overlapping_box):
			print("Already scanned")
			show_incorrect_indicator()
			incorrectSound.play()
			await incorrectSound.finished
	elif not is_overlap and Input.is_action_just_pressed("ui_accept"):
		print("target misaligned")
		show_incorrect_indicator()
		incorrectSound.play()
		await incorrectSound.finished

func change_scene():
	var tree = get_tree()
	print("Transition from: " + get_tree().current_scene.name)

	if new_scene_path.length() == 0:
		print("Error: no scene path specified")
		return
		
	var result = tree.change_scene_to_file(new_scene_path)
	if result == OK:
		print("Transition success")
	else:
		print("Transition failure")

# Tracks the target area that the player is currently overlapping when multiple targets are present		
func find_collision_box(player: CharacterBody2D) -> CollisionShape2D:
	for child in player.get_children():
		if child is CollisionShape2D and not has_been_scanned(child):
			return child
	return null		
		
func has_been_scanned(box: CollisionShape2D) -> bool:
	return box in scanned_boxes

# Displays an indicator for 2 seconds for a correct or incorrect scan
func show_correct_indicator():
	correctNode.visible = true
	await(get_tree().create_timer(2.0).timeout)  # Wait for 2 seconds
	correctNode.visible = false
	print("Hiding Correct indicator")
	if is_scene_change_pending:
		change_scene() # Scene is changed here because scene would change too fast to display the indicator if used in _process.

# Display correct indicator without changing scene
func show_correct_only():
	correctNode.visible = true
	await(get_tree().create_timer(2.0).timeout)
	correctNode.visible = false
	print("Hiding Correct indicator")

func show_incorrect_indicator():
	incorrectNode.visible = true
	await(get_tree().create_timer(2.0).timeout)  
	incorrectNode.visible = false
	print("Hiding Incorrect indicator")
