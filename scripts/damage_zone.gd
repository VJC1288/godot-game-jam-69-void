extends Area3D



func _on_body_entered(body):

	if body is Player:
		get_tree().call_deferred("reload_current_scene")
	
	elif body is Enemy:
		body.queue_free()
	
	elif body.is_in_group("asteroids"):
		body.queue_free()
	
