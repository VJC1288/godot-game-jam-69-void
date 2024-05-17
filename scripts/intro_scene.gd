extends CanvasLayer

const MAIN = preload("res://scenes/main.tscn")
const KEYBOARD_CLICK_1 = preload("res://assets/sounds/keyboard_click1.mp3")
const KEYBOARD_CLICK_2 = preload("res://assets/sounds/keyboard_click2.mp3")
const KEYBOARD_CLICK_3 = preload("res://assets/sounds/keyboard_click3.mp3")

@onready var next_character = %NextCharacter
@onready var next_message = %NextMessage
@onready var message_box = %MessageBox
@onready var keyboard_clicks_player = $KeyboardClicksPlayer


var intro_messages = [
	"WE FIRST BATTLED THE VOIDLINGS IN THE KUIPER BELT. IT WAS THERE THAT WE LEARNED THEY CAME FROM AND COULD TRAVERSE THE UNIVERSE'S BLACK HOLES.",
	"WE NEXT FOUGHT THE VOIDLINGS NEAR NEPTUNE, AS THEY CREPT CLOSER TO OUR HOME. WE WERE COMPLETELY ERADICATED, SAVE FOR A FEW BRAVE SOULS WHO WOULD COMMANDEER THE TECHNOLOGY OF THEIR SHIPS.",
	"I PERSONALLY DELIVERED IT TO THE EARTH SO SCIENTISTS COULD STUDY ITS ENERGY PRODUCING QUALITIES...",
	"THE SCIENTISTS' FINDINGS WERE ASTOUNDING! THEY DISCOVERED THAT THE POWERS OF THE VOIDLINGS MIGHT BE HARNESSED FOR THE GOOD OF CIVILIZATION!",
	"NOT A MOMENT AFTER THE FIRST OFFICIAL EVENT HORIZON DRIVE WAS INSTALLED WE PICKED UP A VOIDLING FLEET HEADING TOWARDS THE EARTH.",
	"THERE WAS NO TIME LEFT! I TOOK THE FIGHT TO THEM!!"
]
var message_speed:float = .085
var message_time:float = 3
var text_to_display = ""

var current_message:int = 0
var current_char:int = 0

var keyboard_clicks:Array = [KEYBOARD_CLICK_1,KEYBOARD_CLICK_2,KEYBOARD_CLICK_3]

func _ready():
	start_message()

func start_message():
	current_message = 0
	current_char = 0
	text_to_display = ""
	
	next_character.start(message_speed)
	
func end_messages():
	get_tree().change_scene_to_packed(MAIN)
	
func _on_next_character_timeout():
	if (current_char < len(intro_messages[current_message])):
		var next_char = intro_messages[current_message][current_char]
		text_to_display += next_char
		
		message_box.text = text_to_display
		current_char += 1
		keyboard_clicks_player.stream = keyboard_clicks[randi_range(0,2)]
		keyboard_clicks_player.play()
	else:
		next_character.stop()
		next_message.one_shot = true
		next_message.start(message_time)

func _on_next_message_timeout():
	if current_message == (len(intro_messages) - 1):
		end_messages()
	else:
		current_message += 1
		text_to_display = ""
		current_char = 0
		next_character.start()

func _input(event):
	if event.is_action_pressed("pause"):
		get_tree().change_scene_to_packed(MAIN)
