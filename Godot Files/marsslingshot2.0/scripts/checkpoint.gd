extends Area2D

signal win

func _on_body_entered(body: Node2D) -> void:
	win.emit()
