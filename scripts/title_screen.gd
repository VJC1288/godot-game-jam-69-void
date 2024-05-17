extends CanvasLayer

const INTRO_SCENE = preload("res://scenes/intro_scene.tscn")
const HOW_TO_PLAY = preload("res://scenes/how_to_play.tscn")

@onready var play_button = %PlayButton
@onready var how_to_play = %HowToPlay
@onready var good_luck = $GoodLuck
@onready var easter_egg_sounds = $EasterEggSounds

var easter_times_clicked: int = 0

func _ready():
	play_button.grab_focus()
	
func _on_play_button_pressed():
	get_tree().paused = false
	Globals.resetGlobals()
	play_button.disabled = true
	how_to_play.disabled = true
	play_button.release_focus()
	good_luck.play()
	await good_luck.finished
	get_tree().change_scene_to_packed(INTRO_SCENE)

func _on_how_to_play_pressed():
	var how_to_play_scene = HOW_TO_PLAY.instantiate()
	how_to_play_scene.close_how_to_play.connect(_on_play_button_mouse_entered)
	add_child(how_to_play_scene)

func _on_play_button_mouse_entered():
	play_button.grab_focus()
	
func _on_how_to_play_mouse_entered():
	how_to_play.grab_focus()
	
func _on_play_button_focus_entered():
	GlobalAudioManager.menu_move_sound.play()

func _on_how_to_play_focus_entered():
	GlobalAudioManager.menu_move_sound.play()


func _on_easter_button_pressed():
	easter_times_clicked += 1
	if easter_times_clicked % 5 == 0:
		if easter_egg_sounds.get_child_count() != 0:
			easter_egg_sounds.get_children().pick_random().play()
			Globals.easter_egg_listens += 1
