extends Node2D

var state_active = true

var shooting_claw = false

@export var player_controller : Node

@export var item_hold_position : Node

var holding_item = false
var held_item : Node

enum Claw_State {DEFAULT, FIRING, GRAPPLED, HOLDING, TETHERING}
var current_state = Claw_State.DEFAULT

@export var min_firing_distance := 100.0

@export var firing_speed := 600.0

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

	if current_state == Claw_State.TETHERING:
		print("wer flying")
		t += delta * 0.4
		player_controller.position = starting_grapple_position.lerp(grapple_target, t)

	queue_redraw()

	if Input.is_action_just_pressed("input_fire"):
		match current_state:
			Claw_State.DEFAULT:
				shoot_claw()
			Claw_State.FIRING:
				cancel_claw()
			Claw_State.GRAPPLED:
				release_grapple()
			Claw_State.HOLDING:
				throw_held_item()


func shoot_claw():
	if position.distance_to(get_parent().hit_point) >= min_firing_distance:
		current_state = Claw_State.FIRING
		starting_claw_position = self.position
		target_claw_position = get_parent().hit_point
		shooting_claw = true		
		
		#for testing lets just hit what ever we look at
		target_hit()

func target_hit():
	if get_parent().get_collider().has_method("pickup"):
		grab_item()
	elif get_parent().get_collider().has_method("grapple"):
		teathering()
	else:
		cancel_claw()

func grab_item():
	held_item = get_parent().get_collider()
	held_item.pickup()
	current_state = Claw_State.HOLDING	
	holding_item = true

func teathering():
	current_state = Claw_State.TETHERING	
	starting_grapple_position = player_controller.global_position
	grapple_target = to_global(get_parent().hit_point)

func cancel_claw():
	print("claw canceled")
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
	if get_parent().is_colliding():
		if position.distance_to(get_parent().hit_point) >= min_firing_distance:
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
	draw_circle(Vector2(), 0, Color(255, 255, 0))
