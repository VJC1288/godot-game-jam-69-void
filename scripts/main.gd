extends Node3D

const PLAYER = preload("res://scenes/player.tscn")
const PAUSE_MENU = preload("res://scenes/pause_menu.tscn")


@onready var ui_elements = $UIElements
@onready var orbiter_manager = $OrbiterManager
@onready var enemy_container = $OrbiterManager/EnemyContainer
@onready var player_laser_container = $OrbiterManager/PlayerLaserContainer
@onready var enemy_attacks_container = $OrbiterManager/EnemyAttacksContainer
@onready var hud = $UIElements/HUD
@onready var player_camera = $OrbiterManager/PlayerContainer/CameraPivot/Camera3D
@onready var end_game_node= $World/EndGame
@onready var minimap_viewport = $MinimapViewport
@onready var the_void = %TheVoid

var paused = null

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	end_game_node.initialize(ui_elements)
	spawn_player()

func spawn_player():
	var player = PLAYER.instantiate()
	player.fireLaser.connect(orbiter_manager.spawn_player_laser)
	player.player_hull_changed.connect(update_hull_bar)
	player.player_shield_changed.connect(update_shield_bar)
	player.player_energy_changed.connect(update_energy_cells)
	orbiter_manager.camera_pivot.add_child(player)
	player.global_position.x += 18
	orbiter_manager.current_player = player
	end_game_node.player_camera = player_camera
	Globals.current_player = player
	hud.update_distance_label(Globals.current_player.global_position.distance_to(the_void.global_position) - 500 )

func _input(event):
	if event.is_action_pressed("pause") and paused == null:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		paused = PAUSE_MENU.instantiate()
		ui_elements.add_child(paused)
	
	if Input.is_action_just_pressed("toggle_map"):
		hud.toggle_map()

func _process(_delta):
	if Globals.current_player != null and the_void != null:
		if Globals.current_player.global_position.distance_to(the_void.global_position) - 500 > 0:
			if int(Globals.current_player.global_position.distance_to(the_void.global_position) - 500) % 5 == 0:
				hud.update_distance_label(Globals.current_player.global_position.distance_to(the_void.global_position) - 500 )
			else:
				pass
		else: 
			hud.clear_distance()


func update_hull_bar(new_value):
	hud.update_hull(new_value)
	if new_value <= 0:
		end_game_sequence("loss")

func update_shield_bar(new_value):
	hud.update_shield(new_value)

func update_energy_cells(adjustment):
	hud.update_energy(adjustment)

func end_game_sequence(result: String):
	
	if result == "win":
		end_game_node.on_game_victory()
	elif result == "loss":
		end_game_node.on_game_defeat()

func restart_game():
	Globals.resetGlobals()
	get_tree().call_deferred("reload_current_scene")

	
