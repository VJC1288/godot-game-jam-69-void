extends CanvasLayer

signal close_how_to_play()

@onready var back_button = $MarginContainer/Panel/MarginContainer/VBoxContainer/BackButton

func _ready():
	back_button.grab_focus()

func _on_back_button_pressed():
	close_how_to_play.emit()
	queue_free()
	
func _on_back_button_mouse_entered():
	back_button.grab_focus()
	
func _on_back_button_focus_entered():
	GlobalAudioManager.menu_move_sound.play()
