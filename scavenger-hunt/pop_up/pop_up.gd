extends TextureRect

signal option1
signal option2
signal option3

#func _ready() -> void:
	#adjust_font_size()
	#get_window().size_changed.connect(_on_window_resized)
	#
#func adjust_font_size():
	##var viewport_size = get_window().get_viewport().get_visible_rect().size
	#var viewport_size = get_viewport().size
	##print("Viewport size: ", viewport_size)
	#var base_font_size = 8  # Your default font size
	#var base_width = 1920.0  # Base resolution width
	#var scale_factor = viewport_size.x / base_width  # Scale based on width
#
	#var new_font_size = int(base_font_size * scale_factor)
	#new_font_size = max(new_font_size, base_font_size)  # Prevent it from going below 8px
#
	#$PanelContainer/Question/Question.push_font_size(new_font_size)
	#$PanelContainer/Question/Option1.push_font_size(new_font_size)
	#$PanelContainer/Question/Option2.push_font_size(new_font_size)
	#$PanelContainer/Question/Option3.push_font_size(new_font_size)
	#$PanelContainer/Validation/Message.push_font_size(new_font_size)
#
#func _on_window_resized():
	#adjust_font_size()

func _on_option_1_pressed() -> void:
	option1.emit()

func _on_option_2_pressed() -> void:
	option2.emit()

func _on_option_3_pressed() -> void:
	option3.emit()
