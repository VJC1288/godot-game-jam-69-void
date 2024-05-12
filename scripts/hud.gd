extends CanvasLayer

@onready var shield_bar = %ShieldBar
@onready var hull_bar = %HullBar

func update_hull(new_value):
	hull_bar.value = new_value
