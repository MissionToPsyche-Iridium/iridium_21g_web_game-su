extends Node2D

signal crash

func _on_area_2d_2_body_entered(body: Node2D) -> void:
	crash.emit()
