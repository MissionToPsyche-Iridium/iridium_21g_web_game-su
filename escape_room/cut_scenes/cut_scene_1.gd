extends Node2D

@onready var animation = $AnimationPlayer

var is_startcutscene = false

var is_followingpath = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_startcutscene = true
	animation.play("cover_fade")
	await get_tree().create_timer(2.0).timeout
	is_followingpath = true

func _physics_process(delta: float) -> void:
	if is_startcutscene:
		var pathfollower = $Path2D/PathFollow2D
		
		if is_followingpath:
			if pathfollower.progress_ratio < 0.5233:
				$Path2D/PathFollow2D/Player/PlayerSprite.play("walk_right")
			if pathfollower.progress_ratio >= 0.5233:
				$Path2D/PathFollow2D/Player/PlayerSprite.play("walk_up")
			if pathfollower.progress_ratio >= 1:
				cutscene_end()
			pathfollower.progress_ratio += 0.009


func cutscene_end():
	is_followingpath = false
	is_startcutscene = false
	get_tree().change_scene_to_file("res://scavenger-hunt/room2/room2.tscn")
	
