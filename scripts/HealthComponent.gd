extends Node

class_name HealthComponent

@export var max_health: int

var current_health
var ownerNode: Node

func _ready():
	current_health = max_health
	ownerNode = get_parent()
	
func adjust_health(adjustment: int):
	if ownerNode is Enemy:
		current_health += adjustment
		if current_health <= 0:
			ownerNode.queue_free()
