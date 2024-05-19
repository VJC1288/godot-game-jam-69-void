extends CanvasLayer

signal close_how_to_play()

@onready var back_button = %BackButton

func _input(event):
	if event is InputEventJoypadButton:
		back_button.grab_focus()

func _on_back_button_pressed():
	close_how_to_play.emit()
	queue_free()
	
func _on_back_button_mouse_entered():
	back_button.grab_focus()
	
func _on_back_button_focus_entered():
	GlobalAudioManager.menu_move_sound.play()
