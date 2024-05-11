extends Node3D

@onready var world_pivot:Node3D = $WorldPivot

@export var FALL_SPEED = .3
@export var ORBIT_SPEED = 3

func _physics_process(delta):
	
	world_pivot.rotation.y += ORBIT_SPEED
	position.z += FALL_SPEED
