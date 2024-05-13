extends Enemy

class_name EnemyBeamFighter

signal fireBeamLaser(muzzlePosition)

@onready var fire_detection = $FireDetection
@onready var center_muzzle = $CenterMuzzle
@onready var fire_cooldown = $FireCooldown
@onready var shot_cooldown = $ShotCooldown

var beam_ready: bool = true

func fireDetection():
	fireBeam()
		
func fireBeam():
	if !fire_cooldown.is_stopped():
		prints("beam mode:" , beam_ready)
		if shot_cooldown.is_stopped() and beam_ready:
			print("firing")
			fireBeamLaser.emit(center_muzzle.global_position)
			shot_cooldown.start()
			
	else:
		fire_cooldown.start()
		beam_ready = !beam_ready
		
#func fireDetection():
	#fireBeam(4)
	#beamCooldown(4)
	#
#func fireBeam(duration):
	#if beam_ready:
		#fireBeamLaser.emit(center_muzzle.global_position)
		#await get_tree().create_timer(duration).timeout
		#beam_ready = false
	#
#func beamCooldown(cooldown):
	#if !beam_ready:
		#await get_tree().create_timer(cooldown).timeout
		#beam_ready = true
