extends Node2D

@onready var animation = $AnimationPlayer

@onready var enter1_player = $EnterRoom1/PathFollow2D/Player
@onready var enter1_player_sprite = $EnterRoom1/PathFollow2D/Player/PlayerSprite

@onready var leave1_player = $LeaveRoom1/PathFollow2D/Player
@onready var leave1_player_sprite = $LeaveRoom1/PathFollow2D/Player/PlayerSprite

@onready var enter2_player = $EnterRoom2/PathFollow2D/Player
@onready var enter2_player_sprite = $EnterRoom2/PathFollow2D/Player/PlayerSprite

var is_startcutscene = false
var is_leaveroom1 = false
var is_enterroom2 = false

var is_followingpath = false

func _ready() -> void:
	startcutscene()
	
func _physics_process(delta: float) -> void:
	if is_startcutscene:
		var pathfollower = $EnterRoom1/PathFollow2D
		
		if is_followingpath:
			if pathfollower.progress_ratio < 0.5233:
				enter1_player_sprite.play("walk_up")
			if pathfollower.progress_ratio >= 1:
				openingscene_end()
			pathfollower.progress_ratio += 0.009
		
	if is_leaveroom1:
		var pathfollower = $LeaveRoom1/PathFollow2D
		
		if is_followingpath:
			if pathfollower.progress_ratio < 0.4086:
				leave1_player_sprite.play("walk_right")
			if pathfollower.progress_ratio >= 0.4086:
				leave1_player_sprite.play("walk_up")
			if pathfollower.progress_ratio >= 1:
				leaveroom1_end()
			pathfollower.progress_ratio += 0.005

	if is_enterroom2:
		var pathfollower = $EnterRoom2/PathFollow2D
		
		if is_followingpath:
			if pathfollower.progress_ratio < 0.1467:
				enter2_player_sprite.play("walk_up")
			if pathfollower.progress_ratio >= 0.1467:
				enter2_player_sprite.play("walk_right")
			if pathfollower.progress_ratio >= 1:
				enterroom2_end()
			pathfollower.progress_ratio += 0.005

func startcutscene() -> void:
	leave1_player.movable = false
	$Room2Cover.hide()
	$Room2.hide()
	$Room2Camera.enabled = false
	$LeaveRoom1.hide()
	$Room2/Player/Camera2D.enabled = false
		
	enter1_player.movable = false
	$Room1Cover.show()
	$Room1Door.hide()
	$Room1/Player/Camera2D.enabled = false
	$Room1/Player.movable = false
	$Room1/Player.hide()
	$Room1/FrontDoor.hide()
	$Room1/FrontDoor/CollisionShape2D.disabled = true
	$Room1/Cover.color = Color(0,0,0,255)
	$Room1/Cover.show()
	
	$FrontDoor.hide()
	
	await get_tree().create_timer(2.0).timeout
	animation.play("room1_cover_fade")
	$Room1.show()
	$EnterRoom1.show()
	$FrontDoor.show()
	await get_tree().create_timer(2.0).timeout
	$FrontDoor.play("open")
	await get_tree().create_timer(2.0).timeout
	
	is_startcutscene = true
	is_followingpath = true

func openingscene_end():
	enter1_player_sprite.play("idle_up")
	$FrontDoor.play("close")
	is_followingpath = false
	is_startcutscene = false
	await get_tree().create_timer(2.0).timeout
	animation.play("room1_cover")
	await get_tree().create_timer(2.0).timeout
	startroom1()

func startroom1():
	$EnterRoom1.hide()
	$Room1Camera.enabled = false
	$Room1/Player/Camera2D.enabled = true
	$Room1/FrontDoor.show()
	$Room1/Player.show()
	$Room1/FrontDoor/CollisionShape2D.disabled = false
	animation.play("room1_cover_fade")
	await get_tree().create_timer(1.0).timeout
	$Room1/Player.movable = true
	$Room1Cover.hide()


func _on_end_room_1() -> void:
	$Room1Cover.show()
	animation.play("room1_cover")
	await get_tree().create_timer(2.0).timeout

	$Room1Camera.enabled = true   # zoom out
	$Room1/Question.hide()
	$Room1/Door.hide()
	$Room1/Player/Camera2D.enabled = false
	
	$Room1/Player.hide()
	$Room1/Player.movable = false
	
	$LeaveRoom1.show()
	$Room1Door.show()
	$LeaveRoom1/PathFollow2D/Player.show()
	
	await get_tree().create_timer(2.0).timeout
	animation.play("room1_cover_fade")
	
	await get_tree().create_timer(2.0).timeout
	$Room1Door.play("open")
	
	await get_tree().create_timer(2.0).timeout
	
	is_leaveroom1 = true
	is_followingpath = true
	

func leaveroom1_end():
	is_followingpath = false
	is_leaveroom1 = false	
	leave1_player_sprite.play("idle_up")
	$Room1Door.play("close")
	await get_tree().create_timer(2.0).timeout
	animation.play("room1_cover")
	$LeaveRoom1.hide()
	await get_tree().create_timer(2.0).timeout
	
	$Room1Camera.enabled = false
	$Room2Camera.enabled = true
	
	$Room2Cover.show()
	$Room1Cover.hide()
	$Room2.show()
	
	await get_tree().create_timer(2.0).timeout
	enterroom2()
	

func enterroom2():
	$Room2/Door/CollisionShape2D.disabled = true
	$Room2/Door.hide()
	$Room2/Player.hide()
	$Room2/Player.movable = false
	
	$EnterRoom2.show()
	$Room2Door.show()
	
	animation.play("room2_cover_fade")

	$Room2Door.play("open")
		
	is_enterroom2 = true
	is_followingpath = true


func enterroom2_end():
	enter2_player_sprite.play("idle_right")
	$Room2Door.play("close")
	is_followingpath = false
	is_enterroom2 = false
	await get_tree().create_timer(2.0).timeout
	animation.play("room2_cover")
	await get_tree().create_timer(2.0).timeout
	startroom2()

func startroom2():
	$EnterRoom2.hide()
	$Room2Camera.enabled = false
	$Room2/Player/Camera2D.enabled = true
	$Room2/Door.show()
	$Room2/Player.show()
	$Room2/Door/CollisionShape2D.disabled = false
	animation.play("room2_cover_fade")
	await get_tree().create_timer(2.0).timeout
	$Room2Cover.hide()
	$Room2/Player.movable = true
