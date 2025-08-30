extends RichTextLabel

const PREFIX = "[float amp=4 rot_amp=6 min_speed=0.4 max_speed=2.0]"
const SCREEN_TEXT : Dictionary[String, String] = {
	"brb" : "BE RIGHT BACK",
	"starting": "STARTING SOON 🤍",
	"ending": "ENDING SOON ;~;",
	"none": ""
} 


@onready var line_edit: LineEdit = $LineEdit

@export var holder : Node2D

var editing = false

func _ready() -> void:
	Net.button_pressed.connect(_on_controller_button_pressed)

func text_to(to : String):
	if to == "":
		holder.modulate = Color.TRANSPARENT
	else:
		holder.modulate = Color.WHITE
	
	text = PREFIX + to



func _on_controller_button_pressed(data : String):
	if data in ["brb", "starting", "ending", "none"] and Global.constellation_manager.big_mode: 
		text_to(SCREEN_TEXT[data])

func _input(event: InputEvent) -> void:
	if Util.input_context != "default" and Util.input_context != "typing" : return
	for screen : String in ["brb", "starting", "ending"]:
		if event.is_action_pressed(screen):
			text_to(SCREEN_TEXT[screen])
	
	
	if event.is_action_pressed("text_edit"):
		editing = not editing
		if editing:
			line_edit.text = text.split("]")[-1]
			line_edit.grab_focus()
			Util.set_input_context("typing")
		else:
			line_edit.release_focus()
			Util.set_input_context("default")


func _on_line_edit_text_changed(new_text: String) -> void:
	if editing:
		text_to(new_text)
