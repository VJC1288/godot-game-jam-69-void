extends RigidBody3D

var x_rotation: float
var y_rotation: float
var z_rotation: float

var max_rotation_offset = 10

var random_rotation: float

func _ready():
	x_rotation = randf_range(-max_rotation_offset, max_rotation_offset)
	y_rotation = randf_range(-max_rotation_offset, max_rotation_offset)
	z_rotation = randf_range(-max_rotation_offset, max_rotation_offset)
	
	rotate_x(x_rotation)
	rotate_y(y_rotation)
	rotate_z(z_rotation)
	
	random_rotation = randf_range(0.0, 4.0)
	
func _physics_process(delta):
	
	rotate_object_local(Vector3(0,1,0), random_rotation * delta)
	

