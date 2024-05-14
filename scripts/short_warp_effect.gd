extends MeshInstance3D

func _ready():
	await get_tree().create_timer(.16, false).timeout
	queue_free()
