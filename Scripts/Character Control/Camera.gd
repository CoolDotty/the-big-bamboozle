extends Node

@export var look_target: Node

func _process(delta):
	self.position = look_target.position

