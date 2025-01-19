extends CharacterBody2D

const SPEED: float = 200.0

func _physics_process(_delta):
	#print("Movement running")
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up" , "ui_down")
	#print("Direction:", direction)
	direction = Vector2(-direction.x, -direction.y)  # inverts controls (up is down left is right)
	velocity = direction * SPEED
	#print("Velocity:", velocity)

	move_and_slide()
	#if $hitbox.get_overlapping_bodies():
		#print("Overlapping bodies:", $hitbox.get_overlapping_bodies())
