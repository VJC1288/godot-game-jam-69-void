extends MeshInstance3D

func _ready():
	mesh.material.albedo_color = Color(0,0,1, .5)
	var tween = create_tween()
	tween.tween_property(mesh.material, "albedo_color", Color(0,0,1, 0), .25)
	await get_tree().create_timer(.5, false).timeout
	queue_free()
