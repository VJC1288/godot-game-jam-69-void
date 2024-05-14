class_name JuggernautHitboxTop

extends Node3D

@onready var hull_component_top = $"../HullComponentTop"
@onready var hull_component_bottom = $"../HullComponentBottom"

func _on_top_hit_box_area_entered(area):
	print("Top hit")
	if area.get_parent().isLaser:
		hull_component_top.adjust_hull(area.damage)
		print("Top hit")

func _on_bottom_hit_box_area_entered(area):
	if area.get_parent().isLaser:
		hull_component_bottom.adjust_hull(area.damage)
		print("Bottom hit")
