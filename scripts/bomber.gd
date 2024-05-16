extends Enemy

class_name EnemyBomber

signal fireBomberBomb(muzzlePosition, delay)

@onready var fire_detection = $FireDetection
@onready var bottom_muzzle = $BottomMuzzle
@onready var fire_cooldown = $FireCooldown

func _ready():
	currentDirection = directionArray[randi_range(0,1)]

func _physics_process(delta):
	
	match currentState:
		
		EnemyStates.ENTERING:
			checkPlayerDistance()
			direction.y = -1
			direction = direction.normalized()
			position.y = position.y + direction.y * SPEED * delta
			
		EnemyStates.ENGAGING:
			direction.x = currentDirection
			direction = direction.normalized()
			position.x = clamp(position.x + direction.x * ENGAGE_SPEED * delta, -movement_clamp_horizontal, movement_clamp_horizontal)
			fireDetection()

		EnemyStates.DYING:
			direction = global_position.direction_to(Vector3.ZERO)
			direction = direction.normalized()
			global_position = global_position + direction * DEATH_SPEED * delta

func randomizeMovement():
	var randomMovement: int = randi_range(3,4)
	currentDirection *= -1
	movement_timer.start(randomMovement)

func fireDetection():
	if fire_cooldown.time_left == 0:
		var explosion_delay: float = randf_range(.5, 1.8)
		fireBomberBomb.emit(bottom_muzzle.global_position, explosion_delay)
		fire_cooldown.start(randf_range(1.8,2.5))
		
func _on_wall_detector_screen_exited():
	currentDirection *= -1

func _on_hull_component_defeated():
	enemyDefeated.emit(global_position, void_value, enemy_type)
	hitbox_component.set_deferred("monitorable", false)
	currentState = EnemyStates.DYING
	fireBomberBomb.emit(global_position, 0)
