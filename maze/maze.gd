extends Node2D


func _on_collectible_hit() -> void:
	print("helloooo I got hit!")
	$PopUp.show()


func _on_pop_up_close() -> void:
	print("closed!")


func _on_win_area_body_entered(body: Node2D) -> void:
	print("yayay!")
	$Player.hide()
