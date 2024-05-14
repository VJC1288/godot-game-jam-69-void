extends Area3D

@onready var mesh_instance_3d = $MeshInstance3D

@export var damage: int

var isLaser:bool = false
var explosion_time: = 3.0
var fade_time: = 0.1

func _ready():
	
	var scale_tween = create_tween()
	scale_tween.tween_property(self, "scale", Vector3(15,15,15), explosion_time)
	
	var alpha_tween = create_tween()
	alpha_tween.tween_property(mesh_instance_3d.mesh.material, "albedo_color", Color(1, 0.271, 0.176, .5), explosion_time)
	alpha_tween.tween_property(mesh_instance_3d.mesh.material, "albedo_color", Color(1, 0.271, 0.176, 0), fade_time)
	

	get_tree().create_timer(explosion_time+fade_time, false).timeout.connect(destroy_pickup)
	
func destroy_pickup():
	queue_free()
