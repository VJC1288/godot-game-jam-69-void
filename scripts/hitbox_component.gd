extends Area3D

class_name HitboxComponent

var parentNode: Node

func _ready():
	parentNode = get_parent()
	
func take_damage(amount):
	if parentNode.hull_component != null:
		parentNode.hull_component.adjust_health(amount)
