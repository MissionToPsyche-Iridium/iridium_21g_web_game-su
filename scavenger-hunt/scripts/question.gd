extends Control

signal option1
signal option2
signal option3

var open := false

func _process(delta: float) -> void:
	check()

func check():
	if visible:
		open = true
	else:
		open = false

func _on_option_1_pressed() -> void:
	option1.emit()

func _on_option_2_pressed() -> void:
	option2.emit()

func _on_option_3_pressed() -> void:
	option3.emit()
