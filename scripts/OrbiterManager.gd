extends Node3D

class_name OrbiterManager

const PLAYERLASER = preload("res://scenes/playerlaser.tscn")
const ASTEROID = preload("res://scenes/asteroid.tscn")

@export var num_of_asteroids:= 2500

@export var DEFAULT_ORBIT_SPEED = .02
@export var DEFAULT_FALL_SPEED = 5

@export var DEFAULT_LASER_ORBIT_SPEED = DEFAULT_ORBIT_SPEED * 8
@export var DEFAULT_ENEMY_LASER_ORBIT_SPEED = DEFAULT_ORBIT_SPEED * 1

@onready var player_laser_container = $PlayerLaserContainer
@onready var player_container = $PlayerContainer
@onready var enemy_container = $EnemyContainer
@onready var asteroid_manager = $AsteroidManager
@onready var enemy_attacks_container = $EnemyAttacksContainer
@onready var camera_pivot = $PlayerContainer/CameraPivot

var current_player = null

func _ready():
	for a in num_of_asteroids:
		var asteroid_to_spawn = ASTEROID.instantiate()
		asteroid_to_spawn.position.z = randi_range(-1500, 1500)
		asteroid_to_spawn.position.x = randi_range(-1500, 1500)
		asteroid_to_spawn.position.y = randi_range(-20, 20)
		asteroid_to_spawn.scale *= randf_range(0.5, 3.0)
		if abs(asteroid_to_spawn.position.x) < 200 and abs(asteroid_to_spawn.position.z) < 200:
			pass
		else:
			asteroid_manager.add_child(asteroid_to_spawn)
		


func _physics_process(delta):


	#Player falling towards black hole
	if current_player != null:
		player_container.rotation.y += DEFAULT_ORBIT_SPEED * delta
		camera_pivot.position.z += DEFAULT_FALL_SPEED * delta
	
	#Laser movement management
	for l in player_laser_container.get_children():
		var direction = l.global_position.direction_to(Vector3.ZERO)
		l.global_position += DEFAULT_FALL_SPEED * delta * direction
	
	player_laser_container.rotation.y += DEFAULT_LASER_ORBIT_SPEED * delta
	
	#Enemy attack movement management
	for a in enemy_attacks_container.get_children():
		var direction = a.global_position.direction_to(Vector3.ZERO)
		a.global_position += DEFAULT_FALL_SPEED * delta * direction
	
	enemy_attacks_container.rotation.y -= DEFAULT_ENEMY_LASER_ORBIT_SPEED * delta

	#Enemy movement management
	for e in enemy_container.get_children():
		e.position.z += DEFAULT_FALL_SPEED * delta
		
	enemy_container.rotation.y += DEFAULT_ORBIT_SPEED * delta

	

func spawn_player_laser(firePoint):
	var spawned_laser = PLAYERLASER.instantiate()
	player_laser_container.add_child(spawned_laser)
	spawned_laser.global_rotation.y = player_container.rotation.y
	spawned_laser.global_position = firePoint
