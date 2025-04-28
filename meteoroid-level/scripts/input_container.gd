# script to generate input arrows

extends HBoxContainer

@onready var ArrowClass = preload("res://meteoroid-level/scenes/input_arrows.tscn") # loads scene into variable

var input = {"ui_right": "Right", # directional inputs using arrow keys
"ui_left": "Left",
"ui_up": "Up",
"ui_down": "Down"}


func create_arrow(dir: String): # adds arrow to input list
	var arrow = ArrowClass.instantiate() # instantiates an ArrowClass object
	var animation = arrow.get_node("AnimatedSprite2D") # reference to the AnimatedSprite2D node in ArrowClass
	animation.play(input[dir]) # sets arrow direction
	add_child(arrow)

func remove_arrow(): # removes most recent arrow from container
	var arrows = get_children() # returns array of children
	var arrows_size = arrows.size()
	if arrows_size > 0: # check for empty array
		arrows[arrows_size - 1].queue_free()
