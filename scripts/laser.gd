extends Node3D

class_name Laser

@onready var mesh_instance_3d = $MeshInstance3D

@export var damage: int

var isLaser: bool = true

func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()
