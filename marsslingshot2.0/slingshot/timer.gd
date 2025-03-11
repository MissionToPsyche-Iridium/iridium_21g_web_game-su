extends Timer

var count = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	use_boost()


func use_boost():
	if Input.is_action_just_pressed("ui_up"):
		start()
		print(time_left)
	else:
		stop()
