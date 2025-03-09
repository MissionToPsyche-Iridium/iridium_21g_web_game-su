extends Node2D


signal popup_open
signal popup_close

signal win


var interactable = false
var isOpen = false
var correct
var rng = RandomNumberGenerator.new()
var questions_dict = {
	0: ["Which of the following is an instrument on the spacecraft?", 
		"A defibrillater", 
		"An anemometer", 
		"A magnetometer"],
	1: ["Why is the Psyche mission so important?", 
		"Psyche might have part of a planetismal core", 
		"Psyche is mostly made of rock and ice", 
		"The spacecraft will not orbit the asteroid"],
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	var question_number = rng.randi_range(0,1)
	$Question/Question/Question.text = questions_dict[question_number][0]
	$Question/Question/Option1.text = questions_dict[question_number][1]
	$Question/Question/Option2.text = questions_dict[question_number][2]
	$Question/Question/Option3.text = questions_dict[question_number][3]
	
	if (question_number == 0):
		correct = 3
	else:
		correct = 1

	$CabinetDescription/Container/Message.text = "It's a cabinet full of documents about the Psyche mission. One document says that Psyche may be the core of a planetismal. Planetismals crash into each other and create planets."

	$Player.movable = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (interactable == true):
		var collidingNode = $Player/RayCast2D.get_collider()
		if (collidingNode == $SecurityGuard):
			if Input.is_action_just_pressed("interact"):
				$Question/Question.show()
				$Question/Validation.hide()
				$Question.show()
				if (!isOpen): $Audio/sfx_open.play()
				isOpen = true
				$Player/CloseInstructions.show()
				popup_open.emit()
			if Input.is_action_just_pressed("ui_cancel"):
				$Question/Question.show()
				$Question/Validation.hide()
				$Question.hide()
				if (isOpen): $Audio/sfx_close.play()
				isOpen = false
				$Player/CloseInstructions.hide()
				popup_close.emit()
		if (collidingNode == $Sign):
			if Input.is_action_just_pressed("interact"):
				$SignPopUp.show()
				if (!isOpen): $Audio/sfx_open.play()
				isOpen = true
				$Player/CloseInstructions.show()
				popup_open.emit()
			if Input.is_action_just_pressed("ui_cancel"):
				$SignPopUp.hide()
				if (isOpen): $Audio/sfx_close.play()
				isOpen = false
				$Player/CloseInstructions.hide()
				popup_close.emit()
		if (collidingNode == $Cabinet):
			if Input.is_action_just_pressed("interact"):
				$CabinetDescription.show()
				if (!isOpen): $Audio/sfx_open.play()
				isOpen = true
				$Player/CloseInstructions.show()
				popup_open.emit()
			if Input.is_action_just_pressed("ui_cancel"):
				$CabinetDescription.hide()
				if (isOpen): $Audio/sfx_close.play()
				isOpen = false
				$Player/CloseInstructions.hide()
				popup_close.emit()

func correct_answer() -> void:
	$Player/CloseInstructions.hide()
	$Audio/sfx_correct.play()
	$Question/Validation/Message.text = "Correct!"
	$Question/Question.hide()
	$Question/Validation.show()
	await get_tree().create_timer(2.0).timeout
	win.emit()
	
func wrong_answer() -> void:
	$Player/CloseInstructions.hide()
	$Question/Validation/Message.text = "Sorry, that is incorrect. Try looking around the room for more hints!"
	$Question/Question.hide()
	$Question/Validation.show()
	_on_player_no_interact()
	await get_tree().create_timer(2.0).timeout
	$Question/Question.show()
	$Question/Validation.hide()
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
		correct_answer()
	else:
		wrong_answer()

func _on_player_interact() -> void:
	interactable = true
	if ($Player/RayCast2D.is_colliding()):
		$Player/PressE.show()

func _on_player_no_interact() -> void:
	interactable = false
	$Player/PressE.hide()
