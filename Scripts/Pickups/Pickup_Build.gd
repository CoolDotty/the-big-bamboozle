extends Area2D

const MODES = preload("res://Scripts/mode_enum.gd")

const BUILD_MODE = preload("res://assets/Nodes/Player Nodes/Player Mode Nodes/build_mode.tscn")

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	#not the best way of doing this...
	if body.has_node("Mode Container"):
		var mode_container = body.get_node("Mode Container")
		mode_container.pickup_mode(BUILD_MODE)
		self.queue_free()
