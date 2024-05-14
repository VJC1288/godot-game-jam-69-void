extends Area3D

@onready var mesh_instance_3d = $MeshInstance3D

@export var damage: int

var isLaser:bool = false

func _ready():
	var scale_tween = create_tween()
	scale_tween.tween_property(self, "scale", Vector3(6,6,6), .1)
	
	var alpha_tween = create_tween()
	alpha_tween.tween_property(mesh_instance_3d.mesh.material, "albedo_color", Color(1, 0.271, 0.176, .1), .1)
	await get_tree().create_timer(.1, false).timeout
	queue_free()
