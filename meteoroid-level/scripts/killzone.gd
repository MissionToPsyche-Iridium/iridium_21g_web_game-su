# Killzone script to detect collision

extends Area2D

@onready var timer: Timer = $Timer


func _on_body_entered(_body: Node2D) -> void:
	timer.start()
	var color_screen = get_tree().current_scene.get_node("ColorRect")
	var lose_sound = get_tree().current_scene.get_node("LoseSound")
	color_screen.color = Color8(255, 0, 0, 0)
	lose_sound.play()
	
	_body.queue_free()
	
	var tween = create_tween()
	tween.tween_property(color_screen, "color", Color8(255, 0, 0, 100), 2.0)
	await tween.finished

func _on_timer_timeout() -> void:
	get_tree().call_deferred("reload_current_scene") # Reloads scene upon hitting zone
