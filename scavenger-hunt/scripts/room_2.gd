extends Node2D

signal popup_open
signal popup_close
signal win

var interactable = false
var isOpen = false
var rng = RandomNumberGenerator.new()
var correct

var start_date = { "year": 2023, "month": 10, "day": 13, "weekday": 5, "hour": 10, "minute": 19, "second": 43, "dst": true }   # 3:19pm UTC, +5 10:19am EDT, +8 7:19am PDT, +6 9:19am EST, +9 6:19am PST                  
var time_zone = Time.get_time_zone_from_system()                                                                               # 5:26pm UTC, +5 12:26am EDT, +8 9:26pm PDT, +6 11:26pm EST, +9 8:26pm PST 
var start_unix_time = Time.get_unix_time_from_datetime_dict(start_date)
var current_datetime = Time.get_datetime_dict_from_system()   # UTC time zone
var current_unix_time = Time.get_unix_time_from_datetime_dict(current_datetime)  # Unix time (seconds) in UTC	
var start_zone
var days
var hours
var minutes

var questions_dict = {
	0: ["To what program did the team submit their proposal and concept study?", 
		"NASA's Space Exploration Program", 
		"NASA's Discovery Program", 
		"NASA and Space Discovery Program"],
	1: ["How long ago did the space craft lauch?", 
		"-", 
		"-", 
		"-"],
	2: ["When did the team submit the initial proposal?", 
		"2013", 
		"2009", 
		"2011"],
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var start_utc = start_unix_time
	var current_utc = current_unix_time
	if current_datetime.dst == false:                                           # If not daylight savings
		current_utc = current_unix_time - ((time_zone["bias"] - 60) * 60)       # Add 1 hour to UTC bias to get local no DST
	else:
		current_utc = current_unix_time - ((time_zone["bias"]) * 60)            # Add UTC bias to get local

	start_zone = "Eastern Daylight Time"
	start_utc = start_unix_time + (5 * 60 * 60)                                 # Add 5 hours from EDT to convert to UTC


	var elapsed_seconds = current_utc - start_utc

	# Convert to days, hours, minutes
	days = elapsed_seconds / 86400
	hours = (elapsed_seconds % 86400) / 3600
	minutes = ((elapsed_seconds % 3600) / 60)
	
	questions_dict[1][1] = ("%d days" % [days])
	questions_dict[1][2] = ("%d days" % [(days - 4)])
	questions_dict[1][3] = ("%d days" % [(days + 5)])
	
	var question_number = rng.randi_range(0,2)
	$Question/Question/Question.text = questions_dict[question_number][0]
	$Question/Question/Options/Option1.text = questions_dict[question_number][1]
	$Question/Question/Options/Option2.text = questions_dict[question_number][2]
	$Question/Question/Options/Option3.text = questions_dict[question_number][3]
	
	if question_number == 0:
		correct = 2
	elif question_number == 1:
		correct = 1
	elif question_number == 2:
		correct = 3
		
	$Papers1Description/Container/Message.text = "It's a 256 page proposal that was selected for the concept study."
	$Papers2Description/Container/Message.text = "Wow! It's a 1,000 word concept study submitted for consideration for NASA’s Discovery Program."
	$ShelvesDescription/Container/Message.text = "It's a collection of some of the research the team did. Some of it dates all the way back to 2011 when they submitted the concept study."
	$ComputerDescription/Container/Message.text = "It's the Psyche website. It has a lot of important information"
	
	$Player.movable = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (interactable == true):
		var collidingNode = $Player/RayCast2D.get_collider()
		if collidingNode == $Scientist:
			handle_popup($Question)
		elif collidingNode == $Papers1:
			handle_popup($Papers1Description)
		elif collidingNode == $Papers2:
			handle_popup($Papers2Description)
		elif collidingNode == $Shelves:
			handle_popup($ShelvesDescription)
		elif collidingNode == $ComputerArea:
			handle_popup($ComputerDescription)

func handle_popup(popup_node: Node) -> void:
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
	$Audio/sfx_correct.play()
	$Question/Validation/Message.text = "Correct!"
	$Question/Question.hide()
	$Question/Validation.show()
	interactable = false
	await get_tree().create_timer(2.0).timeout
	win.emit()

func wrong_answer() -> void:
	$Audio/sfx_close.stop()
	$Audio/sfx_close.play()
	$Question/Validation/Message.text = "Sorry, that is incorrect. Try looking around the room for more hints!"
	$Question/Question.hide()
	$Question/Validation.show()
	await get_tree().create_timer(2.0).timeout
	$Question/Validation.hide()
	$Question/Question.show()
	
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
