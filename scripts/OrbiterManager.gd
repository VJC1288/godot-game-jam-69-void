extends Node3D

class_name OrbiterManager

const PLAYERLASER = preload("res://scenes/playerlaser.tscn")
const ASTEROID = preload("res://scenes/asteroid.tscn")

@export var num_of_asteroids:= 2500

@export var DEFAULT_ORBIT_SPEED = .02
@export var DEFAULT_FALL_SPEED = 5

@export var DEFAULT_LASER_ORBIT_SPEED = DEFAULT_ORBIT_SPEED * 8
@export var DEFAULT_ENEMY_LASER_ORBIT_SPEED = DEFAULT_ORBIT_SPEED * 1
@export var DEFAULT_PICKUP_ORBIT_SPEED = DEFAULT_ORBIT_SPEED * .01

@onready var player_laser_container = $PlayerLaserContainer
@onready var player_container = $PlayerContainer
@onready var enemy_container = $EnemyContainer
@onready var pickup_container = $PickupContainer
@onready var asteroid_manager = $AsteroidManager
@onready var enemy_attacks_container = $EnemyAttacksContainer
@onready var camera_pivot = $PlayerContainer/CameraPivot
@onready var enemy_lasers = $EnemyAttacksContainer/EnemyLasers
@onready var vertical_enemy_bombs = %VerticalEnemyBombs
@onready var horizontal_enemy_bombs = %HorizontalEnemyBombs
@onready var player_laser_sound = $"../Sounds/PlayerLaserSound"
@onready var screen_edge_container = $ScreenEdgeContainer

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
	
	#Enemy lasers movement management
	for a in enemy_lasers.get_children():
		var direction = a.global_position.direction_to(Vector3.ZERO)
		a.global_position += DEFAULT_FALL_SPEED * delta * direction
		
	enemy_lasers.rotation.y -= DEFAULT_ENEMY_LASER_ORBIT_SPEED * delta
	
	#Enemy vertical bomb movement
	for b in vertical_enemy_bombs.get_children():
		var direction = b.global_position.direction_to(Vector3.ZERO)
		b.global_position += DEFAULT_FALL_SPEED * delta * direction
		
	vertical_enemy_bombs.rotation.y += DEFAULT_ORBIT_SPEED * delta
	
	#Enemy horizontal bomb movement
	for b in horizontal_enemy_bombs.get_children():
		var direction = b.global_position.direction_to(Vector3.ZERO)
		b.global_position += DEFAULT_FALL_SPEED * delta * direction
		
	horizontal_enemy_bombs.rotation.y -= (DEFAULT_ORBIT_SPEED * .1) * delta
	
	#Pickup movement management
	for p in pickup_container.get_children():
		var direction = p.global_position.direction_to(Vector3.ZERO)
		p.global_position += DEFAULT_FALL_SPEED * delta * direction
	
	pickup_container.rotation.y -= DEFAULT_PICKUP_ORBIT_SPEED * delta

	#Enemy movement management
	for e in enemy_container.get_children():
		e.position.z += DEFAULT_FALL_SPEED * delta
		
	enemy_container.rotation.y += DEFAULT_ORBIT_SPEED * delta
	
	#Screen edge detector movement management
	for e in screen_edge_container.get_children():
		e.position.z += DEFAULT_FALL_SPEED * delta
		
	screen_edge_container.rotation.y += DEFAULT_ORBIT_SPEED * delta
	
func spawn_player_laser(firePoint):
	var spawned_laser = PLAYERLASER.instantiate()
	player_laser_container.add_child(spawned_laser)
	spawned_laser.global_rotation.y = player_container.rotation.y
	spawned_laser.global_position = firePoint
	player_laser_sound.play()
	if Globals.current_player.has_laser_upgrade:
		spawned_laser.mesh_instance_3d.mesh.material.albedo_color = Color(1,1,0,1)

func spawn_top_laser(firePoint):
	var spawned_laser = PLAYERLASER.instantiate()
	player_laser_container.add_child(spawned_laser)
	spawned_laser.global_rotation.y = player_container.rotation.y
	spawned_laser.global_position = firePoint

func spawn_bottom_laser(firePoint):
	var spawned_laser = PLAYERLASER.instantiate()
	player_laser_container.add_child(spawned_laser)
	spawned_laser.global_rotation.y = player_container.rotation.y
	spawned_laser.global_position = firePoint
