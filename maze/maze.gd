extends Node2D

var count = 0

func _on_collectible_hit() -> void:
	print("collectible got hit!")
	count += 1
	$Counter/Count.text = str(count) + "/5"
	$PopUp.show()


func _on_pop_up_close() -> void:
	print("closed!")


func _on_win_area_body_entered(body: Node2D) -> void:
	print("yayay!")
	$Player.hide()
	$TileMap.hide()
