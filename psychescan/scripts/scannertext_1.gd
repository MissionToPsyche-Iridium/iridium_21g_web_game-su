extends Label

const base_speed := 20
var countTop := 0.0
var countBottom := 0.0
const typeSpeed := 60
@onready var label := $Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_visible_characters(0)
	label.set_visible_characters(0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var typing_speed = base_speed * delta
	if(get_visible_ratio() != 1.0):
		if(countTop < 1):
			countTop += base_speed*delta
		else:
			set_visible_characters(get_visible_characters()+1)
			countTop -= 1
	else:
		if(countTop < typeSpeed):
			countTop += base_speed*delta
		else:
			set_visible_ratio(0.0)
			countTop -= typeSpeed
	if(label.get_visible_ratio() != 1.0):
		if(countBottom < 1):
			countBottom += base_speed*delta
		else:
			label.set_visible_characters(label.get_visible_characters()+1)
			countBottom -= 1
	else:
		if(countBottom < typeSpeed):
			countBottom += base_speed*delta
		else:
			label.set_visible_ratio(0.0)
			countBottom -= typeSpeed
	pass
