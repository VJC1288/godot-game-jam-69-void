extends Node3D

signal laser_upgraded()

@onready var right_enemy_spawn_location = %RightEnemySpawnLocation
@onready var top_enemy_spawn_location = %TopEnemySpawnLocation
@onready var spawn_timer = %SpawnTimer
@onready var enemy_lasers = $"../EnemyAttacksContainer/EnemyLasers"
@onready var enemy_bombs = %EnemyBombs
@onready var vertical_enemy_bombs = %VerticalEnemyBombs
@onready var horizontal_enemy_bombs = %HorizontalEnemyBombs
@onready var pickup_container = $"../PickupContainer"
@onready var fighter_death_sound = $"../../Sounds/FighterDeathSound"
@onready var bomber_death_sound = $"../../Sounds/BomberDeathSound"
@onready var beamer_death_sound = $"../../Sounds/BeamerDeathSound"
@onready var juggernaut_death_sound = $"../../Sounds/JuggernautDeathSound"
@onready var hud = $"../../UIElements/HUD"

const FIGHTER = preload("res://scenes/enemies/fighter.tscn")
const FIGHTERLASER = preload("res://scenes/enemies/fighterlaser.tscn")
const BOMBER = preload("res://scenes/enemies/bomber.tscn")
const VOID_ENERGY = preload("res://scenes/void_energy.tscn")
const BOMBER_BOMB = preload("res://scenes/enemies/bomber_bomb.tscn")
const BOMBER_BOMB_EXPLOSION = preload("res://scenes/enemies/bomber_bomb_explosion.tscn")
const BEAMFIGHTER = preload("res://scenes/enemies/beamfighter.tscn")
const BEAMLASER = preload("res://scenes/enemies/beamlaser.tscn")
const JUGGERNAUT = preload("res://scenes/enemies/juggernaut.tscn")
const RESERVE_VOID_CELL = preload("res://scenes/reserve_void_cell.tscn")

var juggernaut_spawned:bool = false

func _ready():
	#pass
	spawnFighter()
	#spawnBeamFighter()
	#spawnBomber()
	#spawnJuggernaut()
	
func spawnFighter():
	spawn_timer.start(randf_range(3,5))
	var fighter = FIGHTER.instantiate()
	add_child(fighter)
	fighter.fireFighterLaser.connect(spawn_fighter_laser)
	fighter.enemyDefeated.connect(enemyDeathActions)
	fighter.global_position = Vector3(right_enemy_spawn_location.global_position.x, randi_range(-12,14), right_enemy_spawn_location.global_position.z)
	fighter = null

func spawnBeamFighter():
	#spawn_timer.start(randf_range(3,5))
	var beam_fighter = BEAMFIGHTER.instantiate()
	add_child(beam_fighter)
	beam_fighter.fireBeamLaser.connect(spawn_beam_laser)
	beam_fighter.enemyDefeated.connect(enemyDeathActions)
	beam_fighter.global_position = Vector3(right_enemy_spawn_location.global_position.x, randi_range(-12,14), right_enemy_spawn_location.global_position.z)
	beam_fighter = null

func spawnBomber():
	#spawn_timer.start(4)
	var bomber = BOMBER.instantiate()
	add_child(bomber)
	bomber.fireBomberBomb.connect(spawn_bomber_bomb)
	bomber.enemyDefeated.connect(enemyDeathActions)
	bomber.global_position = Vector3(top_enemy_spawn_location.global_position.x, top_enemy_spawn_location.global_position.y, top_enemy_spawn_location.global_position.z)
	bomber = null

func spawnJuggernaut():
	clear_enemies()
	spawn_timer.stop()
	juggernaut_spawned = true
	var juggernaut = JUGGERNAUT.instantiate()
	add_child(juggernaut)
	juggernaut.fire_top_bomb.connect(spawn_horizontal_bomb)
	juggernaut.fire_bottom_bomb.connect(spawn_horizontal_bomb)
	juggernaut.enemyDefeated.connect(enemyDeathActions)
	juggernaut.juggernaut_turret.fireBeamLaser.connect(spawn_beam_laser)
	juggernaut.global_position = right_enemy_spawn_location.global_position
	juggernaut = null
	
func _on_spawn_timer_timeout():
	
	var juggernaut_chance: float = randi_range(1,100)
	if Globals.current_player != null:
		if Globals.current_player.current_energy >= 1250 and juggernaut_chance <= 10 and juggernaut_spawned == false:
			spawnJuggernaut()
		else:
			spawnFighter()
			
			var bomber_chance: float = randi_range(1,100)
			if bomber_chance <= 25:
				await get_tree().create_timer(randf_range(0,2), false).timeout
				spawnBomber()
				
			var beam_fighter_chance: float = randi_range(1,100)
			if beam_fighter_chance <= 25:
				await get_tree().create_timer(randf_range(0,2), false).timeout
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
	vertical_enemy_bombs.add_child(spawned_bomb)
	spawned_bomb.enemy_bomb_explode.connect(spawn_bomb_explosion)
	spawned_bomb.global_rotation = rotation
	spawned_bomb.global_position = firePoint
	
func spawn_horizontal_bomb(firePoint):
	var spawned_bomb = BOMBER_BOMB.instantiate()
	horizontal_enemy_bombs.add_child(spawned_bomb)
	spawned_bomb.enemy_bomb_explode.connect(spawn_bomb_explosion)
	spawned_bomb.global_rotation = rotation
	spawned_bomb.global_position = firePoint

func spawn_bomb_explosion(location):
	var spawned_bomb_explosion = BOMBER_BOMB_EXPLOSION.instantiate()
	vertical_enemy_bombs.add_child(spawned_bomb_explosion)
	spawned_bomb_explosion.global_position = location

func clear_enemies():
	for e in get_children():
		e.currentState = e.EnemyStates.DYING

func enemyDeathActions(location, value, type):
	if type == "Fighter":
		fighter_death_sound.play()
		spawnVoidEnergy(location, value)
	elif type == "Bomber":
		bomber_death_sound.play()
		spawnVoidEnergy(location, value)
	elif type == "Beam_Fighter":
		beamer_death_sound.play()
		var reserve_cell_chance = randf_range(1,100)
		if reserve_cell_chance < 15:
			spawnReserveCell(location)
		else:
			spawnVoidEnergy(location, value)
	elif type == "Juggernaut":
		juggernaut_death_sound.play()
		spawn_timer.start(randf_range(3,5))
		Globals.current_player.has_laser_upgrade = true
		laser_upgraded.emit()
		spawnVoidEnergy(location, value)
		
func spawnReserveCell(location):
	var reserve_cell = RESERVE_VOID_CELL.instantiate()
	pickup_container.add_child(reserve_cell)
	reserve_cell.has_reserve_cell.connect(hud.has_reserve_cell)
	reserve_cell.global_position = location
	
func spawnVoidEnergy(location, value):
	var energy_drop = VOID_ENERGY.instantiate()
	pickup_container.add_child(energy_drop)
	energy_drop.energy_value = value
	energy_drop.global_position = location
	if value >= 500:
		energy_drop.scale = Vector3(5,5,5)
