extends Node3D

signal containerFighterLaser(fighter_muzzle)

@onready var enemy_spawn_location = %EnemySpawnLocation
@onready var spawn_timer = %SpawnTimer
@onready var enemy_attacks_container = $"../EnemyAttacksContainer"

const FIGHTER = preload("res://scenes/enemies/fighter.tscn")
const FIGHTERLASER = preload("res://scenes/enemies/fighterlaser.tscn")

func _ready():
	spawnFighter()
	
func spawnFighter():
	spawn_timer.start(4)
	var fighter = FIGHTER.instantiate()
	add_child(fighter)
	fighter.fireFighterLaser.connect(spawn_fighter_laser)
	fighter.global_position = Vector3(enemy_spawn_location.global_position.x, randi_range(-14,14), enemy_spawn_location.global_position.z)
	fighter = null
	

func _on_spawn_timer_timeout():
	spawnFighter()

func _input(event):
	if event.is_action_pressed("debugspawnenemy"):
		spawnFighter()

func spawn_fighter_laser(firePoint):
	var spawned_laser = FIGHTERLASER.instantiate()
	enemy_attacks_container.add_child(spawned_laser)
	spawned_laser.global_rotation = rotation
	spawned_laser.global_position = firePoint

func clear_enemies():
	for e in get_children():
		e.queue_free()
