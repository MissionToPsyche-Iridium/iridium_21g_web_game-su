extends Node2D

var velocity1 = 0.00
var velocity2 = 0.00

	
func set_vel_label():
	velocity1 = $space_ship.velocity.x
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://psychescan/levels/main_level.tscn")
