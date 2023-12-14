extends StaticBody2D

func _ready():
	self.add_to_group("Person")

func die():
	(func():
		$Sprite2D.modulate = Color.DARK_RED
		$CollisionShape2D.disabled = true
	).call_deferred()
	GameManager.person_killed.emit(self)
	$Death.play()
	$Death.finished.connect(
		func():
			self.queue_free()
	)
