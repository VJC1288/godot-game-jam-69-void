extends HitboxComponent

class_name PlayerHitboxComponent

var playerNode: Node

func _ready():
	playerNode = get_parent().get_parent()
	
func take_damage(amount):
	print(playerNode)
	if playerNode.hull_component != null:
		playerNode.hull_component.adjust_health(amount)
