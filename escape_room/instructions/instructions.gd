extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$RichTextLabel.text = "[center]Use the arrow keys to move the character around. Look for hints to answer the questions of the person in each room. Answer the question to progress."


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scavenger-hunt/room1/room1.tscn")
