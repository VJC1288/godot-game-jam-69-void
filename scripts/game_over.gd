extends CanvasLayer

signal restart_game()

const STATS = preload("res://scenes/stats.tscn")
var TITLE_SCREEN = load("res://scenes/title_screen.tscn")

@onready var retry = $MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/Retry
@onready var statistics = $MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/Statistics
@onready var energy_loss = $MarginContainer/Panel/MarginContainer/VBoxContainer/EnergyLoss
@onready var return_to_title = $MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/ReturnToTitle

func _ready():
	retry.grab_focus()
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if Globals.endless_mode:
		energy_loss.visible = true
		energy_loss.text = str("Void Energy Collected\n", Globals.current_energy)
	
func _on_retry_pressed():
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	restart_game.emit()
	queue_free()
	
func _on_return_to_title_pressed():
	pass
	get_tree().change_scene_to_packed(TITLE_SCREEN)

func _on_statistics_pressed():
	var stats_scene = STATS.instantiate()
	add_child(stats_scene)
	stats_scene.close_stats.connect(_on_retry_mouse_entered)
	stats_scene.title_label_1.text = "Game Over"
	stats_scene.title_label_2.text = "Final Statistics"

func _on_retry_mouse_entered():
	retry.grab_focus()
	
func _on_return_to_title_mouse_entered():
	return_to_title.grab_focus()
	
func _on_statistics_mouse_entered():
	statistics.grab_focus()
	
func _on_retry_focus_entered():
	GlobalAudioManager.menu_move_sound.play()
	
func _on_return_to_title_focus_entered():
	GlobalAudioManager.menu_move_sound.play()
	
func _on_statistics_focus_entered():
	GlobalAudioManager.menu_move_sound.play()
