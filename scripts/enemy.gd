extends RigidBody3D

class_name Enemy

@onready var movement_timer = $MovementTimer
@onready var visible_on_screen_notifier_3d = $VisibleOnScreenNotifier3D

enum EnemyStates {ENTERING, ENGAGING}

@export var hull_component: HullComponent

var movement_clamp_vertical = 15
#var movement_clamp_horizontal = movement_clamp_vertical * (16.0/9.0)

var SPEED:int = 20
var ENGAGE_SPEED:int = 8 
var currentState = EnemyStates.ENTERING
var direction = Vector2.ZERO
var directionArray:Array = [-1,1]
var currentDirection:int

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
			
func checkPlayerDistance():
	if global_transform.origin.distance_to(Globals.current_player.global_position) < 30 and visible_on_screen_notifier_3d.is_on_screen():
		currentState = EnemyStates.ENGAGING
		#print("Engage Player!!")
		randomizeMovement()

func randomizeMovement():
	var randomMovement: int = randi_range(1,3)
	currentDirection *= -1 
	movement_timer.start(randomMovement)

func _on_movement_timer_timeout():	
	randomizeMovement()

func fireDetection():
	pass
