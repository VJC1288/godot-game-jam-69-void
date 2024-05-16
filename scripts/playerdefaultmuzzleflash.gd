extends MeshInstance3D

func _ready():
	mesh.radius = .2
	mesh.height = .4
	if Globals.current_player.has_laser_upgrade:
		mesh.radius = .3
		mesh.material.albedo_color = Color(1,1,0, 1)
		mesh.material.emission = Color(1,1,0, 1)
		var height_tween = create_tween()
		height_tween.tween_property(mesh, "height", 3, .25)
		var tween = create_tween()
		tween.tween_property(mesh.material, "albedo_color", Color(1,1,0, 0), .25)
		await get_tree().create_timer(.5, false).timeout
		queue_free()
	else:
		mesh.material.albedo_color = Color(0.106, 0.345, 1, 1)
		mesh.material.emission = Color(0.106, 0.345, 1)
		var tween = create_tween()
		tween.tween_property(mesh.material, "albedo_color", Color(0.106, 0.345, 1, 0), .25)
		await get_tree().create_timer(.5, false).timeout
		queue_free()
