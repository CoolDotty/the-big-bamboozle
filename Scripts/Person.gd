extends StaticBody2D

func _ready():
	self.add_to_group("Person")

func die():
	GameManager.person_killed.emit(self)
