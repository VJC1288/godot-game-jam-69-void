class_name JuggernautHitboxBottom

extends Area3D

@onready var hull_component_bottom = $"../../HullComponentBottom"


func take_damage(amount):
	if hull_component_bottom != null:
		hull_component_bottom.adjust_hull(amount)
		print("Bottom hit")
