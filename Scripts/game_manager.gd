extends Node

var people_array := []

@export var level_time := 50.0
@export var timer_ui : Node

func _ready():
	people_array = get_tree().get_nodes_in_group("Person")
	
	for person in people_array:
		person.register_manager(self)

	timer_ui.start_timer(level_time)

func person_killed(person):
	var index = people_array.find(person)
	var person_to_kill = people_array[index]
	people_array.remove_at(index)
	person_to_kill.queue_free()

	if people_array.size() == 0:
		timer_ui.target_label.text = ""
		victory()
	elif people_array.size() == 1:
		timer_ui.target_label.text = "1 target remains"
	else:
		timer_ui.target_label.text = str(people_array.size()," targets remain")

func victory():
	timer_ui.timer.set_paused(true)
	print("we win this level")

func defeat():
	print("we lost this level")

func _on_timer_ui_timer_end_signal():
	defeat()
