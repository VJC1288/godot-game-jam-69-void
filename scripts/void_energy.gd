extends Area3D

var energy_value:int

func _on_area_entered(area):
	area.get_parent().adjust_void_energy(energy_value)
	queue_free()