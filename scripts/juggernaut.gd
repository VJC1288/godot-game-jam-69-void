class_name Juggernaut

extends Enemy

signal fire_top_bomb(firePoint)
signal fire_bottom_bomb(firePoint)

@onready var top_hit_box = $JuggernautHitboxes/TopHitBox
@onready var bottom_hit_box = $JuggernautHitboxes/BottomHitBox
@onready var top_weak_point = %TopWeakPoint
@onready var bottom_weak_point = %BottomWeakPoint
@onready var top_bomb_cooldown = %TopBombCooldown
@onready var bottom_bomb_cooldown = %BottomBombCooldown
@onready var top_bomb_muzzle = %TopBombMuzzle
@onready var bottom_bomb_muzzle = %BottomBombMuzzle

@export var hull_component_top:HullComponent
@export var hull_component_bottom:HullComponent

var top_bomb_cd:int = randi_range(3,4)
var bottom_bomb_cd:int = randi_range(3,4)

func _fire_top_bomb():
	fire_top_bomb.emit(top_bomb_muzzle.global_position)
	top_bomb_cooldown.start(top_bomb_cd)
	
func _fire_bottom_bomb():
	fire_bottom_bomb.emit(bottom_bomb_muzzle.global_position)
	bottom_bomb_cooldown.start(bottom_bomb_cd)
	
func _physics_process(delta):
	match currentState:
		
		EnemyStates.ENTERING:
			checkPlayerDistance()
			direction.x = 1
			direction = direction.normalized()
			position.x = position.x + direction.x * SPEED * delta
			
		EnemyStates.ENGAGING:
			if top_bomb_cooldown.time_left == 0:
				_fire_top_bomb()
			if bottom_bomb_cooldown.time_left == 0:
				_fire_bottom_bomb()
			
		EnemyStates.DYING:
			direction = global_position.direction_to(Vector3.ZERO)
			direction = direction.normalized()
			global_position = global_position + direction * DEATH_SPEED * delta

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
	
