extends Node

var people_array := []

signal person_killed(person)
signal everyone_dead

func _ready():
	people_array = get_tree().get_nodes_in_group("Person")
	
	person_killed.connect(on_person_killed)

func on_person_killed(person):
	person.remove_from_group("Person")

func victory():
	print("we win this level")

func defeat():
	print("we lost this level")

func _on_timer_ui_timer_end_signal():
	defeat()
