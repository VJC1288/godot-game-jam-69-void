extends RigidBody3D

class_name Enemy

@onready var movement_timer = $MovementTimer

enum EnemyStates {ENTERING, ENGAGING}

@export var health_component: HealthComponent

var movement_clamp_vertical = 15
#var movement_clamp_horizontal = movement_clamp_vertical * (16.0/9.0)

var SPEED:int = 20
var ENGAGE_SPEED:int = 8 
var currentState = EnemyStates.ENTERING
var direction = Vector2.ZERO

func _physics_process(delta):
	
	match currentState:
		
		EnemyStates.ENTERING:
			checkPlayerDistance()
			direction.x = 10
			direction = direction.normalized()
			position.x = position.x + direction.x * SPEED * delta
			
		EnemyStates.ENGAGING:
			direction = direction.normalized()
			position.y = clamp(position.y + direction.y * ENGAGE_SPEED * delta, -movement_clamp_vertical, movement_clamp_vertical)

func checkPlayerDistance():
	if global_transform.origin.distance_to(Globals.current_player.global_position) < 20:
		currentState = EnemyStates.ENGAGING
		print("Engage Player!!")

func randomizeMovement():
	var randomMovement: int = randi_range(1,10)
	print(randomMovement)
	print(direction.y)
	if randomMovement >= 5:
		direction.y *= -1
	movement_timer.start(4)

func _on_movement_timer_timeout():
	randomizeMovement()
