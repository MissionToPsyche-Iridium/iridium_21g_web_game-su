extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Cover.show()
	$ButtonCover.show()
	$Disclaimer.show()
	$AnimationPlayer.play("cover_fade")
	await get_tree().create_timer(8.2).timeout      # wait 8 seconds to let cover cover disclaimer
	$AnimationPlayer.play("cover")
	await get_tree().create_timer(1.2).timeout
	$Disclaimer.hide()
	$ButtonCover.hide()
	$AnimationPlayer.play("cover_fade")
	await get_tree().create_timer(1.0).timeout
	$Cover.hide()


func _on_start_pressed() -> void:
	$Cover.show()
	$AnimationPlayer.play("cover")
	await get_tree().create_timer(1.2).timeout
	$Cover.color = Color(0,0,0,255)
	get_tree().change_scene_to_file("res://scavenger-hunt/world.tscn")


func _on_credits_pressed() -> void:
	$Cover.show()
	$AnimationPlayer.play("cover")
	await get_tree().create_timer(1.1).timeout
	$Cover.color = Color(0,0,0,255)
	get_tree().change_scene_to_file("res://Credits scene/credits.tscn")
