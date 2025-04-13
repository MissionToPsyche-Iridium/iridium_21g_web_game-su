extends Node2D

signal popup_open
signal popup_close
signal win

@onready var player = $Player

var isOpen

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
	2: ["Which rocket launched NASA's Psyche mission?", 
		"NASA's Saturn V", 
		"SpaceX Falcon Heavy",
		"SpaceX Toucan Light"],
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var question_number = rng.randi_range(0,1)
	$Question/Question/Question.text = questions_dict[question_number][0]
	$Question/Question/Options/Option1.text = questions_dict[question_number][1]
	$Question/Question/Options/Option2.text = questions_dict[question_number][2]
	$Question/Question/Options/Option3.text = questions_dict[question_number][3]
	
	if question_number == 0:
		correct = 1
		$PageSprite/Message.text = "It's someone's work journal...\n\nOctober 12, 2023\n\nToday I learned that Psyche takes off tomorrow... My boss wasn't very happy... Oops!"
	elif question_number == 1:
		correct = 3
		$PageSprite/Message.text = "It's someone's work journal...\n\nAugust 1, 2023\n\nI can't believe I have to wait so long for the spacecraft to start orbiting Psyche. I wish it was 6 years in the future already!"
	elif question_number == 2:
		correct = 2
		$PageSprite/Message.text = "It's someone's work journal...\n\nOctober 13, 2023\n\nI've been calling the rocket Toucan Light since the beginnign. My friend told me he thought I was joking this whole time. I didn't realize how wrong I was until today... Oops!"

	$PicturePopUp/Container/Message.text = "It's a picture of the preliminary design of the instruments and spacecraft. The description says it will reach Psyche in August 2029."
	$ChairPopUp/Container/Message.text = "It's just a chair..."
	$Player.movable = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (interactable == true):
		var collidingNode = $Player/RayCast2D.get_collider()
		if collidingNode == $QuestionArea:
			handle_popup($Question, "question")
		elif collidingNode == $NotebookArea:
			handle_popup($PageSprite, "notebook")
		elif collidingNode == $PictureArea:
			handle_popup($PicturePopUp, "picture")
		elif collidingNode == $Chair4/Area2D:
			handle_popup($ChairPopUp, "chair")


func handle_popup(popup_node: Node, area_name: String) -> void:
	if Input.is_action_just_pressed("interact"):
		popup_node.show()
		if !isOpen:
			$Audio/sfx_open.play()
		isOpen = true
		$Player/PressE.hide()
		popup_open.emit()
	elif Input.is_action_just_pressed("ui_cancel"):
		popup_node.hide()
		if isOpen:
			$Audio/sfx_close.play()
		isOpen = false
		$Player/PressE.show()
		popup_close.emit()


func correct_answer() -> void:
	_on_player_no_interact()
	$Audio/sfx_correct.stop()
	$Audio/sfx_correct.play()
	$Question/Validation/Message.text = "Correct!"
	$Question/Question.hide()
	$Question/Validation.show()
	await get_tree().create_timer(2.0).timeout
	win.emit()
	
func wrong_answer() -> void:
	$Audio/sfx_close.stop()
	$Audio/sfx_close.play()
	$Question/Validation/Message.text = "Sorry, that is incorrect. Try looking around the room for more hints!"
	$Question/Question.hide()
	$Question/Validation.show()

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
