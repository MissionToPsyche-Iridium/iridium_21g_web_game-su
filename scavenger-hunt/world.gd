extends Node2D

signal isMoving

@onready var animation = $AnimationPlayer

@onready var enter1_player = $Room1/EnterRoom1/PathFollow2D/Player
@onready var enter1_player_sprite = $Room1/EnterRoom1/PathFollow2D/Player/PlayerSprite

@onready var leave1_player = $Room1/LeaveRoom1/PathFollow2D/Player
@onready var leave1_player_sprite = $Room1/LeaveRoom1/PathFollow2D/Player/PlayerSprite

@onready var enter2_player = $Room2/EnterRoom2/PathFollow2D/Player
@onready var enter2_player_sprite = $Room2/EnterRoom2/PathFollow2D/Player/PlayerSprite

@onready var leave2_player = $Room2/LeaveRoom2/PathFollow2D/Player
@onready var leave2_player_sprite = $Room2/LeaveRoom2/PathFollow2D/Player/PlayerSprite

@onready var enter3_player = $Room3/EnterRoom3/PathFollow2D/Player
@onready var enter3_player_sprite = $Room3/EnterRoom3/PathFollow2D/Player/PlayerSprite

@onready var leave3_player = $Room3/LeaveRoom3/PathFollow2D/Player
@onready var leave3_player_sprite = $Room3/LeaveRoom3/PathFollow2D/Player/PlayerSprite

@onready var enter4_player = $Room4/EnterRoom4/PathFollow2D/Player
@onready var enter4_player_sprite = $Room4/EnterRoom4/PathFollow2D/Player/PlayerSprite

var is_enterroom1 = false
var is_leaveroom1 = false
var is_enterroom2 = false
var is_leaveroom2 = false
var is_enterroom3 = false
var is_leaveroom3a = false
var is_leaveroom3b = false
var is_enterroom4a = false
var is_movechair = false
var is_enterroom4c = false
var is_zoomin = false

var is_followingpath = false

func _ready() -> void:
	$ZoomIn/PathFollow2D/ZoomingCamera.enabled = false
	
	#Room1
	$Room1Cover.color = Color(0,0,0,255)
	$Room1Cover.show()
	$Room1/Room1Camera.enabled = true
	$Room1/Player/Camera2D.enabled = false
	$Room1/Player.movable = false
	$Room1/Player.hide()
	$Room1/EnterDoor.hide()
	$Room1/EnterDoor/CollisionShape2D.disabled = true
	$Room1/Player/PlayerSprite.play("idle_up")
	$Room1/Player/RayCast2D.target_position = Vector2(0, -20)
	$Room1/EnterRoom1.hide()
	enter1_player.movable = false
	$Room1/LeaveRoom1Door.hide()
	leave1_player.movable = false
	$Room1/LeaveRoom1.hide()
	
	#Room2
	$Room2Cover.hide()
	$Room2.hide()
	$Room2/Room2Camera.enabled = false
	$Room2/Player/Camera2D.enabled = false
	$Room2/Player.movable = false
	$Room2/Player/PlayerSprite.play("idle_right")
	$Room2/Player/RayCast2D.target_position = Vector2(20, 0)
	enter2_player.movable = false
	$Room2/EnterRoom2.hide()
	leave2_player.movable = false
	$Room2/LeaveRoom2.hide()
	
	#Room3
	$Room3Cover.hide()
	$Room3.hide()
	$Room3/Room3Camera.enabled = false
	$Room3/Player.movable = false
	$Room3/Player/PlayerSprite.play("idle_right")
	$Room3/Player/RayCast2D.target_position = Vector2(20, 0)
	$Room3/Player/Camera2D.enabled = false
	$Room3/Question.hide()
	enter3_player.movable = false
	$Room3/EnterRoom3.hide()
	leave3_player.movable = false
	$Room3/LeaveRoom3.hide()
	$Room3/LeaveRoom3Door.hide()
	$Room3/MoveSecurity.hide()
	
	#Room4
	$Room4Cover.hide()
	$Room4.hide()
	$Room4/Room4Camera.enabled = false
	$Room4/Player.movable = false
	$Room4/Player/PlayerSprite.play("idle_up")
	$Room4/Player/RayCast2D.target_position = Vector2(20, 0)
	enter4_player.movable = false
	$Room4/EnterRoom4.hide()	
	
	
	#if (Input.is_action_just_pressed("1")):
	enterroom1()
	#leaveroom2_end()
	#enterroom3()
	
