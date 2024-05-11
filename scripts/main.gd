extends Node3D

const PAUSE_MENU = preload("res://scenes/pause_menu.tscn")

@onready var ui_elements = $UIElements

var paused = null

func _input(event):
	if event.is_action_pressed("pause") and paused == null:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		paused = PAUSE_MENU.instantiate()
		ui_elements.add_child(paused)
