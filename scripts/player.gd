extends RigidBody3D

class_name Player

const SHIELD_EFFECT = preload("res://scenes/shield_effect.tscn")
const SHORT_WARP_EFFECT = preload("res://scenes/short_warp_effect.tscn")
const PLAYERMUZZLEFLASH = preload("res://scenes/playermuzzleflash.tscn")

signal fireLaser(muzzlePosition)
signal fireTopLaser(muzzlePosition)
signal fireBottomLaser(muzzlePosition)
signal player_hull_changed(new_hull)
signal player_shield_changed(new_shield)
signal player_energy_changed(new_energy)

@onready var center_muzzle = $CenterMuzzle
@onready var top_muzzle = $TopMuzzle
@onready var bottom_muzzle = $BottomMuzzle
@onready var short_warp_sound = $ShortWarpSound
@onready var starship_model = $StarshipModel
@onready var shield_break_sound = $ShieldBreakSound
@onready var shield_hit_sound = $ShieldHitSound
@onready var heat_bar = $HeatBar
@onready var laser_cooldown = $LaserCooldown
@onready var void_energy_pickup_sound = $VoidEnergyPickupSound

@export var SPEED = 20
@export var hull_component: HullComponent
@export var shield_component: ShieldComponent
@export var has_laser_upgrade:bool
@export var has_reserve_cell:bool
@export var has_laser_efficiency: bool

var movement_clamp_vertical = 15
var movement_clamp_horizontal = movement_clamp_vertical * (16.0/9.0) #Aspect Ratio

var max_energy = 2500
var current_energy = 0
var direction: Vector2
var warp_available:bool = true
var old_shield: int = 100
var current_laser_heat: int = 0
var max_laser_heat: int = 100
var overheated:bool = false
var shooting:bool = false
var laser_heat_buildup = 15

func _physics_process(delta):
	
	
	check_laser_heat()
	update_laser_heat()
	
	if shooting and laser_cooldown.time_left == 0:
		shootLaser()
		laser_cooldown.start(.1)
	
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
		shooting = true
	if event.is_action_released("fire"):
		shooting = false
	if event.is_action_pressed("shortwarp"):
		short_warp()

func shootLaser():
	if !overheated:
		if has_laser_upgrade == true:
			fireLaser.emit(center_muzzle.global_position)
			fireTopLaser.emit(top_muzzle.global_position)
			fireBottomLaser.emit(bottom_muzzle.global_position)
			muzzle_flash()
			Globals.total_shots_fired += 1
		else:
			fireLaser.emit(center_muzzle.global_position)
			muzzle_flash()
			current_laser_heat = clamp(current_laser_heat+laser_heat_buildup, 0, max_laser_heat)
			Globals.total_shots_fired += 1

func _on_hull_component_hull_changed(new_hull):
	player_hull_changed.emit(new_hull)

func _on_shield_component_shield_changed(new_shield):
	if new_shield <= 0:
		shield_break_sound.play()
	elif new_shield < old_shield:
		shield_hit_sound.play()
	player_shield_changed.emit(new_shield)
	old_shield = new_shield
	
	
func adjust_void_energy(adjustment):
	Globals.total_energy_collected += adjustment
	current_energy = clamp(current_energy + adjustment, 0 , max_energy)
	if adjustment > 0:
		void_energy_pickup_sound.play()
		if shield_component.shield_regen_delay.is_stopped():
			shield_component.shield_regen()
	player_energy_changed.emit(adjustment)
	

func shield_effect():
	var shieldeffect = SHIELD_EFFECT.instantiate()
	add_child.call_deferred(shieldeffect)
	
func muzzle_flash():
	var flash = PLAYERMUZZLEFLASH.instantiate()
	add_child(flash)
	flash.global_position = center_muzzle.global_position
	await get_tree().create_timer(.5, false).timeout
	flash.queue_free()

func check_laser_heat():
	if current_laser_heat == max_laser_heat:
		Globals.times_overheated += 1
		overheated = true
		await get_tree().create_timer(1.5, false).timeout
		overheated = false

func update_laser_heat():
	current_laser_heat = clamp(current_laser_heat-1,0,100)
	heat_bar.value = current_laser_heat
	if current_laser_heat == 0:
		heat_bar.visible = false
	else:
		heat_bar.visible = true
	
func short_warp():
	
	if warp_available:
		#Handles warping out effect
		warp_available = false
		var warpout = SHORT_WARP_EFFECT.instantiate()
		add_child.call_deferred(warpout)
		warpout.position.x += 2
		var shrink_tween = create_tween()
		shrink_tween.tween_property(starship_model, "scale", Vector3(.1,.1,.1), .15)
		await get_tree().create_timer(.15, false).timeout
		
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
		
		await get_tree().create_timer(1, false).timeout
		warp_available = true
	
