extends Node3D

@onready var right_enemy_spawn_location = %RightEnemySpawnLocation
@onready var top_enemy_spawn_location = %TopEnemySpawnLocation
@onready var spawn_timer = %SpawnTimer
@onready var enemy_lasers = $"../EnemyAttacksContainer/EnemyLasers"
@onready var enemy_bombs = $"../EnemyAttacksContainer/EnemyBombs"
@onready var pickup_container = $"../PickupContainer"
@onready var fighter_death = $"../../Sounds/FighterDeath"

const FIGHTER = preload("res://scenes/enemies/fighter.tscn")
const FIGHTERLASER = preload("res://scenes/enemies/fighterlaser.tscn")
const BOMBER = preload("res://scenes/enemies/bomber.tscn")
const VOID_ENERGY = preload("res://scenes/void_energy.tscn")
const BOMBER_BOMB = preload("res://scenes/enemies/bomber_bomb.tscn")
const BOMBER_BOMB_EXPLOSION = preload("res://scripts/bomber_bomb_explosion.tscn")
const BEAMFIGHTER = preload("res://scenes/enemies/beamfighter.tscn")
const BEAMLASER = preload("res://scenes/enemies/beamlaser.tscn")

func _ready():
	spawnFighter()
	#spawnBeamFighter()
	
func spawnFighter():
	spawn_timer.start(randf_range(3,5))
	var fighter = FIGHTER.instantiate()
	add_child(fighter)
	fighter.fireFighterLaser.connect(spawn_fighter_laser)
	fighter.enemyDefeated.connect(spawnVoidEnergy)
	fighter.global_position = Vector3(right_enemy_spawn_location.global_position.x, randi_range(-14,14), right_enemy_spawn_location.global_position.z)
	fighter = null

func spawnBeamFighter():
	#spawn_timer.start(randf_range(3,5))
	var beam_fighter = BEAMFIGHTER.instantiate()
	add_child(beam_fighter)
	beam_fighter.fireBeamLaser.connect(spawn_beam_laser)
	beam_fighter.enemyDefeated.connect(spawnVoidEnergy)
	beam_fighter.global_position = Vector3(right_enemy_spawn_location.global_position.x, randi_range(-14,14), right_enemy_spawn_location.global_position.z)
	beam_fighter = null

func spawnBomber():
	#spawn_timer.start(4)
	var bomber = BOMBER.instantiate()
	add_child(bomber)
	bomber.fireBomberBomb.connect(spawn_bomber_bomb)
	bomber.enemyDefeated.connect(spawnVoidEnergy)
	bomber.global_position = Vector3(top_enemy_spawn_location.global_position.x, top_enemy_spawn_location.global_position.y, top_enemy_spawn_location.global_position.z)
	bomber = null
	
func _on_spawn_timer_timeout():
	spawnFighter()
	
	var bomber_chance: float = randi_range(1,100)
	if bomber_chance <= 25:
		await get_tree().create_timer(randf_range(0,2)).timeout
		spawnBomber()
		
	var beam_fighter_chance: float = randi_range(1,100)
	if beam_fighter_chance <= 25:
		await get_tree().create_timer(randf_range(0,2)).timeout
		spawnBeamFighter()

func _input(event):
	if event.is_action_pressed("debugspawnenemy"):
		spawnFighter()

func spawn_fighter_laser(firePoint):
	var spawned_laser = FIGHTERLASER.instantiate()
	enemy_lasers.add_child(spawned_laser)
	spawned_laser.global_rotation = rotation
	spawned_laser.global_position = firePoint

func spawn_beam_laser(firePoint):
	var spawned_laser = BEAMLASER.instantiate()
	enemy_lasers.add_child(spawned_laser)
	spawned_laser.global_rotation = rotation
	spawned_laser.global_position = firePoint

func spawn_bomber_bomb(firePoint):
	var spawned_bomb = BOMBER_BOMB.instantiate()
	enemy_bombs.add_child(spawned_bomb)
	spawned_bomb.enemy_bomb_explode.connect(spawn_bomb_explosion)
	spawned_bomb.global_rotation = rotation
	spawned_bomb.global_position = firePoint

func spawn_bomb_explosion(location):
	var spawned_bomb_explosion = BOMBER_BOMB_EXPLOSION.instantiate()
	enemy_bombs.add_child(spawned_bomb_explosion)
	spawned_bomb_explosion.global_position = location

func clear_enemies():
	for e in get_children():
		e.queue_free()

func spawnVoidEnergy(location, value, type):
	var energy_drop = VOID_ENERGY.instantiate()
	pickup_container.add_child(energy_drop)
	energy_drop.energy_value = value
	energy_drop.global_position = location
	if type == "Fighter":
		fighter_death.play()
