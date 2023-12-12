extends StaticBody2D


func die():
	print(self, " has died")
	self.queue_free()
