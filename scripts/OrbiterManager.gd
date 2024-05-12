extends Node3D

class_name OrbiterManager

const PLAYERLASER = preload("res://scenes/playerlaser.tscn")
const ASTEROID = preload("res://scenes/asteroid.tscn")

@export var num_of_asteroids:= 1000

@export var DEFAULT_ORBIT_SPEED = .02
@export var DEFAULT_FALL_SPEED = 5

@export var DEFAULT_LASER_ORBIT_SPEED = DEFAULT_ORBIT_SPEED * 8

@onready var player_laser_container = $PlayerLaserContainer
@onready var player_container = $PlayerContainer
@onready var enemy_container = $EnemyContainer
@onready var asteroid_manager = $AsteroidManager

var current_player = null

func _ready():
	for a in num_of_asteroids:
		var asteroid_to_spawn = ASTEROID.instantiate()
		asteroid_to_spawn.position.z = randi_range(-1000, 1000)
		asteroid_to_spawn.position.x = randi_range(-1000, 1000)
		asteroid_to_spawn.position.y = randi_range(-20, 20)
		asteroid_to_spawn.scale *= randf_range(0.5, 3.0)
		asteroid_manager.add_child(asteroid_to_spawn)


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
	
	print(asteroid_manager.get_children().size())
	

func spawn_player_laser(firePoint):
	var spawned_laser = PLAYERLASER.instantiate()
	player_laser_container.add_child(spawned_laser)
	spawned_laser.global_rotation = player_container.rotation
	spawned_laser.global_position = firePoint
