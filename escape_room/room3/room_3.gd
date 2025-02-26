extends Node2D


signal popup_open
signal popup_close

signal win


var interactable = false


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
				popup_open.emit()
			if Input.is_action_just_pressed("ui_accept") || Input.is_action_just_pressed("ui_cancel"):
				$Question/PanelContainer/Question.show()
				$Question/PanelContainer/Validation.hide()
				$Question.hide()
				popup_close.emit()

func _on_question_option_1() -> void:
	$Question/PanelContainer/Validation/Message.text = "Sorry, that is incorrect. \nA defibrillator is a machine that gives a small electric shock to the heart to help it beat normally again. \nTry looking for more hints!"
	$Question/PanelContainer/Question.hide()
	$Question/PanelContainer/Validation.show()

func _on_question_option_2() -> void:
	$Question/PanelContainer/Validation/Message.text = "Sorry, that is incorrect. \nAn anemometer is a tool that measures how fast the wind is blowing. \nTry looking for more hints!"
	$Question/PanelContainer/Question.hide()
	$Question/PanelContainer/Validation.show()

func _on_question_option_3() -> void:
	$Question/PanelContainer/Validation/Message.text = "Correct!"
	$Question/PanelContainer/Question.hide()
	$Question/PanelContainer/Validation.show()
	await get_tree().create_timer(1.0).timeout
	win.emit()

func _on_player_interact() -> void:
	interactable = true
	if ($Player/RayCast2D.is_colliding()):
		$Player/PressE.show()

func _on_player_no_interact() -> void:
	interactable = false
	$Player/PressE.hide()
