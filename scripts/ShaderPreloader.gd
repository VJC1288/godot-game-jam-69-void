extends Node3D



func _ready():
	
	get_tree().create_timer(10.0).timeout.connect(delete_shader_preloader)
	
func delete_shader_preloader():
	call_deferred("queue_free")
