extends Node3D

@onready var world_pivot:Node3D = $WorldPivot
@onready var laser = $WorldPivot/Laser

@export var FALL_SPEED = 10
@export var ORBIT_SPEED = .1

func _physics_process(delta):
	
	rotation.y += ORBIT_SPEED * delta
	position.z += FALL_SPEED * delta
