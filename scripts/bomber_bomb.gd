extends Area3D

class_name BomberBomb

signal enemy_bomb_explode(impact_point)

func _ready():
	await get_tree().create_timer(1.8).timeout
	enemy_bomb_explode.emit(global_position)
	queue_free()

func _physics_process(delta):
	position.y -= delta * 12

func _on_area_entered(area):
	if area is PlayerHitboxComponent:
		enemy_bomb_explode.emit(global_position)
		queue_free()
