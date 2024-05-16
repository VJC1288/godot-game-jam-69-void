class_name Juggernaut

extends Enemy

signal fire_top_bomb(firePoint)
signal fire_bottom_bomb(firePoint)

@onready var top_hit_box = $JuggernautHitboxes/TopHitBox
@onready var bottom_hit_box = $JuggernautHitboxes/BottomHitBox
@onready var top_bomb_cooldown = %TopBombCooldown
@onready var bottom_bomb_cooldown = %BottomBombCooldown
@onready var top_bomb_muzzle = %TopBombMuzzle
@onready var bottom_bomb_muzzle = %BottomBombMuzzle
@onready var juggernaut_turret = $JuggernautTurret
@onready var top_weak_spot_broken_nodes = $WeakSpotBrokenNodes/TopWeakSpotBrokenNodes
@onready var bottom_weak_spot_broken_nodes = $WeakSpotBrokenNodes/BottomWeakSpotBrokenNodes
@onready var bomb_reset_timer = $AttackTimers/BombResetTimer
@onready var defeat_indicator_timer = $DefeatIndicatorTimer

@onready var top_weak_disable_model_1 = %TopWeakDisableModel1
@onready var top_weak_disable_model_2 = %TopWeakDisableModel2
@onready var bottom_weak_disable_model_1 = %BottomWeakDisableModel1
@onready var bottom_weak_disable_model_2 = %BottomWeakDisableModel2


@export var hull_component_top:HullComponent
@export var hull_component_bottom:HullComponent

var top_bomb_cd:float = randf_range(2,3)
var bottom_bomb_cd:float = randf_range(2,3)
var move_turret: float = .05

func _fire_top_bomb():
	fire_top_bomb.emit(top_bomb_muzzle.global_position, 1.8)
	top_bomb_cooldown.start(top_bomb_cd)
	
func _fire_bottom_bomb():
	fire_bottom_bomb.emit(bottom_bomb_muzzle.global_position, 1.8)
	bottom_bomb_cooldown.start(bottom_bomb_cd)
	
func _physics_process(delta):
	match currentState:
		
		EnemyStates.ENTERING:
			checkPlayerDistance()
			direction.x = 1
			direction = direction.normalized()
			position.x = position.x + direction.x * SPEED * delta
			
		EnemyStates.ENGAGING:
			if top_bomb_cooldown.time_left == 0 and !bomb_reset_timer.is_stopped():
				_fire_top_bomb()
			if bottom_bomb_cooldown.time_left == 0 and !bomb_reset_timer.is_stopped():
				_fire_bottom_bomb()
			juggernaut_turret.fireBeam()
		
			if juggernaut_turret.position.y >= 6 or juggernaut_turret.position.y <= -6:
				move_turret *= -1
				juggernaut_turret.position.y += move_turret
			else:
				juggernaut_turret.position.y += move_turret

		EnemyStates.DYING:
			direction = global_position.direction_to(Vector3.ZERO)
			direction = direction.normalized()
			global_position = global_position + direction * DEATH_SPEED * delta



func _on_hull_component_top_defeated():
	hull_component.adjust_hull(-500)
	#top_weak_point.mesh.material.albedo_color = Color(0,0,0,1)
	top_hit_box.set_deferred("monitorable", false)
	defeat_indicator_timer.start(.26)


func _on_hull_component_bottom_defeated():
	hull_component.adjust_hull(-500)
	#bottom_weak_point.mesh.material.albedo_color = Color(0,0,0,1)
	bottom_hit_box.set_deferred("monitorable", false)
	defeat_indicator_timer.start(.26)
	
func checkPlayerDistance():
	if on_screen:
		currentState = EnemyStates.ENGAGING

func _on_bomb_reset_timer_timeout():
	await get_tree().create_timer(5, false).timeout
	bomb_reset_timer.start(18)

func _on_hull_component_top_hull_changed(new_hull):
	if new_hull != 0 and new_hull < hull_component_top.max_hull:
		ship_damage_indication(top_weak_disable_model_1)
		ship_damage_indication(top_weak_disable_model_2)
		
func _on_hull_component_bottom_hull_changed(new_hull):
	if new_hull != 0 and new_hull < hull_component_bottom.max_hull:	
		ship_damage_indication(bottom_weak_disable_model_1)
		ship_damage_indication(bottom_weak_disable_model_2)
		
func ship_damage_indication(model):
	
	var tween = create_tween()
	tween.tween_property(model, "visible", true, flash_time)
	tween.tween_property(model, "visible", false, flash_time)
	tween.tween_property(model, "visible", true, flash_time)
	tween.tween_property(model, "visible", false, flash_time)
	tween.tween_property(model, "visible", true, flash_time)
	tween.tween_property(model, "visible", false, flash_time)
	tween.tween_property(model, "visible", true, flash_time)
	tween.tween_property(model, "visible", false, flash_time)
	tween.tween_property(model, "visible", true, flash_time)
	tween.tween_property(model, "visible", false, flash_time)
	
func _on_defeat_indicator_timer_timeout():
	if hull_component_top.current_hull == 0:
		top_weak_disable_model_1.visible = true
		top_weak_disable_model_2.visible = true
	if hull_component_bottom.current_hull == 0:
		bottom_weak_disable_model_1.visible = true
		bottom_weak_disable_model_2.visible = true
