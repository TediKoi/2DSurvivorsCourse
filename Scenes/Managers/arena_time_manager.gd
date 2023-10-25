extends Node

@onready var timer = $Timer

func get_time_elapsed():
	# get the remaining time left
	return timer.wait_time - timer.time_left
