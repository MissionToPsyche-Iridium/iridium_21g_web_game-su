extends Node2D

signal popup_open
signal popup_close

signal end_room1


var interactable = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	$Question/PanelContainer/Question/Question.text = "What day did the Psyche spacecraft launch?"
	$Question/PanelContainer/Question/Option1.text = "Friday, October 13, 2023"
	$Question/PanelContainer/Question/Option2.text = "Friday, October 25, 2022"
	$Question/PanelContainer/Question/Option3.text = "Friday, Octboer 18, 2023"
	$PicturePopUp/PanelContainer/Description/Message.text = "It's a picture of the spacecraft on launch day. The description says it will reach Psyche in August 2029."
	$ChairPopUp/PanelContainer/Description/Message.text = "It's just a chair..."
	$Player.movable = false
	visible = false
	$Cover.color = Color(0,0,0,255)
	await get_tree().create_timer(2.0).timeout
	visible = true
	$AnimationPlayer.play("cover_fade")
	await get_tree().create_timer(1.0).timeout
	$Cover.hide()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (interactable == true):
		var collidingNode = $Player/RayCast2D.get_collider()
		if (collidingNode == $QuestionArea):
			if Input.is_action_just_pressed("interact"):
				$Question/PanelContainer/Question.show()
				$Question/PanelContainer/Validation.hide()
				$Question.show()
				popup_open.emit()
			if Input.is_action_just_pressed("ui_accept") || Input.is_action_just_pressed("ui_cancel"):
				$Question/PanelContainer/Question.show()
				$Question/PanelContainer/Validation.hide()
				$Question.hide()
				popup_close.emit()
		if (collidingNode == $NotebookArea):
			if Input.is_action_just_pressed("interact"):
				$PageSprite.show()
				popup_open.emit()
			if Input.is_action_just_pressed("ui_accept") || Input.is_action_just_pressed("ui_cancel"):
				$PageSprite.hide()
				popup_close.emit()
		if (collidingNode == $PictureArea):
			if Input.is_action_just_pressed("interact"):
				$PicturePopUp.show()
				popup_open.emit()
			if Input.is_action_just_pressed("ui_accept") || Input.is_action_just_pressed("ui_cancel"):
				$PicturePopUp.hide()
				popup_close.emit()
		if (collidingNode == $Chair4/Area2D):
			if Input.is_action_just_pressed("interact"):
				$ChairPopUp.show()
				popup_open.emit()
			if Input.is_action_just_pressed("ui_accept") || Input.is_action_just_pressed("ui_cancel"):
				$ChairPopUp.hide()
				popup_close.emit()
		


func _on_question_option_1() -> void:
	$Question/PanelContainer/Validation/Message.text = "Correct!"
	#$Question/PanelContainer/Validation/Message.PRESET_CENTER
	$Question/PanelContainer/Question.hide()
	$Question/PanelContainer/Validation.show()
	await get_tree().create_timer(1.0).timeout
	$AnimationPlayer.play("cover")
	await get_tree().create_timer(1.0).timeout
	print("emitting.........")
	end_room1.emit()

func _on_question_option_2() -> void:
	$Question/PanelContainer/Validation/Message.text = "Sorry, that is incorrect. Try looking around the room for more hints!"
	$Question/PanelContainer/Question.hide()
	$Question/PanelContainer/Validation.show()

func _on_question_option_3() -> void:
	$Question/PanelContainer/Validation/Message.text = "Sorry, that is incorrect. Try looking around the room for more hints!"
	$Question/PanelContainer/Question.hide()
	$Question/PanelContainer/Validation.show()
	
func _on_question_go_back() -> void:
	$Question/PanelContainer/Validation.hide()
	$Question/PanelContainer/Question.show()


func _on_player_interact() -> void:
	interactable = true
	if ($Player/RayCast2D.is_colliding()):
		$Player/PressE.show()
	


func _on_player_no_interact() -> void:
	interactable = false
	$Player/PressE.hide()


func _on_notebook_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
	
