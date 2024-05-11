extends Node3D

@onready var world_pivot:Node3D = $WorldPivot
@onready var tilt_pivot = $WorldPivot/TiltPivot

func _physics_process(delta):
	world_pivot.rotation.y += .001
