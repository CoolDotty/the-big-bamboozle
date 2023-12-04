extends RayCast2D

var hit_point := Vector2()

func _process(delta):
	look_at(get_global_mouse_position())
	#no idea why 11 is the magic number, but is just seems to work?...
	self.rotation += 11
	
	if is_colliding():
		hit_point = to_local(get_collision_point())
	else:
		hit_point = Vector2()
