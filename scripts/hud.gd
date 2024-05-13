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

func update_energy(adjustment):
	total_energy = clamp(total_energy + adjustment, 0, 500)
	print(total_energy)
	
	if total_energy < 100:
		void_cell_1.value = total_energy
		void_cell_2.value = void_cell_2.min_value
		void_cell_3.value = void_cell_3.min_value
		void_cell_4.value = void_cell_4.min_value
		void_cell_5.value = void_cell_5.min_value
	elif total_energy < 200:
		void_cell_1.value = void_cell_1.max_value
		void_cell_2.value = total_energy % 100
		void_cell_3.value = void_cell_3.min_value
		void_cell_4.value = void_cell_4.min_value
		void_cell_5.value = void_cell_5.min_value
	elif total_energy < 300:
		void_cell_1.value = void_cell_1.max_value
		void_cell_2.value = void_cell_2.max_value
		void_cell_3.value = total_energy % 100
		void_cell_4.value = void_cell_4.min_value
		void_cell_5.value = void_cell_5.min_value
	elif total_energy < 400:
		void_cell_1.value = void_cell_1.max_value
		void_cell_2.value = void_cell_2.max_value
		void_cell_3.value = void_cell_3.max_value
		void_cell_4.value = total_energy % 100
		void_cell_5.value = void_cell_5.min_value
	elif total_energy < 500:
		void_cell_1.value = void_cell_1.max_value
		void_cell_2.value = void_cell_2.max_value
		void_cell_3.value = void_cell_3.max_value
		void_cell_4.value = void_cell_4.max_value
		void_cell_5.value = total_energy % 100
	elif total_energy == 500:
		void_cell_1.value = void_cell_1.max_value
		void_cell_2.value = void_cell_2.max_value
		void_cell_3.value = void_cell_3.max_value
		void_cell_4.value = void_cell_4.max_value
		void_cell_5.value = void_cell_5.max_value
