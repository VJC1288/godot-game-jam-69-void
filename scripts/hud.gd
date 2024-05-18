extends CanvasLayer

@onready var shield_bar = %ShieldBar
@onready var hull_bar = %HullBar
@onready var void_cell_1 = %VoidCell1
@onready var void_cell_2 = %VoidCell2
@onready var void_cell_3 = %VoidCell3
@onready var void_cell_4 = %VoidCell4
@onready var void_cell_5 = %VoidCell5
@onready var void_cell_6 = %VoidCell6
@onready var ui_splash_text = %UISplashText
@onready var void_cell_label = %VoidCellLabel
@onready var effect_timer = $EffectTimer
@onready var laser_upgrade_icon = %LaserUpgradeIcon
@onready var heat_upgrade_icon = %HeatUpgradeIcon
@onready var reserve_upgrade_icon = %ReserveUpgradeIcon
@onready var minimap = %Minimap
@onready var distance = %Distance
@onready var minimap_panel = %MinimapPanel

var void_cells:Array 

var total_energy:int = 0
var spilloverenergy: int = 0
var max_energy: int = 2500
var reserveCell: bool = false
var laserEff: bool = false

func _ready():
	void_cells = [void_cell_1, void_cell_2, void_cell_3, void_cell_4, void_cell_5, void_cell_6]

func update_hull(new_value):
	hull_bar.value = new_value

func update_shield(new_value):
	shield_bar.value = new_value

func update_energy(adjustment):
	total_energy = clamp(total_energy + adjustment, 0, max_energy)
	
	if reserveCell:
		if total_energy < 500:
			void_cell_1.value = total_energy
			void_cell_2.value = void_cell_2.min_value
			void_cell_3.value = void_cell_3.min_value
			void_cell_4.value = void_cell_4.min_value
			void_cell_5.value = void_cell_5.min_value
			void_cell_6.value = void_cell_6.min_value
		elif total_energy < 1000:
			void_cell_1.value = void_cell_1.max_value
			void_cell_2.value = total_energy % 500
			void_cell_3.value = void_cell_3.min_value
			void_cell_4.value = void_cell_4.min_value
			void_cell_5.value = void_cell_5.min_value
			void_cell_6.value = void_cell_6.min_value	
		elif total_energy < 1500:
			void_cell_1.value = void_cell_1.max_value
			void_cell_2.value = void_cell_2.max_value
			void_cell_3.value = total_energy % 500
			void_cell_4.value = void_cell_4.min_value
			void_cell_5.value = void_cell_5.min_value
			void_cell_6.value = void_cell_6.min_value
		elif total_energy < 2000:
			void_cell_1.value = void_cell_1.max_value
			void_cell_2.value = void_cell_2.max_value
			void_cell_3.value = void_cell_3.max_value
			void_cell_4.value = total_energy % 500
			void_cell_5.value = void_cell_5.min_value
			void_cell_6.value = void_cell_6.min_value
		elif total_energy < 2500:
			void_cell_1.value = void_cell_1.max_value
			void_cell_2.value = void_cell_2.max_value
			void_cell_3.value = void_cell_3.max_value
			void_cell_4.value = void_cell_4.max_value
			void_cell_5.value = total_energy % 500
			void_cell_6.value = void_cell_6.min_value
		elif total_energy < 3000:
			void_cell_1.value = void_cell_1.max_value
			void_cell_2.value = void_cell_2.max_value
			void_cell_3.value = void_cell_3.max_value
			void_cell_4.value = void_cell_4.max_value
			void_cell_5.value = void_cell_5.max_value
			void_cell_6.value = total_energy % 500
		elif total_energy == 3000:
			void_cell_1.value = void_cell_1.max_value
			void_cell_2.value = void_cell_2.max_value
			void_cell_3.value = void_cell_3.max_value
			void_cell_4.value = void_cell_4.max_value
			void_cell_5.value = void_cell_5.max_value
			void_cell_6.value = void_cell_6.max_value
			
	else:
		if total_energy < 500:
			void_cell_1.value = total_energy
			void_cell_2.value = void_cell_2.min_value
			void_cell_3.value = void_cell_3.min_value
			void_cell_4.value = void_cell_4.min_value
			void_cell_5.value = void_cell_5.min_value
		elif total_energy < 1000:
			void_cell_1.value = void_cell_1.max_value
			void_cell_2.value = total_energy % 500
			void_cell_3.value = void_cell_3.min_value
			void_cell_4.value = void_cell_4.min_value
			void_cell_5.value = void_cell_5.min_value
		elif total_energy < 1500:
			void_cell_1.value = void_cell_1.max_value
			void_cell_2.value = void_cell_2.max_value
			void_cell_3.value = total_energy % 500
			void_cell_4.value = void_cell_4.min_value
			void_cell_5.value = void_cell_5.min_value
		elif total_energy < 2000:
			void_cell_1.value = void_cell_1.max_value
			void_cell_2.value = void_cell_2.max_value
			void_cell_3.value = void_cell_3.max_value
			void_cell_4.value = total_energy % 500
			void_cell_5.value = void_cell_5.min_value
		elif total_energy < 2500:
			void_cell_1.value = void_cell_1.max_value
			void_cell_2.value = void_cell_2.max_value
			void_cell_3.value = void_cell_3.max_value
			void_cell_4.value = void_cell_4.max_value
			void_cell_5.value = total_energy % 500
		elif total_energy == 2500:
			void_cell_1.value = void_cell_1.max_value
			void_cell_2.value = void_cell_2.max_value
			void_cell_3.value = void_cell_3.max_value
			void_cell_4.value = void_cell_4.max_value
			void_cell_5.value = void_cell_5.max_value

