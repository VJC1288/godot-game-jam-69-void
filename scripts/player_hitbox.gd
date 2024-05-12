extends HitboxComponent

class_name PlayerHitboxComponent

var playerNode: Node

func _ready():
	playerNode = get_parent()
	
func take_damage(amount):
	if playerNode.shield_component != null and playerNode.shield_component.current_shield > 0:
		playerNode.shield_component.adjust_shield(amount)
		print("Shield Hit")
	elif playerNode.hull_component != null:
		playerNode.hull_component.adjust_hull(amount)
		print("Hull Hit")
