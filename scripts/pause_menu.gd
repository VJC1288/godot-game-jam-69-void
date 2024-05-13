extends CanvasLayer

signal unpause()

@onready var resume = $MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/Resume

func _ready():
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	resume.grab_focus()
	
func _input(event):
	if event.is_action_pressed("pause"):
		get_tree().paused = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		queue_free()
	if event.is_action_pressed("debugquit") and !OS.has_feature("web"):
		get_tree().quit()

func _on_resume_pressed():
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	queue_free()
