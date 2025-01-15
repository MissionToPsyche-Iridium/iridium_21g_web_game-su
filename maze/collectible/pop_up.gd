extends Control
signal close


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()



func _on_button_pressed() -> void:
	hide()
	close.emit()
	
