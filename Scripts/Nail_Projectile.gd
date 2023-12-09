extends Area2D

var projectile_speed := 600.0

func _process(delta):
	var forward_vector = Vector2(cos(rotation), sin(rotation))
	var translation = forward_vector * projectile_speed * delta
	translate(translation)

func _on_body_entered(body):
	if body.is_in_group("Player") or body.is_in_group("PassThrough"):
		pass
	elif body.is_in_group("Person"):
		print(body," kill this target")
		destroy_self()
	else:
		destroy_self()
		
func destroy_self():
	self.queue_free()
