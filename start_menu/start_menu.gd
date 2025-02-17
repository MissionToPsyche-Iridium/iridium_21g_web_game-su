extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Button.hide()
	$AnimationPlayer.play("cover_fade")
	await get_tree().create_timer(8.2).timeout      # wait 8 seconds to let cover cover disclaimer
	$AnimationPlayer.play("cover")
	await get_tree().create_timer(1.2).timeout
	$Disclaimer.hide()
	$Button.show()
	$AnimationPlayer.play("cover_fade")
	await get_tree().create_timer(1.0).timeout
	$Cover.hide()	


func _on_button_pressed() -> void:
	$Cover.show()
	$AnimationPlayer.play("cover")
	await get_tree().create_timer(1.0).timeout
	$Cover.color = Color(0,0,0,255)
	get_tree().change_scene_to_file("res://scavenger-hunt/world.tscn")
