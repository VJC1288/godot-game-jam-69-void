extends Area3D

const GAME_WIN = preload("res://scenes/game_win.tscn")

func _on_body_entered(body):

	if body is Player and body.current_energy < 2500:
		restart_game()
	elif body is Player and body.current_energy >= 2500:
		var win = GAME_WIN.instantiate()
		win.restart_game.connect(restart_game())
		
	elif body is Enemy:

		body.queue_free()
	
	elif body.is_in_group("asteroids"):
		body.queue_free()
	
func restart_game():
	get_tree().call_deferred("reload_current_scene")
