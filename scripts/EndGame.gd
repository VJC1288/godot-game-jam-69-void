extends Node3D

const STARSHIP = preload("res://assets/models/starship.glb")
const GAME_OVER = preload("res://scenes/game_over.tscn")

@onready var end_game_camera = $EndGameCamera
@onready var end_game_animations = $EndGameAnimations
@onready var end_game_ship_position = $EndGameCamera/EndGameShipPosition

@onready var the_void = %TheVoid

const GAME_WIN = preload("res://scenes/game_win.tscn")

var player_camera: Camera3D = null

var camera_end_game_position
var camera_end_game_basis

var ui

func _ready():
	camera_end_game_position = end_game_camera.global_position
	camera_end_game_basis = end_game_camera.basis
	
func initialize(passed_ui):
	ui = passed_ui

func on_game_victory():
	var end_game_tween = camera_pan_out()	
	end_game_tween.finished.connect(play_victory_animation)
	
func on_game_defeat():
	var end_game_tween = camera_pan_out()
	end_game_tween.finished.connect(play_loss_animation)

func camera_pan_out() -> Tween:
	end_game_camera.global_position = player_camera.global_position
	end_game_camera.global_basis = player_camera.basis
	end_game_camera.current = true
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(end_game_camera, "global_position", camera_end_game_position,1.0)
	tween.tween_property(end_game_camera, "basis", camera_end_game_basis,1.0)
	
	return tween

func play_victory_animation():
	end_game_animations.play("victory")
	var player_model = STARSHIP.instantiate()
	add_child(player_model)
	player_model.global_position = Vector3(500,0,500)
	player_model.rotate_y(deg_to_rad(270))
	var tween = create_tween()
	tween.tween_property(player_model, "global_position", end_game_ship_position.global_position,3.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.finished.connect(add_win_message)

func add_win_message():
	var message = GAME_WIN.instantiate()
	ui.add_child(message)
	message.restart_game.connect(restart_game_call)

	
func play_loss_animation():
	end_game_animations.play("defeat")


func add_loss_message():
	var message = GAME_OVER.instantiate()
	ui.add_child(message)
	if Globals.current_player != null:
			message.energy_loss.visible = true
	message.restart_game.connect(restart_game_call)


func restart_game_call():
	Globals.resetGlobals()
	get_tree().call_deferred("reload_current_scene")
	
