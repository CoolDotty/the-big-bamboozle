extends RayCast2D

const MODES = preload("res://Scripts/mode_enum.gd")

var current_mode : int

var hit_point := Vector2()

var can_change_mode := true

func pickup_mode(new_mode):
	#instantiate node as child of self
	var node = new_mode.instantiate()
	#set new mode parent as this object
	self.add_child(node)
	#this covers specifically claw mode, which needs to be able to move the player
	if node.has_method("shoot_claw"):
		node.player_controller = get_parent()

	current_mode = get_child_count()
	print(get_child_count()," ", node)

	#for all child nodes/modes, disable them then re-enable the currently selected mode
	for child in get_children():
		print(child)
		if child.has_method("disable_mode"):
				child.disable_mode()

	node.enable_mode()

func change_mode():
	for child in get_children():
		if child.has_method("disable_mode"):
				child.disable_mode()

	get_child(current_mode).enable_mode()

func scroll_mode(input):
	if get_child_count() < 2:
		return

	$"../SwitchMode".play()
	current_mode += input

	if current_mode > get_child_count() - 1:
		current_mode = 0

	if current_mode < 0:
		current_mode = get_child_count() - 1

	change_mode()

func _process(delta):
	look_at(get_global_mouse_position())
	#no idea why 11 is the magic number, but is just seems to work?...
	self.rotation += 11

	if is_colliding():
		hit_point = to_local(get_collision_point())
	else:
		hit_point = Vector2()

	if Input.is_action_just_pressed("input_scroll_down") and can_change_mode:
		scroll_mode(-1)

	if Input.is_action_just_pressed("input_scroll_up") and can_change_mode:
		scroll_mode(1)

#	for i in len(mode_array):
#		var mode = mode_array[i]
#		if not mode.has_method("disable_mode"): 
#			continue
#		if i == current_mode:
#			mode.call("enable_mode")
#		else:
#			mode.call("disable_mode")
