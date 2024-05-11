extends Node3D

const PLAYER = preload("res://scenes/player.tscn")
const PAUSE_MENU = preload("res://scenes/pause_menu.tscn")
const PLAYERLASER = preload("res://scenes/playerlaser.tscn")

@onready var ui_elements = $UIElements
@onready var player_projectile_container = $PlayerProjectileContainer


var paused = null
var playerSpawnLocation = Vector3(0,0,0)

func _ready():
	spawn_player(playerSpawnLocation)

func spawn_player(location:Vector3):
	var player = PLAYER.instantiate()
	player.fireLaser.connect(playerLaser)
	add_child(player)
	player.global_position = location

func _input(event):
	if event.is_action_pressed("pause") and paused == null:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		paused = PAUSE_MENU.instantiate()
		ui_elements.add_child(paused)

func playerLaser(firePoint):
	var spawned_laser = PLAYERLASER.instantiate()
	player_projectile_container.add_child(spawned_laser)
	spawned_laser.laser.global_position = firePoint
	print(firePoint)
