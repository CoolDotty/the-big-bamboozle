extends Node2D

const GHOST_PLANK = preload("res://assets/Nodes/Player Nodes/ghost_plank.tscn")
const PLANK = preload("res://assets/Nodes/Player Nodes/wooden_plank.tscn")

var current_held_plank
var active_ghost

var mode_active = false

var holding_build = false

var scene_root

func _ready():
	scene_root = get_tree().get_root().get_node("Scene Root") 

func disable_mode():
	mode_active = false
	self.visible = false
	get_tree().call_group("active_ghosts", "queue_free")

func enable_mode():
	if mode_active:
		return
	mode_active = true
	self.visible = true
	active_ghost = GHOST_PLANK.instantiate()
	scene_root.add_child(active_ghost)
	active_ghost.add_to_group("active_ghosts")
	active_ghost.global_position = get_global_mouse_position()

func _process(delta):
	if not mode_active:
		return 

	#update graphic position
	self.global_position = get_parent().global_position
	self.global_rotation = get_parent().global_rotation
	
	#have our outline follow our mouse
	active_ghost.global_position = get_global_mouse_position()

	#if we are not overlapping and click, spawn the block
	if Input.is_action_just_pressed("input_fire") and active_ghost.get_overlapping_bodies().size() == 0:
		current_held_plank = PLANK.instantiate()
		scene_root.add_child(current_held_plank)
		current_held_plank.global_position = active_ghost.global_position
		current_held_plank.rotation_degrees =  active_ghost.rotation_degrees
		
	#rotate the block 90deg
	if Input.is_action_just_pressed("input_fire_2"):
		if active_ghost.rotation_degrees == 90:
			active_ghost.rotation_degrees = 0
		else:
			active_ghost.rotation_degrees = 90

	#change the color of our ghost block if we are/are not overlapping anything
	if(active_ghost.get_overlapping_bodies().size() == 0):
		active_ghost.get_child(1).modulate = Color(1, 1, 1, 1)
	else:
		active_ghost.get_child(1).modulate = Color(1, 0, 0, 1)
