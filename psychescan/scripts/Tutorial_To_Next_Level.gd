extends Area2D

@export var new_scene_path: String = "res://psychescan/levels/level.tscn"
var correctSound 


func _ready():
	monitoring = true
	correctSound = get_parent().get_node("CorrectSound")
	#print("Scene tree initialized:", get_tree())
	'''
	print(get_parent().name)
	var parent = get_parent()
	if parent:
		print("Parent node:", parent.name)  # Should print 'background'
		
		# Try to get CorrectSound
		correctSound = parent.get_node_or_null("CorrectSound")
		
		if correctSound:
			print("CorrectSound found!")
		else:
			print("CorrectSound does NOT exist at _ready()!")
	else:
		print("Error: Parent node not found!")
	'''
	#correctSound = get_parent().get_node("CorrectSound")
	#correctSound = $"CorrectSound"


func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		var tree = get_tree()
		correctSound.play()
		await correctSound.finished
		tree.change_scene_to_file(new_scene_path)

'''
func _on_correct_sound_finished():
	# Change scene ONLY after sound finishes
	get_tree().change_scene_to_file(new_scene_path)
'''
"""
E 0:00:01:0231   Tutorial_To_Next_Level.gd:10 @ _process(): Node not found: "background/CorrectSound" (relative to "/root/MainLevel/TutorialStart/background/hitbox1").
  <C++ Error>    Method/function failed. Returning: nullptr
  <C++ Source>   scene/main/node.cpp:1793 @ get_node()
  <Stack Trace>  Tutorial_To_Next_Level.gd:10 @ _process()

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
