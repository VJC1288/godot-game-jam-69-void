extends CanvasLayer

@onready var shield_bar = %ShieldBar
@onready var hull_bar = %HullBar
@onready var void_cell_1 = %VoidCell1
@onready var void_cell_2 = %VoidCell2
@onready var void_cell_3 = %VoidCell3
@onready var void_cell_4 = %VoidCell4
@onready var void_cell_5 = %VoidCell5

var total_energy:int = 0
var spilloverenergy: int = 0

func update_hull(new_value):
	hull_bar.value = new_value

func update_shield(new_value):
	shield_bar.value = new_value

func update_energy(added_value):
	total_energy += clamp(0, added_value, 500)
	if void_cell_1.value < 100:
		void_cell_1.value += added_value
		spilloverenergy = total_energy - 100
		if spilloverenergy > 0:
			void_cell_2.value += spilloverenergy
	elif void_cell_2.value < 100:
		void_cell_2.value += added_value
		spilloverenergy = total_energy - 200
		if spilloverenergy > 0:
			void_cell_3.value += spilloverenergy
	elif void_cell_3.value < 100:
		void_cell_3.value += added_value
		spilloverenergy = total_energy - 300
		if spilloverenergy > 0:
			void_cell_4.value += spilloverenergy
	elif void_cell_4.value < 100:
		void_cell_4.value += added_value
		spilloverenergy = total_energy - 400
		if spilloverenergy > 0:
			void_cell_5.value += spilloverenergy
	elif void_cell_5.value < 100:
		void_cell_5.value += added_value
