extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 300.0



func _physics_process(delta: float) -> void:
	# Add the gravity.


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED

		if direction > 0:
			animated_sprite.flip_h = false
		elif direction < 0:
			animated_sprite.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	var verDirection := Input.get_axis("move_up", "move_down")
	if verDirection:
		velocity.y = verDirection * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	if (direction == 0 && verDirection == 0):
		animated_sprite.play("idle")
	else:
		animated_sprite.play("run")
	move_and_slide()