func _physics_process(delta: float) -> void:
	if is_enterroom1:
		var pathfollower = $Room1/EnterRoom1/PathFollow2D
		if is_followingpath:
			isMoving.emit()
			if pathfollower.progress_ratio < 0.5233:
				enter1_player_sprite.play("walk_up")
			if pathfollower.progress_ratio >= 1:
				enterroom1_end()
			pathfollower.progress_ratio += 0.009
	if is_leaveroom1:
		var pathfollower = $Room1/LeaveRoom1/PathFollow2D
		if is_followingpath:
			isMoving.emit()
			if pathfollower.progress_ratio < 0.4086:
				leave1_player_sprite.play("walk_right")
			if pathfollower.progress_ratio >= 0.4086:
				leave1_player_sprite.play("walk_up")
			if pathfollower.progress_ratio >= 1:
				leaveroom1_end()
			pathfollower.progress_ratio += 0.005

	if is_enterroom2:
		var pathfollower = $Room2/EnterRoom2/PathFollow2D
		if is_followingpath:
			isMoving.emit()
			if pathfollower.progress_ratio < 0.1467:
				enter2_player_sprite.play("walk_up")
			if pathfollower.progress_ratio >= 0.1467:
				enter2_player_sprite.play("walk_right")
			if pathfollower.progress_ratio >= 1:
				enterroom2_end()
			pathfollower.progress_ratio += 0.007
	if is_leaveroom2:
		var pathfollower = $Room2/LeaveRoom2/PathFollow2D
		if is_followingpath:
			isMoving.emit()
			if pathfollower.progress_ratio < 0.29:
				leave2_player_sprite.play("walk_down")
			if pathfollower.progress_ratio >= 0.29:
				leave2_player_sprite.play("walk_right")
			if pathfollower.progress_ratio >= 1:
				leaveroom2_end()
			pathfollower.progress_ratio += 0.005
			
	if is_enterroom3:
		var pathfollower = $Room3/EnterRoom3/PathFollow2D
		if is_followingpath:
			isMoving.emit()
			if pathfollower.progress_ratio < 1:
				enter3_player_sprite.play("walk_right")
			if pathfollower.progress_ratio >= 1:
				enterroom3_end()
			pathfollower.progress_ratio += 0.01
	if is_leaveroom3a:
		var pathfollower = $Room3/MoveSecurity/PathFollow2D
		if is_followingpath:
			isMoving.emit()
			if pathfollower.progress_ratio < 1:
				$Room3/MoveSecurity/PathFollow2D/AnimatedSprite2D.play("walk")
			if pathfollower.progress_ratio >= 1:
				$Room3/MoveSecurity/PathFollow2D/AnimatedSprite2D.play("idle")
				leaveroom3a_end()
			pathfollower.progress_ratio += 0.05
	if is_leaveroom3b:
		var pathfollower = $Room3/LeaveRoom3/PathFollow2D
		if is_followingpath:
			isMoving.emit()
			if pathfollower.progress_ratio < 1:
				leave3_player_sprite.play("walk_up")
			if pathfollower.progress_ratio >= 1:
				leaveroom3b_end()
			pathfollower.progress_ratio += 0.007
	
	if is_enterroom4a:
		var pathfollower = $Room4/EnterRoom4/PathFollow2D
		if is_followingpath:
			isMoving.emit()
			enter4_player_sprite.play("walk_up")
			if pathfollower.progress_ratio >= 0.7167:
				enter4_player_sprite.play("idle_left")
				enterroom4a_end()
			pathfollower.progress_ratio += 0.008
	if is_movechair:
		var pathfollower = $Room4/MoveChair/PathFollow2D
		if is_followingpath:
			isMoving.emit()
			if pathfollower.progress_ratio >= 1:
				enterroom4b_end()
			pathfollower.progress_ratio += 0.05
	if is_enterroom4c:
		var pathfollower = $Room4/EnterRoom4/PathFollow2D
		var pathfollower2 = $Room4/MoveChair/PathFollow2D
		pathfollower.progress_ratio == 0.7167
		if is_followingpath:
			isMoving.emit()
			if pathfollower.progress_ratio > 0.7167:
				enter4_player_sprite.play("walk_left")
			if pathfollower.progress_ratio > 0.9067:
				pathfollower2.progress_ratio -= 0.05
				enter4_player_sprite.play("walk_up")
			if pathfollower.progress_ratio >= 1 && pathfollower2.progress_ratio == 0:
				enter4_player_sprite.play("idle_up")
				enterroom4_end()
			pathfollower.progress_ratio += 0.005
	if is_zoomin:
		var pathfollower = $ZoomIn/PathFollow2D
		if is_followingpath:
			if pathfollower.progress_ratio < 1:
				pathfollower.progress_ratio += 0.005
				if ($ZoomIn/PathFollow2D/ZoomingCamera.zoom < Vector2(60,60)):
					$ZoomIn/PathFollow2D/ZoomingCamera.zoom += Vector2(0.1,0.1)
			if pathfollower.progress_ratio >= 1:
				endrooms()


