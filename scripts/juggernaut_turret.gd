extends RigidBody3D

signal fireBeamLaser(muzzlePosition)

@onready var turret_muzzle = $TurretMuzzle
@onready var shot_cooldown = $ShotCooldown

func fireBeam():
	if shot_cooldown.is_stopped():
		fireBeamLaser.emit(turret_muzzle.global_position)
		shot_cooldown.start()