func _on_enemy_container_laser_upgraded():
	laser_upgrade_icon.visible = true
	ui_splash_text.visible = true
	ui_splash_text.text = "Laser Upgrade \n Acquired"
	await get_tree().create_timer(2, false).timeout
	spashtexttween()

func has_reserve_cell():
	if !reserveCell:
		reserve_upgrade_icon.visible = true
		ui_splash_text.visible = true
		void_cell_6.visible = true
		void_cell_label.text = "           Void Cells"
		max_energy = 3000
		reserveCell = true
		
		ui_splash_text.text = "Reserve Cell \n Acquired"
		await get_tree().create_timer(2, false).timeout
		spashtexttween()

func has_laser_eff():
	if !laserEff:
		heat_upgrade_icon.visible = true
		ui_splash_text.visible = true
		laserEff = true
		ui_splash_text.text = "Laser Efficiency \n Module Acquired"
		await get_tree().create_timer(2, false).timeout
		spashtexttween()

func spashtexttween():
	var tween = create_tween()
	tween.tween_property(ui_splash_text.label_settings, "font_color", Color(1,1,1,0), 1)
	var shadow_tween = create_tween()
	shadow_tween.tween_property(ui_splash_text.label_settings, "shadow_color", Color(0,0,0,0), 1)
	await get_tree().create_timer(3, false).timeout
	ui_splash_text.visible = false
	ui_splash_text.label_settings.font_color = Color(1,1,1,1)
	ui_splash_text.label_settings.shadow_color = Color(0,0,0,1)

func voidCellEffect():
	for void_cell in void_cells:
		if void_cell.value == void_cell.max_value:
			var tween = create_tween()
			tween.tween_property(void_cell, "tint_progress", Color(0.875, 0, 0.875), 1).set_ease(Tween.EASE_IN_OUT)
			tween.tween_property(void_cell, "tint_progress", Color(0.329, 0, 0.459), 1).set_ease(Tween.EASE_IN_OUT)

func _on_effect_timer_timeout():
	voidCellEffect()

func toggle_map():
	minimap_panel.visible = !minimap_panel.visible
	distance.visible = !distance.visible

func update_distance_label(passed_distance: int):
	distance.text = str(passed_distance) + " km"
func clear_distance():
	distance.text = ""