#var input_buffer = ""
#
#func _input(event: InputEvent) -> void:
	#if event is InputEventKey and event.pressed:
		#if event.unicode > 0:  # Check if it's a printable character
			#input_buffer += char(event.unicode)
		#
	#if event.is_action_pressed("ui_accept"):  # When Enter is pressed
		#process_input(input_buffer)
		#input_buffer = ""  # Clear buffer for next input
#
#func process_input(input_text):
	#if input_text == ("3"):
		#is_followingpath = false
		#is_enterroom1 = false
		#
		#$Room1/Player/Camera2D.enabled = false
		#$Room1/Player.hide()
		#$Room1/Player.movable = false
		#$Room1.interactable = false
		#$Room1/Room1Camera.enabled = false
		#$Room1/Player.movable = false
		#$Room1.hide()
		#$Room3/Room3Camera.enabled = true
		#
		#$Room3Cover.show()
		#$Room3.show()
		#enterroom3()




#Start of Room1
func enterroom1() -> void:
	await get_tree().create_timer(2.0).timeout
	animation.play("room1_cover_fade")
	$Room1.show()
	$Room1/EnterRoom1Door.show()
	$Room1/EnterRoom1.show()
	await get_tree().create_timer(2.0).timeout
	$Room1/EnterRoom1Door.play("open")
	$Audio/sfx_doors.play()
	await get_tree().create_timer(2.0).timeout
	
	is_enterroom1 = true
	is_followingpath = true

func enterroom1_end():
	enter1_player_sprite.play("idle_up")
	$Room1/EnterRoom1Door.play("close")
	$Audio/sfx_doors.play()
	is_followingpath = false
	is_enterroom1 = false
	await get_tree().create_timer(2.0).timeout
	animation.play("room1_cover")
	await get_tree().create_timer(2.0).timeout
	playroom1()

func playroom1():
	$Room1/EnterRoom1.hide()
	$Room1/Room1Camera.enabled = false
	$Room1/Player/Camera2D.enabled = true
	$Room1/EnterDoor.show()
	$Room1/Player.show()
	$Room1/EnterDoor/CollisionShape2D.disabled = false
	animation.play("room1_cover_fade")
	await get_tree().create_timer(1.0).timeout
	$Room1/Player.movable = true
	$Room1Cover.hide()


func _on_room_1_win() -> void:
	$Room1Cover.show()
	animation.play("room1_cover")
	await get_tree().create_timer(1.0).timeout

	$Room1/Room1Camera.enabled = true   # zoom out
	$Room1/Player/Camera2D/Question.hide()
	$Room1/LeaveDoor.hide()
	$Room1/Player/Camera2D.enabled = false
	
	$Room1/Player.hide()
	$Room1/Player.movable = false
	$Room1.interactable = false
	
	$Room1/LeaveRoom1.show()
	$Room1/LeaveRoom1Door.show()
	leave1_player.show()
	leave1_player_sprite.play("idle_up")
	
	await get_tree().create_timer(1.0).timeout
	animation.play("room1_cover_fade")
	
	await get_tree().create_timer(2.0).timeout
	$Room1/LeaveRoom1Door.play("open")
	$Audio/sfx_doors.play()
	
	await get_tree().create_timer(1.0).timeout
	
	is_leaveroom1 = true
	is_followingpath = true
	leave1_player.moving = true
	
func leaveroom1_end():
	is_followingpath = false
	is_leaveroom1 = false	
	leave1_player_sprite.play("idle_up")
	$Room1/LeaveRoom1Door.play("close")
	$Audio/sfx_doors.play()
	await get_tree().create_timer(0.5).timeout
	animation.play("room1_cover")
	$Room1/LeaveRoom1.hide()
	await get_tree().create_timer(1.0).timeout
	
	$Room1/Room1Camera.enabled = false
	$Room2/Room2Camera.enabled = true
	
	$Room2Cover.show()
	$Room1Cover.hide()
	$Room2.show()
	
	await get_tree().create_timer(1.0).timeout
	enterroom2()
