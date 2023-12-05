extends Node2D

var mode_active = false

func disable_mode():
	mode_active = false
	self.visible = false

func enable_mode():
	mode_active = true
	self.visible = true

func _process(delta):
	if not mode_active:
		return 

	#update graphic position
	self.global_position = get_parent().global_position
	self.global_rotation = get_parent().global_rotation

	#oh goddd
	if Input.is_action_just_pressed("input_fire"):
		if get_parent().get_collider() != null:
			if get_parent().get_collider().has_method("destroy"):
				get_parent().get_collider().destroy()

	queue_redraw()

func _draw():
	#I don't like this solution of redrawing every frame just to clear
	#But I'm not sure how to clear everything in _draw, so instead we just draw an "empty" image when not needed
	if get_parent().get_collider() != null:
		if get_parent().get_collider().has_method("destroy"):
			draw_circle(get_parent().hit_point, 10, Color(255, 0, 0))
			return

	#ugly way of just removing the drawn vector if no previous conditions are met
	draw_circle(Vector2(), 0, Color(0, 0, 0))
