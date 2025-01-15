extends Area2D
signal win
	

func _on_body_entered(body: Node2D) -> void:
	win.emit()
	get_tree().change_scene_to_file("res://maze/end_scene/end_scene.tscn")
