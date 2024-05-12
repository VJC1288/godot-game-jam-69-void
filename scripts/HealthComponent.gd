extends Node

class_name HullComponent

signal hull_changed(new_hull)

@export var max_hull: int

var current_hull
var ownerNode: Node

func _ready():
	current_hull = max_hull
	ownerNode = get_parent()
	hull_changed.emit(current_hull)
	
func adjust_health(adjustment: int):
	if ownerNode is Enemy:
		current_hull += adjustment
		if current_hull <= 0:
			ownerNode.queue_free()
	elif ownerNode is Player:
		current_hull = clamp(current_hull + adjustment, 0 , max_hull)
		hull_changed.emit(current_hull)
		print(current_hull)
