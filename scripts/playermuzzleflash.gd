extends MeshInstance3D

func _ready():
	mesh.material.albedo_color = Color(0.106, 0.345, 1, 1)
	var tween = create_tween()
	tween.tween_property(mesh.material, "albedo_color", Color(0.106, 0.345, 1, 0), .25)
	await get_tree().create_timer(.5).timeout
	queue_free()
