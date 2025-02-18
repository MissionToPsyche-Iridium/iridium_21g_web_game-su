extends AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var timer = get_node("Timer")
	timer.start()

#func _process(delta: float) -> void:
	
func _on_timer_timeout() -> void:
	play("sparkle")
	await get_tree().create_timer(1.0).timeout  # Wait while animation plays
	stop()
	$Timer.start()
