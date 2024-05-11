extends Node3D

class_name orbiter_manager

const PLAYERLASER = preload("res://scenes/playerlaser.tscn")

@export var DEFAULT_ORBIT_SPEED = .01
@export var DEFAULT_FALL_SPEED = 10

@export var DEFAULT_LASER_ORBIT_SPEED = DEFAULT_ORBIT_SPEED * 4

@onready var player_laser_container = $PlayerLaserContainer
@onready var player_container = $PlayerContainer
@onready var enemy_container = $EnemyContainer

var current_player = null

func _physics_process(delta):

	#Player falling towards black hole
	if current_player != null:
		player_container.rotation.y += DEFAULT_ORBIT_SPEED * delta
		current_player.position.z += DEFAULT_FALL_SPEED * delta
	
	#Laser movement managerment
	for l in player_laser_container.get_children():
		var direction = l.global_position.direction_to(Vector3.ZERO)
		l.global_position += DEFAULT_FALL_SPEED * delta * direction
	
	player_laser_container.rotation.y += DEFAULT_LASER_ORBIT_SPEED * delta

	for e in enemy_container.get_children():
		if e is Enemy:
			enemy_container.rotation.y += DEFAULT_ORBIT_SPEED * delta
			e.position.z += DEFAULT_FALL_SPEED * delta

func spawn_player_laser(firePoint):
	var spawned_laser = PLAYERLASER.instantiate()
	player_laser_container.add_child(spawned_laser)
	spawned_laser.global_rotation = player_container.rotation
	spawned_laser.global_position = firePoint
