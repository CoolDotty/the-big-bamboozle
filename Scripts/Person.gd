extends StaticBody2D

var game_manager

func register_manager(manager):
	game_manager = manager

func die():
	game_manager.person_killed(self)
