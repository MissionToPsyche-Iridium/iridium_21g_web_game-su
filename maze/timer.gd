extends Panel

var time: float = 300.0
var minutes: int = 0
var seconds: int = 0

var movable = true

signal pause

func _process(delta: float) -> void:
	if movable:
		time -= delta
		seconds = fmod(time, 60)
		minutes = fmod(time, 3600) / 60
		$Minutes.text = "%02d:" % minutes
		$Seconds.text = "%02d" % seconds
		if time == 0:
			time_up()
		
func time_up() -> void:
	print("Uh oh you ran out of time!")



func _on_collectible_hit() -> void:
	movable = false

func _on_pop_up_close() -> void:
	movable = true
	
func _on_win_area_win() -> void:
	movable = false
