extends CanvasLayer

const MAIN = preload("res://scenes/main.tscn")
const HOW_TO_PLAY = preload("res://scenes/how_to_play.tscn")

@onready var play_button = %PlayButton
@onready var how_to_play = %HowToPlay

func _ready():
	play_button.grab_focus()
	
func _on_play_button_pressed():
	get_tree().change_scene_to_packed(MAIN)

func _on_how_to_play_pressed():
	var how_to_play_scene = HOW_TO_PLAY.instantiate()
	how_to_play_scene.close_how_to_play.connect(_on_play_button_mouse_entered)
	add_child(how_to_play_scene)

func _on_play_button_mouse_entered():
	play_button.grab_focus()

func _on_how_to_play_mouse_entered():
	how_to_play.grab_focus()