#End of Room1





#Start of Room2
func enterroom2():
	$Room2/EnterDoor/CollisionShape2D.disabled = true
	$Room2/EnterDoor.hide()
	$Room2/Player.hide()
	$Room2/Player.movable = false
	
	$Room2/EnterRoom2.show()
	$Room2/EnterRoom2Door.show()
	
	animation.play("room2_cover_fade")

	$Room2/EnterRoom2Door.play("open")
	$Audio/sfx_doors.play()
		
	is_enterroom2 = true
	is_followingpath = true
	enter2_player.moving = true
	

func enterroom2_end():
	enter2_player_sprite.play("idle_right")
	$Room2/EnterRoom2Door.play("close")
	$Audio/sfx_doors.play()
	is_followingpath = false
	is_enterroom2 = false
	await get_tree().create_timer(2.0).timeout
	animation.play("room2_cover")
	await get_tree().create_timer(2.0).timeout
	playroom2()

func playroom2():
	$Room2/EnterRoom2.hide()
	$Room2/Room2Camera.enabled = false
	$Room2/Player/Camera2D.enabled = true
	$Room2/EnterDoor.show()
	$Room2/Player.show()
	$Room2/EnterDoor/CollisionShape2D.disabled = false
	$Room2/Player/PlayerSprite.play("idle_right")
	animation.play("room2_cover_fade")
	await get_tree().create_timer(1.0).timeout
	$Room2Cover.hide()
	$Room2/Player.movable = true

func _on_room_2_win() -> void:
	$Room2Cover.show()
	animation.play("room2_cover")
	await get_tree().create_timer(1.0).timeout

	$Room2/Player/Camera2D.enabled = false
	$Room2/Room2Camera.enabled = true   # zoom out
	$Room2/Question.hide()
	$Room2/LeaveDoor.hide()
	
	$Room2/Player.hide()
	$Room2/Player.movable = false
	$Room2.interactable = false
	
	$Room2/LeaveRoom2.show()
	$Room2/LeaveRoom2Door.show()
	leave2_player.show()
	leave2_player_sprite.play("idle_right")
	
	await get_tree().create_timer(1.0).timeout
	animation.play("room2_cover_fade")
	
	await get_tree().create_timer(2.0).timeout
	$Room2/LeaveRoom2Door.play("open")
	$Audio/sfx_doors.play()
	
	await get_tree().create_timer(1.0).timeout
	
	is_leaveroom2 = true
	is_followingpath = true
	leave2_player.moving = true
	
func leaveroom2_end():
	is_followingpath = false
	is_leaveroom2 = false	
	leave2_player_sprite.play("idle_right")
	$Room2/LeaveRoom2Door.play("close")
	$Audio/sfx_doors.play()
	await get_tree().create_timer(0.5).timeout
	animation.play("room2_cover")
	$Room2/LeaveRoom2.hide()
	await get_tree().create_timer(1.0).timeout
	
	$Room2/Room2Camera.enabled = false
	$Room3/Room3Camera.enabled = true
	
	$Room3Cover.show()
	$Room2Cover.hide()
	$Room3.show()
	
	await get_tree().create_timer(1.0).timeout
	enterroom3()
#End Room2





#Start of Room3
func enterroom3():	
	$Room3/EnterDoor.hide()
	$Room3/EnterDoor/CollisionShape2D.disabled = true
	
	$Room3/Player.hide()
	$Room3/Player.movable = false
	
	$Room3/EnterRoom3.show()
	$Room3/EnterRoom3Door.show()
	
	$Room3/MoveSecurity.hide()
	
	animation.play("room3_cover_fade")

	$Room3/EnterRoom3Door.play("open")
	$Audio/sfx_doors.play()
	
	is_enterroom3 = true
	is_followingpath = true
	enter3_player.moving = true
	

func enterroom3_end():
	enter3_player_sprite.play("idle_right")
	$Room3/EnterRoom3Door.play("close")
	$Audio/sfx_doors.play()
	is_followingpath = false
	is_enterroom3 = false
	await get_tree().create_timer(1.0).timeout
	animation.play("room3_cover")
	await get_tree().create_timer(1.0).timeout
	playroom3()

