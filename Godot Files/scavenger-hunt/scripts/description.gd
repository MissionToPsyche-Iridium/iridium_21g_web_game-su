extends Control

var open := false

func _process(delta: float) -> void:
	check()

func check():
	if visible:
		open = true
	else:
		open = false
