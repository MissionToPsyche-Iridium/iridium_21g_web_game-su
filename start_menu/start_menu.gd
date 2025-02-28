extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Cover.show()
	$ButtonCover.show()
	$Disclaimer.hide()
	$Continue.hide()
	$ContinueCover.color = Color(0, 0, 0, 255)
	$ContinueCover.show()
	$Logo.show()
	await get_tree().create_timer(2.0).timeout      # Wait 2 seconds before covering the Psyche logo
	$AnimationPlayer.play("cover")                  # Cover Psyche logo - "fade to black"
	await get_tree().create_timer(1.0).timeout      # Wait 1 second to let the animation to finish
	$Logo.hide()                                    # Hide the Pysche logo
	$Disclaimer.show()                              # Show the disclaimer 
	$Continue.show()                                # Show continue button 
	await get_tree().create_timer(1.0).timeout      # Wait 1 second
	$AnimationPlayer.play("cover_fade")             # Fade the cover to display the disclaimer 
	await get_tree().create_timer(10.0).timeout     # Wait 10 seconds
	$Cover.hide()                                   # Hide the cover to allow buttons to be pressed 
	$AnimationPlayer.play("continue_fade")          # Fade away the cover over the continue button
	await get_tree().create_timer(1.0).timeout      # Wait 1 second to let the animation to finish 
	$ContinueCover.hide()                           # Hide the cover to allow button to be pressed 
	
func _on_continue_pressed() -> void:                # When the continue button pressed
	$Cover.show()                                   # Show the cover
	$AnimationPlayer.play("cover")                  # Cover the disclaimer - "fade to black"
	await get_tree().create_timer(1.0).timeout      # Wait 1 second to let the animation to finish
	$Disclaimer.hide()
	$Continue.hide()                                # Hide the continue button
	$ButtonCover.hide()                             # Hide the button cover to show the start and credits buttons
	$AnimationPlayer.play("cover_fade")             # Fade the cover 
	await get_tree().create_timer(1.0).timeout      # Wait 1 minute to let the animation finish 
	$Cover.hide()                                   # Hide the cover to allow buttons to be pressed 


func _on_start_pressed() -> void:                   # When the start button is pressed 
	$Cover.show()                                   # Show the cover 
	$AnimationPlayer.play("cover")                  # Cover the start menu - "fade to black"
	await get_tree().create_timer(1.2).timeout      # Wait 1.2 seconds to let the animation finish 
	get_tree().change_scene_to_file("res://scavenger-hunt/world.tscn")   # Change the scence to the scavenger hunt minigame 


func _on_credits_pressed() -> void:                 # When the credits button is pressed 
	$Cover.show()                                   # Show the cover
	$AnimationPlayer.play("cover")                  # Cover the start menu - "fade to black"
	await get_tree().create_timer(1.2).timeout      # Wait 1.2 seconds to let the animation finish 
	get_tree().change_scene_to_file("res://Credits scene/credits.tscn")   # Change the scence to the credits screen 
