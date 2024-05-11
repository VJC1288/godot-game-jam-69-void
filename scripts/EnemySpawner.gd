extends Node3D

@onready var enemy_spawn_location = $EnemySpawnLocation

const ENEMY = preload("res://scenes/enemy.tscn")

func _ready():
	var enemy = ENEMY.instantiate()
	add_child(enemy)
	enemy.global_position = enemy_spawn_location.global_position
