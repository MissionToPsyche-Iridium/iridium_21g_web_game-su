extends Node2D

signal popup_open
signal popup_close

signal win


var interactable = false

var rng = RandomNumberGenerator.new()

var correct

var questions_dict = {
	0: ["When did the Psyche spacecraft launch?", 
		"Friday, October 13, 2023", 
		"Friday, October 07, 2023", 
		"Thursday, October 12, 2023"],
	1: ["When will the Psyche spacecraft start orbiting the asteroid?", 
		"August 2028", 
		"April 2029", 
		"August 2029"],
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var question_number = rng.randi_range(0,1)
	print(question_number)
	$Question/PanelContainer/Question/Question.text = questions_dict[question_number][0]
	print(questions_dict[question_number][0])
	$Question/PanelContainer/Question/Option1.text = questions_dict[question_number][1]
	print(questions_dict[question_number][1])
	$Question/PanelContainer/Question/Option2.text = questions_dict[question_number][2]
	print(questions_dict[question_number][2])
	$Question/PanelContainer/Question/Option3.text = questions_dict[question_number][3]
	print(questions_dict[question_number][3])
	
	if (question_number == 0):
		correct = 1
	else:
		correct = 3

	$PicturePopUp/PanelContainer/Description/Message.text = "It's a picture of the preliminary design of the instruments and spacecraft. The description says it will reach Psyche in August 2029."
	$ChairPopUp/PanelContainer/Description/Message.text = "It's just a chair..."
	$Player.movable = false
	
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
