extends CanvasLayer

signal unpause()

const HOW_TO_PLAY = preload("res://scenes/how_to_play.tscn")

@onready var resume = $MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/Resume
@onready var how_to_play = $MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/HowToPlay

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

func _on_how_to_play_pressed():
	var how_to_play_scene = HOW_TO_PLAY.instantiate()
	how_to_play_scene.close_how_to_play.connect(takeFocus)
	add_child(how_to_play_scene)

func takeFocus():
	resume.grab_focus()

func _on_resume_mouse_entered():
	resume.grab_focus()
	
func _on_how_to_play_mouse_entered():
	how_to_play.grab_focus()
