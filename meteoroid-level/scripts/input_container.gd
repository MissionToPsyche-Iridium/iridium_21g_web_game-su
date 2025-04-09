extends HBoxContainer

@onready var ArrowClass = preload("res://meteoroid-level/scenes/input_arrows.tscn")

var input = {"ui_right": "Right", # directional inputs using arrow keys
"ui_left": "Left",
"ui_up": "Up",
"ui_down": "Down"}


func create_arrow(dir: String):
	var arrow = ArrowClass.instantiate()
	var animation = arrow.get_node("AnimatedSprite2D")
	animation.play(input[dir])
	add_child(arrow)

func remove_arrow():
	var arrows = get_children()
	var arrows_size = arrows.size()
	if arrows_size > 0:
		arrows[arrows_size - 1].queue_free()
