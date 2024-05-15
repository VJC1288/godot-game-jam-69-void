extends Area3D

@onready var main = $"../../.."

const GAME_WIN = preload("res://scenes/game_win.tscn")

func _on_body_entered(body):

	if body is Player and body.current_energy < 2500:
		main.restart_game()
	elif body is Player and body.current_energy >= 2500:
		var win = GAME_WIN.instantiate()
		add_child(win)
		win.restart_game.connect(main.restart_game())
		
	elif body is Enemy:

		body.queue_free()
	
	elif body.is_in_group("asteroids"):
		body.queue_free()
