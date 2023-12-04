extends RigidBody2D

func pickup():
	get_node("CollisionShape2D").disabled = true
	

func throw(force):
	get_node("CollisionShape2D").disabled = false
	self.position *= 1.005
	#add throw force to box
