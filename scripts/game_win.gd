extends CanvasLayer

signal restart_game()

@onready var replay = $MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/Replay

func _ready():
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	replay.grab_focus()
	
func _on_replay_pressed():
	get_tree().paused = false
	restart_game.emit()

func _on_replay_mouse_entered():
	GlobalAudioManager.menu_move_sound.play()
