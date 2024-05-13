extends Enemy

class_name EnemyBomber

signal fireBomberBomb(muzzlePosition)

@onready var fire_detection = $FireDetection
@onready var bottom_muzzle = $BottomMuzzle
@onready var fire_cooldown = $FireCooldown

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
			#if currentDirection > 0:
				#rotation.y = lerp_angle(rotation.x, deg_to_rad(20), 0.5)
			#elif currentDirection < 0:
				#rotation.y = lerp_angle(rotation.x, deg_to_rad(-20), 0.5)
			#else:
				#rotation.y = lerp_angle(rotation.x, deg_to_rad(0), 0.5)

func fireDetection():
	if fire_detection.is_colliding() and fire_cooldown.time_left == 0:
		fireBomberBomb.emit(bottom_muzzle.global_position)
		fire_cooldown.start(3.5)
