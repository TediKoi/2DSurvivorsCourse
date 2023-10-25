extends Node

const MAX_RANGE = 150

#this is how you use the sword_ability scene for runtime
@export var sword_ability: PackedScene #PackedScene means the type of variable 'sword_ability' will be
var damage = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.timeout.connect(on_timer_timeout) # this is 'get_node("Timer")'


func on_timer_timeout():
	#gets the player variable and checks if player is null.
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if(player == null):
		return
	
	# gets all enemies that are in group 'enemy' and return all the enemies that are closest to
	# the player at a MAX_RANGE of 150. 
	var enemies = get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(func(enemy: Node2D): 
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2)
	)
	
	# returns nothing if there are no enemies
	if(enemies.size() == 0):
		return
	
	# This sorts all enemy distances from the player. It goes in ascending order. Lowest to Greatest.
	enemies.sort_custom(func(a: Node2D, b: Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance
	)

	# instantiate sword_ability at first enemy in the sorted enemy array
	var sword_instance = sword_ability.instantiate() as SwordAbility
	player.get_parent().add_child(sword_instance)
	sword_instance.hitbox_component.damage = damage
	
	sword_instance.global_position = enemies[0].global_position
	# this gives the sword a random offset when instantiated. TAU is a constant that represents 2 * pi.
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
	
	# this gets the enemy direction so that the sword can face the enemy at a different angle
	var enemy_direction = enemies[0].global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()
	
	
	
