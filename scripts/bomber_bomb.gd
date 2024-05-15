extends Area3D

class_name BomberBomb

signal enemy_bomb_explode(impact_point)

@onready var mesh_instance_3d_2 = $MeshInstance3D2
@onready var mesh_instance_3d = $MeshInstance3D

@onready var scale_timer = $ScaleTimer


func _ready():
	await get_tree().create_timer(1.8, false).timeout
	enemy_bomb_explode.emit(global_position)
	queue_free()

func _physics_process(delta):
	if get_parent() is HorizontalBomb:
		pass
	else:
		position.y -= delta * 12
	
	if scale_timer.is_stopped():
		mesh_instance_3d.scale *= 1.1
		mesh_instance_3d_2.scale *= 1.1
		scale_timer.start()
	
	if mesh_instance_3d.scale.x >= 1.4:
		mesh_instance_3d.scale = Vector3(1,1,1)
		mesh_instance_3d_2.scale = Vector3(1,1,1)

func _on_area_entered(area):
	if area is PlayerHitboxComponent:
		enemy_bomb_explode.emit(global_position)
		queue_free()
