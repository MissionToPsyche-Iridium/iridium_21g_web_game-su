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
	
	#print("bias: %d" % time_zone["bias"])
	#
	#print("start in UTC: %d" % start_unix_time)
	#print("start: " + str(Time.get_datetime_string_from_unix_time(start_unix_time, true)) + " " + start_zone)
	#print("start: " + str(Time.get_datetime_string_from_unix_time(start_utc, true)) + " UTC")
	#
	#print("current in UTC: %d" % current_unix_time)
	#print("curent: " + str(Time.get_datetime_string_from_unix_time(current_unix_time, true)) + " " + str(time_zone["name"]))
	#print("curent: " + str(Time.get_datetime_string_from_unix_time(current_utc, true)) + " UTC")
	#
	
	#print("Elapsed time: %d days, %d hours, %d minutes" % [days, hours, minutes])
	
	questions_dict[1][1] = ("%d days, %d hours, %d minutes" % [days, hours, minutes])
	questions_dict[1][2] = ("%d days, %d hours, %d minutes" % [(days - 4), hours, minutes])
	questions_dict[1][3] = ("%d days, %d hours, %d minutes" % [(days + 5), hours, minutes])
	
	var question_number = rng.randi_range(0,1)
	$Question/PanelContainer/Question/Question.text = questions_dict[question_number][0]
	$Question/PanelContainer/Question/Option1.text = questions_dict[question_number][1]
	$Question/PanelContainer/Question/Option2.text = questions_dict[question_number][2]
	$Question/PanelContainer/Question/Option3.text = questions_dict[question_number][3]
	
	if (question_number == 0):
		correct = 2
	else:
		correct = 1
		
	$Papers1Description/PanelContainer/Description/Message.text = "It's a 256 page proposal that was selected for the concept study."
	$Papers2Description/PanelContainer/Description/Message.text = "Wow! It's a 1,000 word concept study submitted for consideration for NASA’s Discovery Program."
	$ShelvesDescription/PanelContainer/Description/Message.text = "It's a collection of some of the research the team did. Some of it dates all the way back to 2011."
	$ComputerDescription/PanelContainer/Description/Message.text = "It's the Psyche website. It has a lot of important information"
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
		if (collidingNode == $ShelvesArea):
			if Input.is_action_just_pressed("interact"):
				$ShelvesDescription.show()
				if (!isOpen): $Audio/sfx_open.play()
				isOpen = true
				popup_open.emit()
			if Input.is_action_just_pressed("ui_accept") || Input.is_action_just_pressed("ui_cancel"):
				$ShelvesDescription.hide()
				if (isOpen): $Audio/sfx_close.play()
				isOpen = false
				popup_close.emit()
		if (collidingNode == $Papers1Area):
			if Input.is_action_just_pressed("interact"):
				$Papers1Description.show()
				if (!isOpen): $Audio/sfx_open.play()
				isOpen = true
				popup_open.emit()
			if Input.is_action_just_pressed("ui_accept") || Input.is_action_just_pressed("ui_cancel"):
				$Papers1Description.hide()
				if (isOpen): $Audio/sfx_close.play()
				isOpen = false
				popup_close.emit()
		if (collidingNode == $Papers2Area):
			if Input.is_action_just_pressed("interact"):
				$Papers2Description.show()
				if (!isOpen): $Audio/sfx_open.play()
				isOpen = true
				popup_open.emit()
			if Input.is_action_just_pressed("ui_accept") || Input.is_action_just_pressed("ui_cancel"):
				$Papers2Description.hide()
				if (isOpen): $Audio/sfx_close.play()
				isOpen = false
				popup_close.emit()
		if (collidingNode == $ComputerArea):
			if Input.is_action_just_pressed("interact"):
				$ComputerDescription.show()
				if (!isOpen): $Audio/sfx_open.play()
				isOpen = true
				popup_open.emit()
			if Input.is_action_just_pressed("ui_accept") || Input.is_action_just_pressed("ui_cancel"):
				$ComputerDescription.hide()
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
