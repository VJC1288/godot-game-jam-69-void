extends CanvasLayer

signal close_stats()

@onready var title_label_1 = %TitleLabel1
@onready var title_label_2 = %TitleLabel2
@onready var fighters = %Fighters
@onready var bombers = %Bombers
@onready var beamers = %Beamers
@onready var juggernaut = %Juggernaut
@onready var total_energy = %TotalEnergy
@onready var damage_taken = %DamageTaken
@onready var shots_fired = %ShotsFired
@onready var times_overheated = %TimesOverheated
@onready var accuracy = %Accuracy
@onready var back_button = $MarginContainer/Panel/MarginContainer/VBoxContainer/BackButton



func _ready():
	
	back_button.grab_focus()
	
	fighters.text = str(Globals.fighters_defeated)
	bombers.text = str(Globals.bombers_defeated)
	beamers.text = str(Globals.beamers_defeated)
	juggernaut.text = str(Globals.juggernaut_defeated)
	
	total_energy.text = str(Globals.total_energy_collected)
	shots_fired.text = str(Globals.total_shots_fired)
	if Globals.total_shots_fired != 0:
		var accNum: float = snapped((Globals.shots_hit / Globals.total_shots_fired), 0.01)
		accuracy.text = str(accNum * 100, "%")
	times_overheated.text = str(Globals.times_overheated)
	damage_taken.text = str(Globals.total_damage_taken * -1)
	


func _on_back_button_pressed():
	close_stats.emit()
	queue_free()

func _on_back_button_mouse_entered():
	back_button.grab_focus()
	
func _on_back_button_focus_entered():
	GlobalAudioManager.menu_move_sound.play()
