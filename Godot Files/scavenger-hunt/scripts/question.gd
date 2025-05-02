extends Control

signal option1
signal option2
signal option3

var open := false

func _process(delta: float) -> void:
	if visible:         # If the question popup is visible, set open to true
		open = true
	else:
		open = false

# Option selection handling
func _on_option_1_pressed() -> void:
	option1.emit()

func _on_option_2_pressed() -> void:
	option2.emit()

func _on_option_3_pressed() -> void:
	option3.emit()
