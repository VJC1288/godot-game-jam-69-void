extends CanvasLayer

signal restart_game()

const STATS = preload("res://scenes/stats.tscn")

@onready var replay = $MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/Replay
@onready var statistics = $MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/Statistics

func _ready():
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	replay.grab_focus()
	
func _on_replay_pressed():
	get_tree().paused = false
	restart_game.emit()
	
func _on_statistics_pressed():
	var stats_scene = STATS.instantiate()
	add_child(stats_scene)
	stats_scene.close_stats.connect(_on_replay_mouse_entered)
	stats_scene.title_label1.text = "You win!"
	stats_scene.title_label2.text = "Final Statistics"
	
func _on_replay_mouse_entered():
	replay.grab_focus()

func _on_replay_focus_entered():
	GlobalAudioManager.menu_move_sound.play()
	
func _on_statistics_mouse_entered():
	statistics.grab_focus()
	
func _on_statistics_focus_entered():
	GlobalAudioManager.menu_move_sound.play()
