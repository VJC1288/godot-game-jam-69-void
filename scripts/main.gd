extends Node3D

const PLAYER = preload("res://scenes/player.tscn")
const PAUSE_MENU = preload("res://scenes/pause_menu.tscn")
const GAME_OVER = preload("res://scenes/game_over.tscn")

@onready var ui_elements = $UIElements
@onready var orbiter_manager = $OrbiterManager
@onready var enemy_container = $OrbiterManager/EnemyContainer
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
	player.fireTopLaser.connect(orbiter_manager.spawn_top_laser)
	player.fireBottomLaser.connect(orbiter_manager.spawn_bottom_laser)
	player.player_hull_changed.connect(update_hull_bar)
	player.player_shield_changed.connect(update_shield_bar)
	player.player_energy_changed.connect(update_energy_cells)
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
	if new_value <= 0:
		game_over()

func update_shield_bar(new_value):
	hud.update_shield(new_value)

func update_energy_cells(adjustment):
	hud.update_energy(adjustment)

func game_over():
	var gameoverscreen = GAME_OVER.instantiate()
	gameoverscreen.restart_game.connect(restart_game)
	ui_elements.add_child(gameoverscreen)

func restart_game():
	get_tree().call_deferred("reload_current_scene")
