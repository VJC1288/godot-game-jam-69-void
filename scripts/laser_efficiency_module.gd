extends Area3D

signal has_laser_efficiency()

var energy_value:int = 35

func _ready():
	await get_tree().create_timer(5, false).timeout
	queue_free()

func _physics_process(delta):
	rotation.z += 2 * delta

func _on_area_entered(area):
	has_laser_efficiency.emit()
	area.get_parent().laser_heat_buildup = 13
	area.get_parent().has_laser_efficiency = true
	area.get_parent().adjust_void_energy(energy_value)
	queue_free()
