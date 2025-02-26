extends Node2D


signal popup_open
signal popup_close

signal win


var interactable = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Question/PanelContainer/Question/Question.text = "What program did the team submit their proposal and concept study?"
	$Question/PanelContainer/Question/Option1.text = "NASA's Space Exploration Program"
	$Question/PanelContainer/Question/Option2.text = "NASA's Discovery Program"
	$Question/PanelContainer/Question/Option3.text = "NASA and Space Discovery Program"
	$Papers1Description/PanelContainer/Description/Message.text = "It's a 256 page proposal that was selected for the concept study."
	$Papers2Description/PanelContainer/Description/Message.text = "Wow! It's a 1,000 word concept study submitted for consideration for NASA’s Discovery Program."
	$ShelvesDescription/PanelContainer/Description/Message.text = "It's a collection of some of the research the team did. Some of it dates all the way back to 2011."
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
		if (collidingNode == $ShelvesArea):
			if Input.is_action_just_pressed("interact"):
				$ShelvesDescription.show()
				popup_open.emit()
			if Input.is_action_just_pressed("ui_accept") || Input.is_action_just_pressed("ui_cancel"):
				$ShelvesDescription.hide()
				popup_close.emit()
		if (collidingNode == $Papers1Area):
			if Input.is_action_just_pressed("interact"):
				$Papers1Description.show()
				popup_open.emit()
			if Input.is_action_just_pressed("ui_accept") || Input.is_action_just_pressed("ui_cancel"):
				$Papers1Description.hide()
				popup_close.emit()
		if (collidingNode == $Papers2Area):
			if Input.is_action_just_pressed("interact"):
				$Papers2Description.show()
				popup_open.emit()
			if Input.is_action_just_pressed("ui_accept") || Input.is_action_just_pressed("ui_cancel"):
				$Papers2Description.hide()
				popup_close.emit()

func _on_question_option_1() -> void:
	$Question/PanelContainer/Validation/Message.text = "Sorry, that is incorrect. Try looking around the room for more hints!"
	$Question/PanelContainer/Question.hide()
	$Question/PanelContainer/Validation.show()

func _on_question_option_2() -> void:
	$Question/PanelContainer/Validation/Message.text = "Correct!"
	$Question/PanelContainer/Question.hide()
	$Question/PanelContainer/Validation.show()
	await get_tree().create_timer(2.0).timeout
	win.emit()

func _on_question_option_3() -> void:
	$Question/PanelContainer/Validation/Message.text = "Sorry, that is incorrect. Try looking around the room for more hints!"
	$Question/PanelContainer/Question.hide()
	$Question/PanelContainer/Validation.show()

func _on_player_interact() -> void:
	interactable = true
	if ($Player/RayCast2D.is_colliding()):
		$Player/PressE.show()

func _on_player_no_interact() -> void:
	interactable = false
	$Player/PressE.hide()
