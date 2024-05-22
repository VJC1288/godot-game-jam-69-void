extends Node3D

class_name OrbiterManager

const PLAYERLASER = preload("res://scenes/playerlaser.tscn")
const ASTEROID = preload("res://scenes/asteroid.tscn")
const PLAYERTRIPLELASER = preload("res://scenes/playertriplelaser.tscn")

@export var num_of_asteroids:= 2500

@export var default_orbit_speed = .02
@export var default_fall_speed = 5

@export var default_laser_orbit_speed = default_orbit_speed * 8
@export var default_enemy_laser_orbit_speed = default_orbit_speed * 1
@export var default_pickup_orbit_speed = default_orbit_speed * 0

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
		asteroid_to_spawn.scale *= randf_range(0.5, 6.0)
		if abs(asteroid_to_spawn.position.x) < 200 and abs(asteroid_to_spawn.position.z) < 200:
			pass
		else:
			asteroid_manager.add_child(asteroid_to_spawn)
		
	if Globals.endless_mode:
		default_fall_speed = 0

func _physics_process(delta):

	#Player falling towards black hole
	if current_player != null:
		player_container.rotation.y += default_orbit_speed * delta
		camera_pivot.position.z += default_fall_speed * delta
	
	#Laser movement management
	for l in player_laser_container.get_children():
		var direction = l.global_position.direction_to(Vector3.ZERO)
		l.global_position += default_fall_speed * delta * direction
	
	player_laser_container.rotation.y += default_laser_orbit_speed * delta
	
	#Enemy lasers movement management
	for a in enemy_lasers.get_children():
		var direction = a.global_position.direction_to(Vector3.ZERO)
		a.global_position += default_fall_speed * delta * direction
		
	enemy_lasers.rotation.y -= default_enemy_laser_orbit_speed * delta
	
	#Enemy vertical bomb movement
	for b in vertical_enemy_bombs.get_children():
		var direction = b.global_position.direction_to(Vector3.ZERO)
		b.global_position += default_fall_speed * delta * direction
		
	vertical_enemy_bombs.rotation.y += default_orbit_speed * delta
	
	#Enemy horizontal bomb movement
	for b in horizontal_enemy_bombs.get_children():
		var direction = b.global_position.direction_to(Vector3.ZERO)
		b.global_position += default_fall_speed * delta * direction
		
	horizontal_enemy_bombs.rotation.y -= (default_orbit_speed * .1) * delta
	
	#Pickup movement management
	for p in pickup_container.get_children():
		var direction = p.global_position.direction_to(Vector3.ZERO)
		p.global_position += default_fall_speed * delta * direction
	
	pickup_container.rotation.y -= default_pickup_orbit_speed * delta

	#Enemy movement management
	for e in enemy_container.get_children():
		e.position.z += default_fall_speed * delta
		
	enemy_container.rotation.y += default_orbit_speed * delta
	
	#Screen edge detector movement management
	for e in screen_edge_container.get_children():
		e.position.z += default_fall_speed * delta
		
	screen_edge_container.rotation.y += default_orbit_speed * delta

func spawn_player_laser(firePoint, pointRotation):
	if Globals.current_player.has_laser_upgrade:
		var spawned_laser = PLAYERTRIPLELASER.instantiate()
		player_laser_container.add_child(spawned_laser)
		spawned_laser.global_rotation.y = player_container.rotation.y
		spawned_laser.global_rotation.z = pointRotation.x
		spawned_laser.global_rotation.x = pointRotation.z
		spawned_laser.global_position = firePoint
		player_laser_sound.play()
	else:
		var spawned_laser = PLAYERLASER.instantiate()
		player_laser_container.add_child(spawned_laser)
		spawned_laser.global_rotation.y = player_container.rotation.y
		spawned_laser.global_position = firePoint
		player_laser_sound.play()

func _on_speed_increase_timer_timeout():
	print("GameSpeedUp")
	default_orbit_speed *= 1.05
	default_laser_orbit_speed = default_orbit_speed * 8
	default_enemy_laser_orbit_speed = default_orbit_speed * 1
	default_pickup_orbit_speed = default_orbit_speed * .01

