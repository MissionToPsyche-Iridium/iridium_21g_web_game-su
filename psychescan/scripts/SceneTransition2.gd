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
var is_scene_change_pending = false  # Tracks whether the scene change is pending


func _ready():
	monitoring = true
	correctNode = get_parent().get_node("Correct")
	incorrectNode = get_parent().get_node("Incorrect")
	correctNode.visible = false
	incorrectNode.visible = false

func _on_area2d_body_entered(body):
	if body is CharacterBody2D: # Optional: Use groups for organization
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
			scanned_boxes.append(overlapping_box)
			valid_scan_count += 1
			is_overlap = false
			show_correct_only()
			
			if valid_scan_count == 2:
				print("all boxes successsfully scanned. Transitioning...")
				is_scene_change_pending = true
				show_correct_indicator()
				#change_scene()
			else:
				print("Already scanned")
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
		


func find_collision_box(player: CharacterBody2D) -> CollisionShape2D:
	for child in player.get_children():
		if child is CollisionShape2D and not has_been_scanned(child):
			return child
	return null		
		
func has_been_scanned(box: CollisionShape2D) -> bool:
	return box in scanned_boxes

func show_correct_indicator():
	correctNode.visible = true
	await(get_tree().create_timer(2.0).timeout)  # Wait for 2 seconds
	correctNode.visible = false
	print("Hiding Correct indicator")
	if is_scene_change_pending:
		change_scene()

func show_correct_only():
	correctNode.visible = true
	await(get_tree().create_timer(2.0).timeout)  # Wait for 2 seconds
	correctNode.visible = false
	print("Hiding Correct indicator")

# Show incorrect indicator for a specified duration
func show_incorrect_indicator():
	incorrectNode.visible = true
	await(get_tree().create_timer(2.0).timeout)  # Wait for 2 seconds
	incorrectNode.visible = false
	print("Hiding Incorrect indicator")