func playroom3():
	$Room3/EnterRoom3.hide()
	$Room3/Room3Camera.enabled = false
	$Room3/Player/Camera2D.enabled = true
	$Room3/EnterDoor.show()
	$Room3/Player.show()
	$Room3/EnterDoor/CollisionShape2D.disabled = false
	$Room3/Player/PlayerSprite.play("idle_right")
	animation.play("room3_cover_fade")
	await get_tree().create_timer(1.0).timeout
	$Room3Cover.hide()
	$Room3/Player.movable = true

func _on_room_3_win() -> void:
	Audio.volume_db -= 5
	$Room3Cover.show()
	animation.play("room3_cover")
	await get_tree().create_timer(1.0).timeout
	Audio.volume_db -= 5

	$Room3/Player/Camera2D.enabled = false
	$Room3/Room3Camera.enabled = true   # zoom out
	$Room3/Question.hide()
	$Room3/LeaveDoor.hide()
	$Room3/SecurityGuard.hide()
	$Room3/SecurityGuard/CollisionShape2D.disabled = true
		
	$Room3/Player.hide()
	$Room3/Player.movable = false
	$Room3.interactable = false
		
	$Room3/LeaveRoom3.show()
	$Room3/LeaveRoom3Door.show()
	leave3_player.show()
	$Room3/MoveSecurity.show()
	
	await get_tree().create_timer(1.0).timeout
	Audio.volume_db -= 5
	
	animation.play("room3_cover_fade")
	
	await get_tree().create_timer(1.0).timeout
	Audio.volume_db -= 5
	
	is_leaveroom3a = true
	is_followingpath = true
	leave3_player.moving = true
	
	
func leaveroom3a_end():
	Audio.volume_db -= 5
	is_followingpath = false
	is_leaveroom3a = false
	$Room3/LeaveRoom3Door.play("open")
	$Audio/sfx_doors.play()
	Audio.play_music_minigame(-30)
	await get_tree().create_timer(1.0).timeout
	Audio.volume_db += 5
	leaveroom3b()

func leaveroom3b():
	is_followingpath = true
	is_leaveroom3b = true
	leave3_player.moving = true
	Audio.volume_db += 5
#End Room3

func leaveroom3b_end():
	Audio.volume_db += 5
	is_followingpath = false
	is_leaveroom3b = false
	leave3_player_sprite.play("idle_up")
	$Room3/LeaveRoom3Door.play("close")
	$Audio/sfx_doors.play()
	await get_tree().create_timer(2.0).timeout
	Audio.volume_db += 5
	animation.play("room3_cover")
	$Room3/LeaveRoom3.hide()
	await get_tree().create_timer(1.0).timeout
	
	$Room3/Room3Camera.enabled = false
	$Room4/Room4Camera.enabled = true
		
	$Room4Cover.show()
	$Room3Cover.hide()
	$Room4.show()
	
	
	await get_tree().create_timer(1.0).timeout
	enterroom4()





#Start of Room4
func enterroom4():
	enter4_player_sprite.play("idle_up")
	$Room4Cover.show()
	$Room4.show()
	$Room4/Player.hide()
	$Room4/Player.movable = false
	
	$Room4/EnterRoom4.show()
	$Room4/Room4Door.show()
	
	animation.play("room4_cover_fade")
	
	is_enterroom4a = true
	is_followingpath = true
	enter4_player.moving = true

func enterroom4a_end():
	is_followingpath = false
	is_enterroom4a= false
	await get_tree().create_timer(1.0).timeout
	is_movechair = true
	is_followingpath = true
	
func enterroom4b_end():
	is_followingpath = false
	is_movechair = false
	await get_tree().create_timer(1.0).timeout
	is_enterroom4c = true
	is_followingpath = true
	enter4_player.moving = true
	
func enterroom4_end():
	is_followingpath = false
	is_enterroom4c = false
	
	await get_tree().create_timer(1.0).timeout
	$Room4/Room4Camera.enabled = false
	$ZoomIn/PathFollow2D/ZoomingCamera.enabled = true
	is_zoomin = true
	is_followingpath = true
	
	
func endrooms():
	is_zoomin = false
	is_followingpath = false
	await get_tree().create_timer(1.0).timeout
	animation.play("room4_cover")
	
	await get_tree().create_timer(1.0).timeout
	
	get_tree().change_scene_to_file("res://scavenger-hunt/scenes/lauch.tscn")
	
#End of Room4
