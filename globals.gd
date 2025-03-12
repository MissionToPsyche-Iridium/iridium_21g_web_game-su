extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("1"):
		get_tree().change_scene_to_file("res://scavenger-hunt/world.tscn")
	if Input.is_action_pressed("2"):
		get_tree().change_scene_to_file("res://meteoroid-level/scenes/level_1_screen.tscn")
	if Input.is_action_pressed("3"):
		get_tree().change_scene_to_file("res://marsslingshot2.0/slingshot/world.tscn")
	if Input.is_action_pressed("4"):
		get_tree().change_scene_to_file("res://psychescan/levels/main_level.tscn")
	if Input.is_action_pressed("5"):
		get_tree().change_scene_to_file("res://Finished Screen/Scene.tscn")
