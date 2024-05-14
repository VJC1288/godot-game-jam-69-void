class_name JuggernautHitboxTop

extends Area3D

@onready var hull_component_top = $"../../HullComponentTop"

func take_damage(amount):
	if hull_component_top != null:
		hull_component_top.adjust_hull(amount)
		print("Top hit")
