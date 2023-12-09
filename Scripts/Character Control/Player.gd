extends CharacterBody2D

#movement variables
@export_range(100, 1000, 1) var move_speed := 600.0
@export_range (0, 1.0) var friction := 0.25
@export_range (0, 1.0) var acceleration := 0.25
var direction

#jump variables
@export var jump_height := 400.0  
@export var gravity := 600.0

@export var player_sprite : Sprite2D

func get_move_input():
	direction = Input.get_axis("input_move_left", "input_move_right")


	if direction != 0.0:
		velocity.x = lerp(velocity.x, direction * move_speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)

	#this shouldn't be here, but we are limited on time...
	if direction == 0.0:
		pass
	elif direction < 0:
		player_sprite.set_flip_h(true)
	else:
		player_sprite.set_flip_h(false)

func set_sprite_rotation():
	if get_floor_normal().distance_to(Vector2.UP) > 0.05 :
		player_sprite.rotation = lerp(player_sprite.rotation,get_floor_normal().angle_to(Vector2.UP) * -1,0.25)
	else:
		player_sprite.rotation = 0

func _physics_process(delta):
	#get player move inputs
	get_move_input()

	if Input.is_action_just_pressed("input_jump") and is_on_floor():
		velocity.y = -jump_height

	velocity.y += gravity * delta  # Apply gravity
	
	# Move the player
	move_and_slide()
	#rotate sprite to match floor and move direction
	set_sprite_rotation()

func _on_Floor_hit(velocity):
	if velocity.y > 0:
		velocity.y = 0
		

