extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Button.hide()
	$AnimationPlayer.play("cover_fade")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	await get_tree().create_timer(8.2).timeout
	$Button.show()


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scavenger-hunt/room1/room1.tscn")
