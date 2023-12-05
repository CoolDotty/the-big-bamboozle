extends RayCast2D

const MODES = preload("res://Scripts/mode_enum.gd")

var unlocked_modes = []
var mode_array = []
var current_mode : int

var hit_point := Vector2()

@export var claw_mode : Node
@export var destroy_mode : Node
@export var build_mode : Node
@export var nail_mode : Node
@export var saw_mode : Node

func _ready():
	#ewwwwww
	mode_array.append(claw_mode)
	mode_array.append(destroy_mode)
	mode_array.append(build_mode)
	mode_array.append(nail_mode)
	mode_array.append(saw_mode)
	
	for mode in mode_array:
		if mode.has_method("disable_mode"):
			mode.disable_mode()

func pickup_mode(new_mode):
	unlocked_modes.append(MODES.GLOBAL_MODES.keys()[new_mode])
	change_mode(new_mode)	

func change_mode(change):
	current_mode = change

	for mode in mode_array:
		if mode.has_method("disable_mode"):
			mode.disable_mode()

	mode_array[current_mode].enable_mode()

func scroll_mode(input):
	if unlocked_modes.size() < 2:
		return

	current_mode += input
	print(current_mode,"  ",unlocked_modes.size())
	if current_mode > unlocked_modes.size() - 1:
		current_mode = 0
	print(current_mode)
	if current_mode < 0:
		current_mode = unlocked_modes.size() - 1
	print(current_mode)
	change_mode(current_mode)

func _process(delta):
	look_at(get_global_mouse_position())
	#no idea why 11 is the magic number, but is just seems to work?...
	self.rotation += 11
	
	if is_colliding():
		hit_point = to_local(get_collision_point())
	else:
		hit_point = Vector2()

	if Input.is_action_just_pressed("input_scroll_down"):
		scroll_mode(-1)

	if Input.is_action_just_pressed("input_scroll_up"):
		scroll_mode(1)
