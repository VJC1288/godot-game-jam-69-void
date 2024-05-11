extends Node3D

@onready var world_pivot:Node3D = $WorldPivot
@onready var camera_pivot = $WorldPivot/CameraPivot
@onready var starship = $WorldPivot/CameraPivot/StarshipBody

@export var SPEED = 20
@export var FALL_SPEED = 10
@export var ORBIT_SPEED = .1

var movement_clamp_vertical = 15
var movement_clamp_horizontal = movement_clamp_vertical * (16.0/9.0) #Aspect Ratio

func _physics_process(delta):
	
	world_pivot.rotation.y += ORBIT_SPEED * delta
	camera_pivot.position.z += FALL_SPEED * delta
	
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
	
