extends Node3D

@onready var top = $AccuracyBox/Top
@onready var center = $AccuracyBox/Center
@onready var bottom = $AccuracyBox/Bottom

func _ready():
	if Globals.current_player.has_laser_upgrade:
		top.disabled = false
		bottom.disabled = false

func _on_accuracy_box_area_entered(area):
	if area.has_method("take_damage"):
		Globals.shots_hit += 1
		print("Shot hit!")
