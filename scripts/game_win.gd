extends CanvasLayer

signal restart_game()

const STATS = preload("res://scenes/stats.tscn")
var TITLE_SCREEN = load("res://scenes/title_screen.tscn")

@onready var replay = $MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/Replay
@onready var statistics = $MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/Statistics
@onready var return_to_title = $MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/ReturnToTitle
@onready var easter_egg = $MarginContainer/Panel/MarginContainer/VBoxContainer/EasterEgg

func _ready():
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	replay.grab_focus()
	
func _on_replay_pressed():
	get_tree().paused = false
	restart_game.emit()
	
func _on_return_to_title_pressed():
	get_tree().change_scene_to_packed(TITLE_SCREEN)
	
func _on_statistics_pressed():
	var stats_scene = STATS.instantiate()
	add_child(stats_scene)
	stats_scene.close_stats.connect(_on_replay_mouse_entered)
	stats_scene.title_label_1.text = "You win!"
	stats_scene.title_label_2.text = "Final Statistics"

func _on_replay_mouse_entered():
	replay.grab_focus()

func _on_return_to_title_mouse_entered():
	return_to_title.grab_focus()

func _on_statistics_mouse_entered():
	statistics.grab_focus()

func _on_replay_focus_entered():
	GlobalAudioManager.menu_move_sound.play()
	
func _on_return_to_title_focus_entered():
	GlobalAudioManager.menu_move_sound.play()
	
func _on_statistics_focus_entered():
	GlobalAudioManager.menu_move_sound.play()

func _on_easter_egg_mouse_entered():
	easter_egg.text = "...Or has it?"

func _on_easter_egg_mouse_exited():
	easter_egg.text = ""
