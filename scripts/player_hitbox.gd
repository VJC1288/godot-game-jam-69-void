extends HitboxComponent

class_name PlayerHitboxComponent

var playerNode: Node
var spilldamage:int

func _ready():
	playerNode = get_parent()
	
func take_damage(amount):
	if playerNode.shield_component != null and playerNode.shield_component.current_shield > 0:
		spilldamage = amount + playerNode.shield_component.current_shield
		playerNode.shield_component.adjust_shield(amount)
		playerNode.shield_effect()
		if spilldamage < 0:
			playerNode.hull_component.adjust_hull(spilldamage)
	elif playerNode.hull_component != null:
		playerNode.hull_component.adjust_hull(amount)
	#print("Shield: ", playerNode.shield_component.current_shield)
	#print("Hull: ", playerNode.hull_component.current_hull)
