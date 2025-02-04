extends TextEdit

@onready var node = $player

func _on_visibility_changed() -> void:
	text = node.get_velocity()
