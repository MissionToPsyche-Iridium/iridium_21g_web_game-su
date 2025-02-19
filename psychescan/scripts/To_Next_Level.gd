extends Area2D

@export var new_scene_path: String = "res://Finished Screen/Scene.tscn" # CHANGE TO NEXT LEVEL NAME HERE

func _ready():
	monitoring = true

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file(new_scene_path)

"""
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
"""
