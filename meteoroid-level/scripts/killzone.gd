# Killzone script to detect collision

extends Area2D


func _on_body_entered(_body: Node2D) -> void:
	get_tree().call_deferred("reload_current_scene") # Reloads scene upon hitting zone
