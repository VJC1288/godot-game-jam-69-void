extends RigidBody3D

class_name Enemy

signal enemyDefeated(location, value, type)

@onready var movement_timer = $MovementTimer
@onready var hitbox_component = $HitboxComponent
@onready var collision_shape = $CollisionShape3D

enum EnemyStates {ENTERING, ENGAGING, DYING}

@export var hull_component: HullComponent
@export var void_value:int
@export var ENGAGE_SPEED:int = 8
@export var DEATH_SPEED:int = 100
@export_enum("Fighter", "Beam_Fighter", "Bomber", "Juggernaut") var enemy_type:String

var movement_clamp_vertical = 15
var movement_clamp_horizontal = movement_clamp_vertical * (16.0/9.0)

var SPEED:int = 20
var currentState = EnemyStates.ENTERING
var direction = Vector2.ZERO
var directionArray:Array = [-1,1]
var currentDirection:int
var on_screen:bool = false

func _ready():
	currentDirection = directionArray[randi_range(0,1)]

	
func _physics_process(delta):
	match currentState:
		
		EnemyStates.ENTERING:
			checkPlayerDistance()
			direction.x = 1
			direction = direction.normalized()
			position.x = position.x + direction.x * SPEED * delta
			
			
		EnemyStates.ENGAGING:
			direction.y = currentDirection
			direction = direction.normalized()
			position.y = clamp(position.y + direction.y * ENGAGE_SPEED * delta, -movement_clamp_vertical, movement_clamp_vertical)
			fireDetection()
			if currentDirection > 0:
				rotation.x = lerp_angle(rotation.x, deg_to_rad(20), 0.5)
			elif currentDirection < 0:
				rotation.x = lerp_angle(rotation.x, deg_to_rad(-20), 0.5)
			else:
				rotation.x = lerp_angle(rotation.x, deg_to_rad(0), 0.5)
			
		EnemyStates.DYING:
			direction = global_position.direction_to(Vector3.ZERO)
			direction = direction.normalized()
			global_position = global_position + direction * DEATH_SPEED * delta
			
func checkPlayerDistance():
	if global_transform.origin.distance_to(Globals.current_player.global_position) < 30 and on_screen:
		currentState = EnemyStates.ENGAGING
		#print("Engage Player!!")
		randomizeMovement()

func randomizeMovement():
	var randomMovement: int = randi_range(2,3)
	currentDirection *= -1
	movement_timer.start(randomMovement)

func _on_movement_timer_timeout():	
	randomizeMovement()

func fireDetection():
	pass

func _on_hull_component_defeated():
	enemyDefeated.emit(global_position, void_value, enemy_type)
	hitbox_component.set_deferred("monitorable", false)
	currentState = EnemyStates.DYING


func _on_on_screen_detect_area_entered(_area):
	on_screen = true

func _on_wall_detector_area_exited(_area):
	currentDirection *= -1
	print("bounce bitch")
