extends CharacterBody2D

@export var acceleration : float = 800.0
@export var max_speed : float = 250.0
@export var slowdown : float = 400.0   # how fast he slows when not pressing

func _physics_process(delta):

	var input_vector = Vector2.ZERO

	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()
		velocity += input_vector * acceleration * delta
		velocity = velocity.limit_length(max_speed)
	else:
		# Slowly reduce velocity when no input
		velocity = velocity.move_toward(Vector2.ZERO, slowdown * delta)

	move_and_slide()
