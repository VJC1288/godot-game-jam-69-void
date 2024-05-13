extends Area3D

class_name BomberBomb

func _ready():
	await get_tree().create_timer(2.5).timeout
	queue_free()

func _physics_process(delta):
	position.y -= delta * 5

func _on_area_entered(area):
	if area is PlayerHitboxComponent:
		queue_free()
