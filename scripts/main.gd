extends Node3D

const PLAYER = preload("res://scenes/player.tscn")
const PAUSE_MENU = preload("res://scenes/pause_menu.tscn")
const PLAYERLASER = preload("res://scenes/playerlaser.tscn")

@onready var ui_elements = $UIElements
@onready var orbiter_manager = $OrbiterManager
@onready var player_laser_container = $OrbiterManager/PlayerLaserContainer

var paused = null
var playerSpawnLocation = Vector3(0,0,-1000)

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	spawn_player(playerSpawnLocation)

func spawn_player(location:Vector3):
	var player = PLAYER.instantiate()
	player.fireLaser.connect(orbiter_manager.spawn_player_laser)
	orbiter_manager.player_container.add_child(player)
	orbiter_manager.current_player = player
	player.global_position = location
	Globals.current_player = player

func _input(event):
	if event.is_action_pressed("pause") and paused == null:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		paused = PAUSE_MENU.instantiate()
		ui_elements.add_child(paused)
