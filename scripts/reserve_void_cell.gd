extends Area3D

signal has_reserve_cell()

var energy_value:int = 100

func _ready():
	await get_tree().create_timer(5, false).timeout
	queue_free()

func _physics_process(delta):
	rotation.z += 2 * delta

func _on_area_entered(area):
	has_reserve_cell.emit()
	area.get_parent().max_energy = 3000
	area.get_parent().adjust_void_energy(energy_value)
	queue_free()
