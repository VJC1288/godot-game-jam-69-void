extends Node3D

@onready var enemy_spawn_location = $EnemySpawnLocation
@onready var spawn_timer = %SpawnTimer

const ENEMY = preload("res://scenes/enemy.tscn")

func _ready():
	spawnEnemy()
	
func spawnEnemy():
	#spawn_timer.start(4)
	var enemy = ENEMY.instantiate()
	add_child(enemy)
	enemy.global_position = Vector3(enemy_spawn_location.global_position.x, randi_range(-14,14), enemy_spawn_location.global_position.z)
	print(enemy.global_position.y)
	enemy = null
	

func _on_spawn_timer_timeout():
	spawnEnemy()

func _input(event):
	if event.is_action_pressed("debugspawnenemy"):
		spawnEnemy()
