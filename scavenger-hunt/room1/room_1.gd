extends Node2D

signal popup_open
signal popup_close

var interactable = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PopUp.hide()
	$Label.hide()
	$PopUp/PanelContainer/Question/Question.text = "What day did the Psyche spacecraft launch?"
	$PopUp/PanelContainer/Question/Option1.text = "Friday, October 13, 2023"
	$PopUp/PanelContainer/Question/Option2.text = "Friday, October 25, 2022"
	$PopUp/PanelContainer/Question/Option3.text = "Friday, Octboer 18, 2023"
	$PopUp/PanelContainer/Validation.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (interactable == true):
		if Input.is_action_just_pressed("interact"):
			$PopUp/PanelContainer/Question.show()
			$PopUp/PanelContainer/Validation.hide()
			$PopUp.show()
			popup_open.emit()
		if Input.is_action_just_pressed("ui_accept") || Input.is_action_just_pressed("close"):
			$PopUp/PanelContainer/Question.show()
			$PopUp/PanelContainer/Validation.hide()
			$PopUp.hide()
			popup_close.emit()


func _on_reception_question_body_entered(body: Node2D) -> void:
	interactable = true
	$Label.show()
	print("in here")
	

func _on_reception_question_body_exited(body: Node2D) -> void:
	interactable = false
	$Label.hide()
	print("out of here")


func _on_pop_up_option_1() -> void:
	$PopUp/PanelContainer/Validation/Message.text = "Correct!"
	#$PopUp/PanelContainer/Validation/Message.PRESET_CENTER
	$PopUp/PanelContainer/Question.hide()
	$PopUp/PanelContainer/Validation/GoBack.hide()
	$PopUp/PanelContainer/Validation.show()
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("cut_scene_1.tscn")

func _on_pop_up_option_2() -> void:
	$PopUp/PanelContainer/Validation/Message.text = "Sorry, that is incorrect. Try looking around the room for more hints!"
	$PopUp/PanelContainer/Question.hide()
	$PopUp/PanelContainer/Validation.show()

func _on_pop_up_option_3() -> void:
	$PopUp/PanelContainer/Validation/Message.text = "Sorry, that is incorrect. Try looking around the room for more hints!"
	$PopUp/PanelContainer/Question.hide()
	$PopUp/PanelContainer/Validation.show()
	
func _on_pop_up_go_back() -> void:
	$PopUp/PanelContainer/Validation.hide()
	$PopUp/PanelContainer/Question.show()


func _on_player_interact() -> void:
	interactable = true
	$Label.show()
	#print("in here")


func _on_player_no_interact() -> void:
	interactable = false
	$Label.hide()
	#print("out of here")
