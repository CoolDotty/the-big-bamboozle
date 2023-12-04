extends CharacterBody2D


@export_range(100, 1000, 1) var move_speed := 400.0
@export_range(100, 1000, 1) var jump_velocity := 500.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("input_jump") and is_on_floor():
		velocity.y = jump_velocity * -1.0 #invert out positive jump velocity value so we move up

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("input_move_left", "input_move_right")
	if direction:
		velocity.x = direction * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)

	move_and_slide()
