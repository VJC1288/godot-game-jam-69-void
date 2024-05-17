extends CanvasLayer

signal restart_game()

const STATS = preload("res://scenes/stats.tscn")

@onready var retry = $MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/Retry
@onready var statistics = $MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/Statistics
@onready var energy_loss = $MarginContainer/Panel/MarginContainer/VBoxContainer/EnergyLoss

func _ready():
	retry.grab_focus()
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func _on_retry_pressed():
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	restart_game.emit()
	queue_free()

func _on_statistics_pressed():
	var stats_scene = STATS.instantiate()
	add_child(stats_scene)
	stats_scene.close_stats.connect(_on_retry_mouse_entered)
	stats_scene.title_label_1.text = "Game Over"
	stats_scene.title_label_2.text = "Final Statistics"

func _on_retry_mouse_entered():
	retry.grab_focus()
	
func _on_statistics_mouse_entered():
	statistics.grab_focus()
	
func _on_retry_focus_entered():
	GlobalAudioManager.menu_move_sound.play()

func _on_statistics_focus_entered():
	GlobalAudioManager.menu_move_sound.play()
