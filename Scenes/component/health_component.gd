extends Node
class_name HealthComponent

@export var max_health: float = 10
var current_health

signal died

func _ready():
	current_health = max_health

func damage(damage_amount: float):
	# ensures that health never drops below zero
	current_health = max(current_health - damage_amount, 0);
	# call_deferred is when the function gets called at the last frame
	Callable(check_death).call_deferred()

func check_death():
	if current_health == 0:
		died.emit()
		# owner is whoever is the parent of the child. 
		owner.queue_free()
