extends RigidBody3D

class_name Player

const SHIELD_EFFECT = preload("res://scenes/shield_effect.tscn")
const SHORT_WARP_EFFECT = preload("res://scenes/short_warp_effect.tscn")

signal fireLaser(muzzlePosition)
signal player_hull_changed(new_hull)
signal player_shield_changed(new_shield)
signal player_energy_changed(new_energy)

@onready var center_muzzle = $CenterMuzzle
@onready var short_warp_sound = $ShortWarpSound
@onready var starship_model = $StarshipModel

@export var SPEED = 20
@export var hull_component: HullComponent
@export var shield_component: ShieldComponent

var movement_clamp_vertical = 15
var movement_clamp_horizontal = movement_clamp_vertical * (16.0/9.0) #Aspect Ratio

var max_energy = 500
var current_energy = 0
var direction: Vector2
var warp_available:bool = true

func _physics_process(delta):

	direction = Vector2.ZERO
	
	if Input.is_action_pressed("move_up"):
		rotation.z = lerp_angle(rotation.z, deg_to_rad(-30), 0.5)
		direction.y = 1
	elif Input.is_action_pressed("move_down"):
		rotation.z = lerp_angle(rotation.z, deg_to_rad(30), 0.5)
		direction.y = -1
	else:
		rotation.z = lerp_angle(rotation.z, deg_to_rad(0), 0.5)
		
	if Input.is_action_pressed("move_left"):
		direction.x = 1
	elif Input.is_action_pressed("move_right"):
		direction.x = -1
	
	direction = direction.normalized()
	
	position.x = clamp(position.x + direction.x * SPEED * delta, -movement_clamp_horizontal, movement_clamp_horizontal)
	position.y = clamp(position.y + direction.y * SPEED * delta, -movement_clamp_vertical, movement_clamp_vertical)
	
func _input(event):
	if event.is_action_pressed("fire"):
		fireLaser.emit(center_muzzle.global_position)

	if event.is_action_pressed("shortwarp"):
		short_warp()
		
func _on_hull_component_hull_changed(new_hull):
	player_hull_changed.emit(new_hull)

func _on_shield_component_shield_changed(new_shield):
	player_shield_changed.emit(new_shield)

func adjust_void_energy(adjustment):
	current_energy = clamp(current_energy + adjustment, 0 , max_energy)
	player_energy_changed.emit(adjustment)

func shield_effect():
	var shieldeffect = SHIELD_EFFECT.instantiate()
	add_child.call_deferred(shieldeffect)

func short_warp():
	
	if warp_available:
		#Handles warping out effect
		warp_available = false
		var warpout = SHORT_WARP_EFFECT.instantiate()
		add_child.call_deferred(warpout)
		warpout.position.x += 2
		var shrink_tween = create_tween()
		shrink_tween.tween_property(starship_model, "scale", Vector3(.1,.1,.1), .15)
		await get_tree().create_timer(.15).timeout
		
		#Warps forward by default if player is stationary, otherwise warps in current direction
		if direction.x == 0 and direction.y == 0:
			position.x = clamp(position.x + -8, -movement_clamp_horizontal, movement_clamp_horizontal)
		else:
			position.x = clamp(position.x + direction.x * 8, -movement_clamp_horizontal, movement_clamp_horizontal)
			position.y = clamp(position.y + direction.y * 8, -movement_clamp_vertical, movement_clamp_vertical)
			
		#Handles warping in effect
		var warpin = SHORT_WARP_EFFECT.instantiate()
		add_child.call_deferred(warpin)
		warpin.position.x += 2
		var enlarge_tween = create_tween()
		enlarge_tween.tween_property(starship_model, "scale", Vector3(.5,.5,.5), .15)
		
		short_warp_sound.play()
		
		await get_tree().create_timer(1).timeout
		warp_available = true
	
