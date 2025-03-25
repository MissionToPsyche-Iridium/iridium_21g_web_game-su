extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Audio.play_music_start(-40)
	$Cover.show()
	$ButtonCover.show()
	#$Disclaimer.hide()
	#$Continue.hide()
	#$ContinueCover.color = Color(0, 0, 0, 255)
	#$ContinueCover.show()
	$Logo.show()
	await get_tree().create_timer(2.0).timeout      # Wait 2 seconds before covering the Psyche logo
	Audio.volume_db = -35
	$AnimationPlayer.play("cover")                  # Cover Psyche logo - "fade to black"
	await get_tree().create_timer(1.0).timeout      # Wait 1 second to let the animation to finish
	Audio.volume_db = -30
	$Logo.hide()                                    # Hide the Pysche logo
	$Cover.show()                                   # Show the cover
	$AnimationPlayer.play("cover")                  # Cover the logo - "fade to black"
	await get_tree().create_timer(1.0).timeout      # Wait 1 second to let the animation to finish
	Audio.volume_db = -25
	$ButtonCover.hide()                             # Hide the button cover to show the start and credits buttons
	$AnimationPlayer.play("cover_fade")             # Fade the cover 
	await get_tree().create_timer(1.0).timeout      # Wait 1 minute to let the animation finish 
	Audio.volume_db = -20
	$Cover.hide() 

func _on_start_pressed() -> void:                   # When the start button is pressed 
	Audio.volume_db = -25
	$Cover.show()                                   # Show the cover 
	$AnimationPlayer.play("cover")                  # Cover the start menu - "fade to black"
	await get_tree().create_timer(1.2).timeout      # Wait 1.2 seconds to let the animation finish 
	Audio.volume_db = -30
	get_tree().change_scene_to_file("res://scavenger-hunt/instructions/instructions.tscn")   # Change the scence to the scavenger hunt minigame 
	Audio.stop()

func _on_credits_pressed() -> void:                 # When the credits button is pressed 
	$Cover.show()                                   # Show the cover
	$AnimationPlayer.play("cover")                  # Cover the start menu - "fade to black"
	await get_tree().create_timer(1.2).timeout      # Wait 1.2 seconds to let the animation finish 
	get_tree().change_scene_to_file("res://Credits scene/credits.tscn")   # Change the scence to the credits screen 
