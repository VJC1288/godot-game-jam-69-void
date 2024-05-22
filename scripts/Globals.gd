extends Node

const VE_MODEL = preload("res://scenes/ve_model.tscn")

var current_player: Node
var current_energy: int
var fighters_defeated: int
var bombers_defeated: int
var beamers_defeated: int
var juggernaut_defeated: int
var total_energy_collected: int
var total_damage_taken: int
var total_shots_fired: float
var times_overheated: int
var times_warped: int
var shots_hit: float
var easter_egg_listens: int

var endless_mode: bool

func resetGlobals(): #Does not reset easter egg listens!
	current_player = null
	endless_mode = false
	fighters_defeated = 0
	bombers_defeated = 0
	beamers_defeated = 0
	juggernaut_defeated = 0
	total_energy_collected = 0
	total_damage_taken = 0
	total_shots_fired = 0
	times_overheated = 0
	times_warped = 0
	shots_hit = 0
