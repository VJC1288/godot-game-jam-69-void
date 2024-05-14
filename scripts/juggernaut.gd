class_name Juggernaut

extends Enemy

@onready var top_hit_box = $JuggernautHitboxes/TopHitBox
@onready var bottom_hit_box = $JuggernautHitboxes/BottomHitBox
@onready var top_weak_point = $TopWeakPoint
@onready var bottom_weak_point = $BottomWeakPoint

@export var hull_component_top:HullComponent
@export var hull_component_bottom:HullComponent



func _physics_process(delta):
	match currentState:
		
		EnemyStates.ENTERING:
			checkPlayerDistance()
			direction.x = 1
			direction = direction.normalized()
			position.x = position.x + direction.x * SPEED * delta
			
		EnemyStates.ENGAGING:
			pass
			
		EnemyStates.DYING:
			direction = global_position.direction_to(Vector3.ZERO)
			direction = direction.normalized()
			global_position = global_position + direction * DEATH_SPEED * delta

func checkPlayerDistance():
	if visible_on_screen_notifier_3d.is_on_screen():
		currentState = EnemyStates.ENGAGING
		#print("Engage Player!!")

func _on_hull_component_top_defeated():
	hull_component.adjust_hull(-500)
	top_weak_point.mesh.material.albedo_color = Color(0,0,0,1)
	top_hit_box.set_deferred("monitorable", false)
	print("Top defeated")

func _on_hull_component_bottom_defeated():
	hull_component.adjust_hull(-500)
	bottom_weak_point.mesh.material.albedo_color = Color(0,0,0,1)
	bottom_hit_box.set_deferred("monitorable", false)
	print("Bottom defeated")
	
