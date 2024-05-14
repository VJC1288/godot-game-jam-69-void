extends Area3D

class_name HurtboxComponent

var actor: Node

func _ready():
	actor = get_parent()

func _on_area_entered(area):
	if area.has_method("take_damage"):
		area.take_damage(actor.damage)
		if actor.isLaser:
			actor.queue_free()
