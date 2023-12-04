extends Area2D

var state_active = true

@export var player_controller : Node

@export var item_hold_position : Node

var holding_item = false
var held_item : Node

enum Claw_State {DEFAULT, FIRING, GRAPPLED, HOLDING, TETHERING}
var current_state = Claw_State.DEFAULT

var target_collider

var grapple_hold_position

@export var min_firing_distance := 100.0

@export var firing_speed := 1.5

var t = 0.0
var starting_claw_position = Vector2()
var target_claw_position = Vector2()

var grapple_target = Vector2()
var starting_grapple_position = Vector2()


func _process(delta):
	if not state_active:
		return 

	if holding_item:
		held_item.position = to_global(item_hold_position.position)
		print(self.global_rotation_degrees)

	if current_state == Claw_State.FIRING:
		t += delta * 0.4 * firing_speed
		self.global_position = starting_claw_position.lerp(target_claw_position, t)
	elif current_state == Claw_State.TETHERING:
		t += delta * 0.4
		player_controller.global_position = starting_grapple_position.lerp(grapple_target, t)
		if player_controller.global_position.distance_to(grapple_target) <= 75:
			hit_grapple_point()
	elif current_state == Claw_State.GRAPPLED:
		player_controller.global_position = grapple_hold_position
	else:
		self.global_position = get_parent().global_position
		self.global_rotation = get_parent().global_rotation
		queue_redraw()

	if Input.is_action_just_pressed("input_fire"):
		match current_state:
			Claw_State.DEFAULT:
				shoot_claw()
			Claw_State.FIRING, Claw_State.TETHERING:
				cancel_claw()
			Claw_State.GRAPPLED:
				release_grapple()
			Claw_State.HOLDING:
				throw_held_item()

func shoot_claw():
	if position.distance_to(get_parent().hit_point) >= min_firing_distance:
		t = 0
		current_state = Claw_State.FIRING
		starting_claw_position = self.global_position
		target_claw_position = to_global(get_parent().hit_point)
		if get_parent().get_collider():
			target_collider = get_parent().get_collider()

func target_hit():
	if target_collider.has_method("pickup"):
		grab_item()
	elif target_collider.has_method("grapple"):
		teathering()
	else:
		cancel_claw()

func grab_item():
	held_item = get_parent().get_collider()
	held_item.pickup()
	current_state = Claw_State.HOLDING	
	holding_item = true

func hit_grapple_point():
	current_state = Claw_State.GRAPPLED	
	grapple_hold_position = player_controller.global_position

func teathering():
	t = 0
	current_state = Claw_State.TETHERING	
	starting_grapple_position = player_controller.global_position
	var offset = starting_grapple_position - to_global(get_parent().hit_point)
	grapple_target = player_controller.global_position - offset * 0.5

func cancel_claw():
	self.global_position = get_parent().global_position
	current_state = Claw_State.DEFAULT	

func throw_held_item():
	held_item.throw(5.0)
	current_state = Claw_State.DEFAULT	
	holding_item = false

func release_grapple():
	print("let go")
	current_state = Claw_State.DEFAULT	

func _draw():
	#I don't like this solution of redrawing every frame just to clear
	#But I'm not sure how to clear everything in _draw, so instead we just draw an "empty" image when not needed
	if get_parent().is_colliding() and current_state != Claw_State.FIRING:
		if global_position.distance_to(get_parent().get_collision_point()) >= min_firing_distance:
			if get_parent().get_collider().has_method("pickup"):
				draw_circle(get_parent().hit_point, 10, Color(0, 255, 0))
			elif get_parent().get_collider().has_method("grapple"):
				draw_circle(get_parent().hit_point, 10, Color(0, 0, 255))
			else:
				draw_circle(get_parent().hit_point, 10, Color(255, 255, 0))
		else:
			draw_circle(get_parent().hit_point, 10, Color(255, 0, 0))
		return

	#ugly way of just removing the drawn vector if no previous conditions are met
	draw_circle(Vector2(), 0, Color(0, 0, 0))

func _on_body_entered(body):
	if body == target_collider:
		target_hit()
