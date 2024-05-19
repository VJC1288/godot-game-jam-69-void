extends Node3D

@onready var starship = $starship

const TRANSIT_SPEED = 1
const WAVE_DEPTH = 2

func _process(delta):
	starship.position.x += TRANSIT_SPEED * delta
	starship.position.y += sin(Time.get_ticks_msec()/1010.0) * WAVE_DEPTH * delta
	starship.rotate_x(deg_to_rad(-10) * sin(Time.get_ticks_msec()/995.0) * delta)
