extends Node

@export var timer : Timer
@export var label : Label
@export var target_label : Label

signal timer_end_signal

func start_timer(time):
	timer.start(time)

func formatTime(seconds):
	var minutes = (int(seconds) / 60)
	var remainingSeconds = (int(seconds) % 60)

	var formattedTime = str(minutes).pad_zeros(2) + " : " + str(remainingSeconds).pad_zeros(2)

	return formattedTime

func _process(delta):
	label.text = str(formatTime(timer.time_left))

func _on_timer_timeout():
	emit_signal("timer_end_signal")
