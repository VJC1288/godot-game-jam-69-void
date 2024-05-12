extends Node3D

const PLAYER = preload("res://scenes/player.tscn")
const PAUSE_MENU = preload("res://scenes/pause_menu.tscn")

@onready var ui_elements = $UIElements
@onready var orbiter_manager = $OrbiterManager
@onready var player_laser_container = $OrbiterManager/PlayerLaserContainer
@onready var enemy_attacks_container = $OrbiterManager/EnemyAttacksContainer
@onready var hud = $UIElements/HUD

var paused = null


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	spawn_player()

func spawn_player():
	var player = PLAYER.instantiate()
	player.fireLaser.connect(orbiter_manager.spawn_player_laser)
	player.player_hull_changed.connect(update_hull_bar)
	orbiter_manager.player_container.add_child(player)
	orbiter_manager.camera_pivot.add_child(player)
	orbiter_manager.current_player = player
	Globals.current_player = player

func _input(event):
	if event.is_action_pressed("pause") and paused == null:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		paused = PAUSE_MENU.instantiate()
		ui_elements.add_child(paused)

func update_hull_bar(new_value):
	hud.update_hull(new_value)
