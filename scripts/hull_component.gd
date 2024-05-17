extends Node

class_name HullComponent

signal defeated()

signal hull_changed(new_hull)

@export var max_hull: int

var current_hull
var ownerNode: Node

func _ready():
	current_hull = max_hull
	ownerNode = get_parent()
	hull_changed.emit(current_hull)
	
func adjust_hull(adjustment: int):
	if ownerNode is Enemy:
		current_hull += adjustment
		hull_changed.emit(current_hull)
		if current_hull <= 0:
			defeated.emit()
	elif ownerNode is Player:
		current_hull = clamp(current_hull + adjustment, 0 , max_hull)
		hull_changed.emit(current_hull)
		if adjustment < 0:
			Globals.total_damage_taken += abs(adjustment)
		if current_hull <= 0:
			ownerNode.queue_free()
