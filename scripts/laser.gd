extends Node3D

class_name Laser

@export var damage: int

var isLaser: bool = true

func _ready():
	await get_tree().create_timer(2, false).timeout
	queue_free()

func _on_accuracy_boxes_area_entered(area):
	var target = area.get_parent()
	if target is Enemy and !Globals.current_player.has_laser_upgrade:
		Globals.shots_hit += 1
