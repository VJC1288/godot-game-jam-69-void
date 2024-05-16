extends CanvasLayer

signal restart_game()

@onready var energy_loss = $MarginContainer/Panel/MarginContainer/VBoxContainer/EnergyLoss

func _ready():
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func _on_retry_pressed():
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	restart_game.emit()
	queue_free()

func _on_retry_mouse_entered():
	GlobalAudioManager.menu_move_sound.play()
