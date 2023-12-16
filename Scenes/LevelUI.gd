extends Node


@export var time_limit: float = 50 
@export var timer_panic: float = 5

@onready var RemainingLabel = $Control/RemainingLabel
@onready var TimerLabel = $Control/TimerLabel

@onready var timer_init_position = TimerLabel.position

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.person_killed.connect(on_player_killed)
	GameManager.everyone_dead.connect(on_everyone_dead)
	$LevelTimer.timeout.connect(on_timeout)
	$LevelTimer.wait_time = time_limit
	$LevelTimer.start()
	(func():
		var people_array = get_tree().get_nodes_in_group("Person")
		RemainingLabel.text = str(people_array.size()," targets remain")
	).call_deferred()

func _process(_delta):
	TimerLabel.text = "Time Remaining: {time}".format({ "time": ceil($LevelTimer.time_left) })
	
	if len(get_tree().get_nodes_in_group("Person")) == 1:
		RemainingLabel.position = Vector2(randi_range(0, 4), randi_range(0, 4))
	else:
		RemainingLabel.position = Vector2.ZERO
	
	var remaining = $LevelTimer.time_left
	if remaining < timer_panic and remaining > 0:
		var panic_delta = pow(timer_panic - remaining, 2)
		TimerLabel.position = timer_init_position + Vector2(randi_range(-panic_delta, panic_delta), randi_range(0, panic_delta * 2))
	else:
		TimerLabel.position = timer_init_position

func on_player_killed(person):
	var people_array = get_tree().get_nodes_in_group("Person")
	if people_array.size() == 0:
		RemainingLabel.text = ""
		victory()
	elif people_array.size() == 1:
		RemainingLabel.text = "1 target remains"
	else:
		RemainingLabel.text = str(people_array.size()," targets remain")


func on_everyone_dead():
	victory()


func on_timeout():
	defeat()


func victory():
	$LevelTimer.set_paused(true)
	RemainingLabel.text = "We won the wreckening"


func defeat():
	RemainingLabel.text = "The wreckening has failed"
