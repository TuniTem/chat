extends Node2D

const SCREEN_SCENES : Dictionary = {
	"webfishing" : preload("res://scenes/webfishing_screens.tscn")
}

@export var screen_scene : String = "webfishing" 

func _ready() -> void:
	clear()
	ControlPanel.button_pressed.connect(_on_controller_button_pressed)

func _on_controller_button_pressed(data : String):
	if data in ["brb", "starting", "ending", "none"]: 
		load_new_screen(data)

func clear():
	for child in get_children():
		child.queue_free()

func load_new_screen(screen_id : String):
	clear()
	if screen_id != "none":
		print("loading scene " + screen_id)
		var inst = SCREEN_SCENES[screen_scene].instantiate()
		inst.screen_id = screen_id
		Global.screen_id = screen_id
		add_child(inst)
	

func _input(event: InputEvent) -> void:
	#for screen in ["brb", "starting", "ending"]:
		#if event.is_action_pressed(screen):
			#load_new_screen(screen)
	
	if event.is_action_pressed("exit"):
		if get_child(0):
			get_child(0).fade()
