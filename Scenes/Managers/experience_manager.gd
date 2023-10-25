extends Node

signal experience_updated(current_experience: float, target_experience: float)

const TARGET_EXPERIENCE_GROWTH = 5

var current_experience = 0
var current_level = 1
var target_experience = 5

func _ready():
	GameEvents.experience_vial_collected.connect(on_experience_vial_collected)

func increment_experience(number: float):
	# this clamps the current_experience to be the minimum value. For example, 
	# if the current_experience is higher than the target_experience, the current_experience
	# value will be target_experience since it will be lower than the number added to 
	# current_experience
	current_experience = min(current_experience + number, target_experience)
	
	experience_updated.emit(current_experience, target_experience)
	
	#this is the game loop when the player levels up
	if current_experience == target_experience:
		current_level+= 1
		target_experience += TARGET_EXPERIENCE_GROWTH
		current_experience = 0
		experience_updated.emit(current_experience, target_experience)

func on_experience_vial_collected(number: float):
	increment_experience(number)
