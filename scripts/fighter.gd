extends Enemy

class_name EnemyFighter

signal fireFighterLaser(muzzlePosition)

@onready var fire_detection = $FireDetection
@onready var center_muzzle = $CenterMuzzle
@onready var fire_cooldown = $FireCooldown

func fireDetection():
	if fire_detection.is_colliding() and fire_cooldown.time_left == 0:
		fireFighterLaser.emit(center_muzzle.global_position)
		fire_cooldown.start(2)
