extends Node3D

signal fireLaser(muzzlePosition)

@onready var camera_pivot = $CameraPivot
@onready var starship = $Starship
@onready var center_muzzle = $Starship/CenterMuzzle

@export var SPEED = 20

var movement_clamp_vertical = 15
var movement_clamp_horizontal = movement_clamp_vertical * (16.0/9.0) #Aspect Ratio

func _physics_process(delta):

	var direction:= Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		starship.rotation.z = lerp_angle(starship.rotation.z, deg_to_rad(-30), 0.5)
		direction.y = 1
	elif Input.is_action_pressed("move_down"):
		starship.rotation.z = lerp_angle(starship.rotation.z, deg_to_rad(30), 0.5)
		direction.y = -1
	else:
		starship.rotation.z = lerp_angle(starship.rotation.z, deg_to_rad(0), 0.5)
		
	if Input.is_action_pressed("move_left"):
		direction.x = 1
	elif Input.is_action_pressed("move_right"):
		direction.x = -1
	
	direction = direction.normalized()
	
	starship.position.x = clamp(starship.position.x + direction.x * SPEED * delta, -movement_clamp_horizontal, movement_clamp_horizontal)
	starship.position.y = clamp(starship.position.y + direction. y * SPEED * delta, -movement_clamp_vertical, movement_clamp_vertical)
	
func _input(event):
	if event.is_action_pressed("fire"):
		fireLaser.emit(center_muzzle.global_position)
