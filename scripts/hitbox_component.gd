extends Area3D

class_name HitboxComponent

var parentNode: Node

func _ready():
	parentNode = get_parent()
	
func take_damage(amount):
	if parentNode.health_component != null:
		parentNode.health_component.adjust_health(amount)
