extends Node2D

signal popup_open
signal popup_close
signal win

@onready var player = $Player
@onready var question_area= $QuestionArea
@onready var question_popup = $Player/Camera2D/QuestionPopUp
@onready var question = $Player/Camera2D/QuestionPopUp/QuestionContainer
@onready var question_label = $Player/Camera2D/QuestionPopUp/QuestionContainer/QuestionLabel
@onready var validation = $Player/Camera2D/QuestionPopUp/ValidationContainer
@onready var valid_msg = $Player/Camera2D/QuestionPopUp/ValidationContainer/Message
@onready var notebook_area = $NotebookArea
@onready var page_text = $Player/Camera2D/PageSprite/Message
@onready var page = $Player/Camera2D/PageSprite
@onready var picture_area = $PictureArea
@onready var picture = $Player/Camera2D/PicturePopUp
@onready var picture_msg = $Player/Camera2D/PicturePopUp/Container/Message
@onready var chair_area = $Chairs/Area2D
@onready var chair = $Player/Camera2D/ChairPopUp
@onready var chair_msg = $Player/Camera2D/ChairPopUp/Container/Message
@onready var coffee_table_area = $CoffeeTable/Area2D
@onready var coffee_table = $Player/Camera2D/CoffeeTablePopUp
@onready var coffee_table_msg = $Player/Camera2D/CoffeeTablePopUp/Container/Message
@onready var lady_area = $Lady
@onready var lady = $Player/Camera2D/LadyDescription
@onready var lady_msg = $Player/Camera2D/LadyDescription/Container/Message
@onready var kids_area = $Kids
@onready var kids = $Player/Camera2D/KidPopUp
@onready var kids_msg = $Player/Camera2D/KidPopUp/Container/Message

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

@onready var num_opened := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var question_number = rng.randi_range(0,2)
	question_label.text = questions_dict[question_number][0]
	question.get_node("Options/Option1").text = questions_dict[question_number][1]
	question.get_node("Options/Option2").text = questions_dict[question_number][2]
	question.get_node("Options/Option3").text = questions_dict[question_number][3]
	
	if question_number == 0:
		correct = 1
		page_text.text = "It's someone's work journal...\n\nOctober 12, 2023\n\nToday I learned that Psyche takes off tomorrow... My boss wasn't very happy... Oops!"
	elif question_number == 1:
		correct = 3
		page_text.text = "It's someone's work journal...\n\nAugust 1, 2023\n\nI can't believe I have to wait so long for the spacecraft to start orbiting Psyche. I wish it was 6 years in the future already!"
	elif question_number == 2:
		correct = 2
		page_text.text = "It's someone's work journal...\n\nOctober 13, 2023\n\nI've been calling the rocket Toucan Light since the beginning. My friend told me he thought I was joking this whole time. I didn't realize how wrong I was until today... Oops!"

	picture_msg.text = "It's a picture of the preliminary design of the instruments and spacecraft. The description says it will reach Psyche in August 2029."
	chair_msg.text = "It's just a chair..."
	coffee_table_msg.text = "It's a collection of articles about Psyche. Hmm there's something underneath them... Oh! It's a sticky note that says\n16-19-25-3-8-5\nHmmm... I wonder what that means."
	lady_msg.text = "\"It's bring your kids to work day today, but they won't stop playing. I don't blame them, though.\""
	kids_msg.text = "\"We're not allowed to talk to strangers.\""
	
	$Receptionist/ReceptionistSprite.play("default")
	$Kids/Boy.play("default")
	$Kids/Girl.play("default")
	$Lady/AnimatedSprite2D.play("default")
	
	player.movable = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (interactable == true):
		var collidingNode = $Player/RayCast2D.get_collider()
		if collidingNode == question_area:
			handle_popup(question_popup)
		elif collidingNode == notebook_area:
			handle_popup(page)
		elif collidingNode == picture_area:
			handle_popup(picture)
		elif collidingNode == chair_area:
			handle_popup(chair)
		elif collidingNode == coffee_table_area:
			handle_popup(coffee_table)
		elif collidingNode == lady_area:
			handle_popup(lady)
		elif collidingNode == kids_area:
			handle_popup(kids)

func handle_popup(popup_node: Node) -> void:
	if Input.is_action_just_pressed("interact"):
		match popup_node:
			question_popup: 
				question.show()
				validation.hide()
			chair:
				num_opened += 1
				if num_opened % 2 == 0:
					chair_msg.text = "This is... just a chair"
				else:
					chair_msg.text = "It's just a chair..."
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
	$Audio/sfx_correct.play()
	valid_msg.text = "Correct!"
	question.hide()
	validation.show()
	interactable = false
	await get_tree().create_timer(2.0).timeout
	win.emit()
	
func wrong_answer() -> void:
	$Audio/sfx_close.stop()
	$Audio/sfx_close.play()
	valid_msg.text = "Sorry, that is incorrect. Try looking around the room for more hints!"
	question.hide()
	validation.show()

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
