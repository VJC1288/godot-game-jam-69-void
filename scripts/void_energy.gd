extends Area3D

var energy_value:int

@onready var ring_1 = $Ring1
@onready var ring_2 = $Ring2
@onready var ring_3 = $Ring3

@export var can_timeout:bool = true

func _ready():
	if can_timeout:
		await get_tree().create_timer(5, false).timeout
		queue_free()

func _on_area_entered(area):
	area.get_parent().adjust_void_energy(energy_value)
	queue_free()

func _physics_process(delta):
	ring_1.rotate_x(2 * delta)
	ring_2.rotate_x(2 * delta)
	ring_3.rotate_z(2 * delta)
	#if energy_value >= 500:
		#position.x -= .2
	#else:
		#position.x -= .13
