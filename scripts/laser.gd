extends Node3D

class_name Laser

@onready var mesh_instance_3d = $MeshInstance3D

@export var damage: int

var isLaser: bool = true

func _ready():
	await get_tree().create_timer(2).timeout
	queue_free()
