extends Laser

@onready var top_laser = $TopLaser
@onready var center_laser = $CenterLaser
@onready var bottom_laser = $BottomLaser
@onready var accuracy_boxes = $AccuracyBoxes

func _on_accuracy_boxes_area_entered(area):
	var actor = area.get_parent()
	if actor is Enemy:
		Globals.shots_hit += 1
		accuracy_boxes.set_deferred("monitoring", false)
