extends CanvasLayer

signal unpause()

const HOW_TO_PLAY = preload("res://scenes/how_to_play.tscn")
const STATS = preload("res://scenes/stats.tscn")

@onready var resume = %Resume
@onready var how_to_play = %HowToPlay
@onready var statistics = %Statistics
@onready var main_container = $MainContainer
@onready var ship_upgrades = $MainContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer2/ShipUpgrades
@onready var rvc_icon = $MainContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer/RVCIcon
@onready var beam_eff_icon = $MainContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer/BeamEffIcon
@onready var t_laser_icon = $MainContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer/TLaserIcon
@onready var rvc_text = $MainContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/RVCText
@onready var beam_eff_text = $MainContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/BeamEffText
@onready var t_laser_text = $MainContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/TLaserText

var upgrade_count:int = 0


func _ready():
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	resume.grab_focus()
	checkBuffs()
	
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

func _on_statistics_pressed():
	var stats_scene = STATS.instantiate()
	stats_scene.close_stats.connect(takeFocus)
	add_child(stats_scene)

func takeFocus():
	resume.grab_focus()

func _on_resume_mouse_entered():
	resume.grab_focus()

func _on_how_to_play_mouse_entered():
	how_to_play.grab_focus()
	
func _on_statistics_mouse_entered():
	statistics.grab_focus()

func _on_resume_focus_entered():
	GlobalAudioManager.menu_move_sound.play()
	
func _on_how_to_play_focus_entered():
	GlobalAudioManager.menu_move_sound.play()
	
func _on_statistics_focus_entered():
	GlobalAudioManager.menu_move_sound.play()

func checkBuffs():
	if Globals.current_player.has_reserve_cell:
		upgrade_count += 1
		ship_upgrades.visible = true
		rvc_icon.visible = true
		rvc_text.visible = true
		
	if Globals.current_player.has_laser_efficiency:
		upgrade_count += 1
		ship_upgrades.visible = true
		beam_eff_icon.visible = true
		beam_eff_text.visible = true
		
	if Globals.current_player.has_laser_upgrade:
		upgrade_count += 1
		ship_upgrades.visible = true
		t_laser_icon.visible = true
		t_laser_text.visible = true

	if upgrade_count == 3:
		main_container.add_theme_constant_override("margin_top", 190)
		main_container.add_theme_constant_override("margin_bottom", 190)
