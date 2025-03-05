extends Node2D


signal popup_open
signal popup_close

signal win


var interactable = false
var isOpen = false
var correct = 3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Question/PanelContainer/Question/Question.text = "Which of the following is an instrument on the spacecraft?"
	$Question/PanelContainer/Question/Option1.text = "A defibrillater"
	$Question/PanelContainer/Question/Option2.text = "An anemometer"
	$Question/PanelContainer/Question/Option3.text = "A magnetometer"
	$Player.movable = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (interactable == true):
		var collidingNode = $Player/RayCast2D.get_collider()
		if (collidingNode == $SecurityGuard):
			if Input.is_action_just_pressed("interact"):
				$Question/PanelContainer/Question.show()
				$Question/PanelContainer/Validation.hide()
				$Question.show()
				if (!isOpen): $Audio/sfx_open.play()
				isOpen = true
				popup_open.emit()
			if Input.is_action_just_pressed("ui_accept") || Input.is_action_just_pressed("ui_cancel"):
				$Question/PanelContainer/Question.show()
				$Question/PanelContainer/Validation.hide()
				$Question.hide()
				if (isOpen): $Audio/sfx_close.play()
				isOpen = false
				popup_close.emit()
		if (collidingNode == $Sign):
			if Input.is_action_just_pressed("interact"):
				$SignPopUp.show()
				if (!isOpen): $Audio/sfx_open.play()
				isOpen = true
				popup_open.emit()
			if Input.is_action_just_pressed("ui_accept") || Input.is_action_just_pressed("ui_cancel"):
				$SignPopUp.hide()
				if (isOpen): $Audio/sfx_close.play()
				isOpen = false
				popup_close.emit()

func correct_answer() -> void:
	$Question/PanelContainer/Validation/Message.text = "Correct!"
	$Question/PanelContainer/Question.hide()
	$Question/PanelContainer/Validation.show()
	interactable = false
	await get_tree().create_timer(2.0).timeout
	win.emit()
	
func wrong_answer() -> void:
	$Question/PanelContainer/Validation/Message.text = "Sorry, that is incorrect. Try looking around the room for more hints!"
	$Question/PanelContainer/Question.hide()
	$Question/PanelContainer/Validation.show()
	_on_player_no_interact()
	await get_tree().create_timer(2.0).timeout
	$Question/PanelContainer/Question.show()
	$Question/PanelContainer/Validation.hide()
	$Question.hide()
	popup_close.emit()
	
func _on_question_option_1() -> void:
	if (correct == 1):
		correct_answer()
	else:
		wrong_answer()

func _on_question_option_2() -> void:
	if (correct == 2):
		correct_answer()
	else:
		wrong_answer()

func _on_question_option_3() -> void:
	if (correct == 3):
		correct

func _on_player_interact() -> void:
	interactable = true
	if ($Player/RayCast2D.is_colliding()):
		$Player/PressE.show()

func _on_player_no_interact() -> void:
	interactable = false
	$Player/PressE.hide()
