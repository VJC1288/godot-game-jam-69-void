extends Area3D

signal game_over(result)


func _on_body_entered(body):

	if body is Player and body.current_energy < 2500:
		game_over.emit("loss")
	elif body is Player and body.current_energy >= 2500:
		game_over.emit("win")
		
	elif body is Enemy:
		body.queue_free()
	
	elif body.is_in_group("asteroids"):
		body.queue_free()
